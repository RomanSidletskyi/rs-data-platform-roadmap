-- P03 load and model: COPY new files, flatten into STG, rebuild the MART serving tables. Run as P03_OWNER.
-- Safe to rerun after every fetch and upload.

USE ROLE P03_OWNER;
USE WAREHOUSE P03_WH;
USE DATABASE P03_CONTENT;

COPY INTO RAW.PAGEVIEWS_RAW (PAYLOAD, SRC_FILE, LOADED_AT)
FROM (SELECT $1, METADATA$FILENAME, METADATA$START_SCAN_TIME FROM @RAW.PAGEVIEWS_STAGE)
FILE_FORMAT = (FORMAT_NAME = 'RAW.FF_API_JSON')
ON_ERROR = SKIP_FILE;

-- One row per project, day, and article in the published top list (about 1000 per day).
-- A re-downloaded day replaces the whole list: the latest file per project and day wins.
CREATE OR REPLACE TABLE STG.TOP_ARTICLE_DAILY AS
SELECT
  i.value:project::STRING                                                         AS PROJECT,
  DATE_FROM_PARTS(i.value:year::INT, i.value:month::INT, i.value:day::INT)        AS DAY,
  a.value:article::STRING                                                         AS ARTICLE,
  a.value:views::NUMBER                                                           AS VIEWS,
  a.value:rank::NUMBER                                                            AS API_RANK,
  r.SRC_FILE,
  r.LOADED_AT
FROM RAW.PAGEVIEWS_RAW r,
  LATERAL FLATTEN(input => r.PAYLOAD:items) i,
  LATERAL FLATTEN(input => i.value:articles) a
WHERE r.PAYLOAD:_source:kind::STRING = 'top'
QUALIFY r.LOADED_AT = MAX(r.LOADED_AT) OVER (PARTITION BY PROJECT, DAY);

-- One row per project and day: all user (non-bot) pageviews. Aggregate files overlap; the latest wins per day.
CREATE OR REPLACE TABLE STG.PROJECT_DAILY AS
SELECT
  i.value:project::STRING                                     AS PROJECT,
  TO_DATE(LEFT(i.value:timestamp::STRING, 8), 'YYYYMMDD')     AS DAY,
  i.value:views::NUMBER                                       AS VIEWS,
  r.SRC_FILE,
  r.LOADED_AT
FROM RAW.PAGEVIEWS_RAW r,
  LATERAL FLATTEN(input => r.PAYLOAD:items) i
WHERE r.PAYLOAD:_source:kind::STRING = 'aggregate'
QUALIFY ROW_NUMBER() OVER (PARTITION BY PROJECT, DAY ORDER BY r.LOADED_AT DESC) = 1;

-- Serving layer: small tables shaped for the app's screens. COPY GRANTS keeps the app's SELECT grant
-- across rebuilds, so the app never sees "object does not exist or not authorized" during a reload.

CREATE OR REPLACE TABLE MART.ARTICLE_DAILY COPY GRANTS AS
SELECT
  t.PROJECT,
  t.DAY,
  t.ARTICLE,
  REPLACE(t.ARTICLE, '_', ' ')                                              AS TITLE,
  'https://' || t.PROJECT || '.org/wiki/' || t.ARTICLE                      AS URL,
  t.VIEWS,
  ROW_NUMBER() OVER (PARTITION BY t.PROJECT, t.DAY ORDER BY t.VIEWS DESC, t.ARTICLE) AS CONTENT_RANK,
  t.VIEWS / NULLIF(p.VIEWS, 0)                                              AS SHARE_OF_PROJECT
