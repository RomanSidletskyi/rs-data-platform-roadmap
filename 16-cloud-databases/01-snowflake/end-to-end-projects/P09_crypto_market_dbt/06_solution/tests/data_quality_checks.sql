-- P09 data quality checks on production schemas. Run after a scheduled run.
-- Part 1 runs as P09_OWNER (stage, raw, alerts); part 2 as P09_TRANSFORMER, which owns the schemas dbt builds.
-- dbt tests guard each build; these queries answer the questions a person asks when something looks wrong.

USE ROLE P09_OWNER;
USE WAREHOUSE P09_WH;
USE DATABASE P09_MARKETS;

-- 1. Files on the stage that were never loaded (expect 0 rows). A row here means COPY skipped or rejected a file.
--    The directory table of an internal stage is refreshed by hand after PUT.
ALTER STAGE RAW.MARKET_STAGE REFRESH;
SELECT d.RELATIVE_PATH, d.LAST_MODIFIED
FROM DIRECTORY(@RAW.MARKET_STAGE) d
LEFT JOIN (
  SELECT DISTINCT SRC_FILE FROM RAW.COINBASE_CANDLES_RAW
  UNION
  SELECT DISTINCT SRC_FILE FROM RAW.FRED_OBSERVATIONS_RAW
) r ON r.SRC_FILE = d.RELATIVE_PATH
WHERE r.SRC_FILE IS NULL;

-- 2. Load errors in the last day (expect none with status LOAD_FAILED or PARTIALLY_LOADED).
SELECT TABLE_NAME, FILE_NAME, STATUS, ROW_COUNT, FIRST_ERROR_MESSAGE, LAST_LOAD_TIME
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.COINBASE_CANDLES_RAW', START_TIME => DATEADD(day, -1, CURRENT_TIMESTAMP())))
WHERE STATUS <> 'Loaded'
UNION ALL
SELECT TABLE_NAME, FILE_NAME, STATUS, ROW_COUNT, FIRST_ERROR_MESSAGE, LAST_LOAD_TIME
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.FRED_OBSERVATIONS_RAW', START_TIME => DATEADD(day, -1, CURRENT_TIMESTAMP())))
WHERE STATUS <> 'Loaded';

-- 3. FRED: last observation and dropped empty values per series (holidays have no value).
SELECT
  r.SERIES_ID,
  COUNT(*)                                                       AS RAW_LINES,
  COUNT_IF(TRY_TO_DECIMAL(r.VALUE, 38, 4) IS NULL)                AS EMPTY_OR_INVALID,
  MAX(TRY_TO_DATE(r.OBSERVATION_DATE))                           AS LAST_DATE
FROM RAW.FRED_OBSERVATIONS_RAW r
GROUP BY r.SERIES_ID;

-- 4. Alert history (expect regular runs; CONDITION_FALSE most of the time).
SELECT NAME, STATE, SCHEDULED_TIME, SQL_ERROR_MESSAGE
FROM TABLE(INFORMATION_SCHEMA.ALERT_HISTORY(SCHEDULED_TIME_RANGE_START => DATEADD(day, -1, CURRENT_TIMESTAMP())))
ORDER BY SCHEDULED_TIME DESC
LIMIT 20;

-- Part 2: schemas created and owned by dbt.
USE ROLE P09_TRANSFORMER;

-- 5. Hourly coverage per product over the last 7 full days (expect 168 hours; BTC and ETH always, SOL nearly always).
SELECT PRODUCT_ID, COUNT(*) AS HOURS, 168 - COUNT(*) AS MISSING_HOURS, MAX(HOURS_SINCE_PREVIOUS) AS LONGEST_GAP_H
FROM MARTS.FCT_CRYPTO_HOURLY
WHERE CANDLE_START >= DATEADD(day, -7, DATE_TRUNC(day, SYSDATE()))
  AND CANDLE_START < DATE_TRUNC(day, SYSDATE())
GROUP BY PRODUCT_ID
ORDER BY PRODUCT_ID;

-- 6. Freshness per product: hours between the last candle and now (expect 1 or 2).
SELECT PRODUCT_ID, MAX(CANDLE_START) AS LAST_CANDLE, DATEDIFF(hour, MAX(CANDLE_START), SYSDATE()) AS HOURS_BEHIND
FROM MARTS.FCT_CRYPTO_HOURLY
GROUP BY PRODUCT_ID;

-- 7. Incremental merge kept the fact equal to staging inside the lookback (expect 0 rows).
--    A difference means a corrected candle arrived after its hour left the lookback window.
SELECT s.PRODUCT_ID, s.CANDLE_START, s.CLOSE_PRICE AS STAGING_CLOSE, f.CLOSE_PRICE AS FACT_CLOSE
FROM STAGING.STG_COINBASE__CANDLES s
JOIN MARTS.FCT_CRYPTO_HOURLY f USING (PRODUCT_ID, CANDLE_START)
WHERE s.CLOSE_PRICE <> f.CLOSE_PRICE;

-- 8. Overlap absorbed by staging: raw candle rows versus unique candles. The ratio shows the cost of the lookback.
SELECT
  (SELECT SUM(ARRAY_SIZE(PAYLOAD:candles)) FROM RAW.COINBASE_CANDLES_RAW) AS RAW_CANDLE_ROWS,
  (SELECT COUNT(*) FROM STAGING.STG_COINBASE__CANDLES)                    AS UNIQUE_CANDLES,
  ROUND(RAW_CANDLE_ROWS / NULLIF(UNIQUE_CANDLES, 0), 2)                   AS READ_AMPLIFICATION;

-- 9. Latest analytics values: plausible ranges are volatility 0.3 to 1.2 for crypto, 0.1 to 0.3 for SPX,
--    correlation between -0.2 and 0.6.
SELECT v.ASSET_ID, v.PRICE_DATE, ROUND(v.ANNUALIZED_VOLATILITY_30, 3) AS ANN_VOL_30, ROUND(c.CORRELATION_WITH_SPX_60, 3) AS CORR_SPX_60
FROM MARTS.MART_VOLATILITY_30 v
LEFT JOIN MARTS.MART_CORRELATION_SPX_60 c USING (ASSET_ID, PRICE_DATE)
QUALIFY ROW_NUMBER() OVER (PARTITION BY v.ASSET_ID ORDER BY v.PRICE_DATE DESC) = 1
ORDER BY v.ASSET_ID;

-- 10. Stored test failures from the last production build (expect every ROW_COUNT = 0).
SELECT TABLE_NAME, ROW_COUNT, LAST_ALTERED
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'TEST_FAILURES'
ORDER BY ROW_COUNT DESC, TABLE_NAME;

-- 11. Leftover CI schemas (expect none older than a day: the pull request workflow drops them).
SELECT SCHEMA_NAME, SCHEMA_OWNER, CREATED
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME LIKE 'CI\\_%' ESCAPE '\\'
ORDER BY CREATED;