FROM STG.TOP_ARTICLE_DAILY t
JOIN STG.PROJECT pr ON pr.PROJECT = t.PROJECT
LEFT JOIN STG.PROJECT_DAILY p ON p.PROJECT = t.PROJECT AND p.DAY = t.DAY
WHERE t.ARTICLE <> pr.MAIN_PAGE
  AND NOT (
    CONTAINS(t.ARTICLE, ':')
    AND EXISTS (
      SELECT 1 FROM STG.NON_CONTENT_NAMESPACE n
      WHERE n.PROJECT = t.PROJECT AND n.NAMESPACE = SPLIT_PART(t.ARTICLE, ':', 1)
    )
  );

-- Trending: today's views against the average of the previous seven days, counting only days the article
-- was in the top list. Days outside the list are unknown, not zero, so the baseline is biased upward.
CREATE OR REPLACE TABLE MART.TRENDING COPY GRANTS AS
SELECT
  c.PROJECT,
  c.DAY,
  c.ARTICLE,
  c.TITLE,
  c.URL,
  c.VIEWS,
  c.CONTENT_RANK,
  COUNT(p.DAY)                              AS DAYS_IN_TOP_PRIOR_7,
  AVG(p.VIEWS)                              AS AVG_VIEWS_PRIOR_7,
  c.VIEWS / NULLIF(AVG(p.VIEWS), 0)         AS TREND_RATIO,
  IFF(COUNT(p.DAY) = 0, 'new in top list', 'returning') AS STATUS
FROM MART.ARTICLE_DAILY c
LEFT JOIN MART.ARTICLE_DAILY p
  ON  p.PROJECT = c.PROJECT
  AND p.ARTICLE = c.ARTICLE
  AND p.DAY BETWEEN DATEADD(day, -7, c.DAY) AND DATEADD(day, -1, c.DAY)
GROUP BY c.PROJECT, c.DAY, c.ARTICLE, c.TITLE, c.URL, c.VIEWS, c.CONTENT_RANK;

CREATE OR REPLACE TABLE MART.PROJECT_DAILY COPY GRANTS AS
SELECT
  p.PROJECT,
  pr.LABEL,
  p.DAY,
  p.VIEWS,
  AVG(p.VIEWS) OVER (PARTITION BY p.PROJECT ORDER BY p.DAY ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS VIEWS_MA7,
  p.VIEWS - LAG(p.VIEWS) OVER (PARTITION BY p.PROJECT ORDER BY p.DAY)                                AS VIEWS_CHANGE
FROM STG.PROJECT_DAILY p
JOIN STG.PROJECT pr ON pr.PROJECT = p.PROJECT;

-- A view over RAW and STG: the app owner can read it without any privilege on RAW or STG,
-- because a view runs with its owner's privileges.
CREATE OR REPLACE VIEW MART.V_FRESHNESS COPY GRANTS AS
SELECT
  (SELECT MAX(LOADED_AT) FROM RAW.PAGEVIEWS_RAW) AS LAST_LOAD_AT,
  (SELECT MIN(DAY) FROM STG.TOP_ARTICLE_DAILY)   AS FIRST_DAY,
  (SELECT MAX(DAY) FROM STG.TOP_ARTICLE_DAILY)   AS LAST_DAY,
  (SELECT COUNT(DISTINCT PROJECT) FROM STG.TOP_ARTICLE_DAILY) AS PROJECTS;

-- First run creates the grants; later runs keep them through COPY GRANTS. Explicit grants stay idempotent.
GRANT SELECT ON TABLE MART.ARTICLE_DAILY TO ROLE P03_APP_OWNER;
GRANT SELECT ON TABLE MART.TRENDING      TO ROLE P03_APP_OWNER;
GRANT SELECT ON TABLE MART.PROJECT_DAILY TO ROLE P03_APP_OWNER;
GRANT SELECT ON VIEW  MART.V_FRESHNESS   TO ROLE P03_APP_OWNER;

SELECT PROJECT, MIN(DAY) AS FIRST_DAY, MAX(DAY) AS LAST_DAY, COUNT(DISTINCT DAY) AS DAYS, COUNT(*) AS ROWS_
FROM MART.ARTICLE_DAILY
GROUP BY 1
ORDER BY 1;
