-- P10 data quality checks. Run as P10_OWNER after the hourly and daily DAGs have run.
-- The DAG checks guard each run; these queries answer what a person asks when a number looks wrong.

USE ROLE P10_OWNER;
USE WAREHOUSE P10_WH;
USE DATABASE P10_GH;

-- 1. Hour coverage per day (expect 24 built hours for every day before today).
SELECT EVENT_DAY, COUNT(*) AS HOURS_LOGGED, COUNT_IF(BUILT_AT IS NOT NULL) AS HOURS_BUILT,
       SUM(STG_ROWS) AS EVENTS, MAX(LOAD_COUNT) AS MAX_LOADS_OF_ONE_HOUR
FROM OPS.HOUR_LOG
GROUP BY EVENT_DAY
ORDER BY EVENT_DAY DESC;

-- 2. Missing hours of every day that has at least one hour (expect 0 rows except the current hour).
--    A missing hour is one no run ever loaded: backfill it.
SELECT d.EVENT_DAY, DATEADD(hour, g.H, d.EVENT_DAY::TIMESTAMP_NTZ) AS MISSING_HOUR
FROM (SELECT DISTINCT EVENT_DAY FROM OPS.HOUR_LOG) d
CROSS JOIN (SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS H FROM TABLE(GENERATOR(ROWCOUNT => 24))) g
LEFT JOIN OPS.HOUR_LOG l ON l.EVENT_HOUR = DATEADD(hour, g.H, d.EVENT_DAY::TIMESTAMP_NTZ)
WHERE l.EVENT_HOUR IS NULL
  AND DATEADD(hour, g.H, d.EVENT_DAY::TIMESTAMP_NTZ) < DATEADD(hour, -1, DATE_TRUNC('hour', SYSDATE()))
ORDER BY MISSING_HOUR;

-- 3. Hours loaded more than once (retries, reprocessing). Counts must still match: STG equals RAW minus duplicates.
SELECT EVENT_HOUR, LOAD_COUNT, RAW_ROWS, STG_ROWS, AIRFLOW_RUN_ID
FROM OPS.HOUR_LOG
WHERE LOAD_COUNT > 1
ORDER BY EVENT_HOUR DESC
LIMIT 50;

-- 4. Event ids that appear in two hours (expect 0 rows; GH Archive has had none in the samples measured).
SELECT EVENT_ID, COUNT(DISTINCT EVENT_HOUR) AS HOURS
FROM STG.GH_EVENT
GROUP BY EVENT_ID
HAVING HOURS > 1
LIMIT 20;

-- 5. Archive state per day: built, archived, verified, purged (expect VERIFIED for every complete day).
SELECT EVENT_DAY, STG_ROWS, ARCHIVE_ROWS, ARCHIVE_FILES, ROUND(ARCHIVE_BYTES / POWER(1024, 2), 1) AS ARCHIVE_MB,
       VERIFIED, ARCHIVED_AT, PURGED_AT
FROM OPS.DAY_LOG
ORDER BY EVENT_DAY DESC;

-- 6. Days in STG older than the hot window but not purged (expect 0 rows unless unverified). 30 = P10_HOT_DAYS.
SELECT s.EVENT_DAY, COUNT(*) AS ROWS_IN_STG, d.VERIFIED
FROM STG.GH_EVENT s
LEFT JOIN OPS.DAY_LOG d USING (EVENT_DAY)
WHERE s.EVENT_DAY < DATEADD(day, -30, CURRENT_DATE())
GROUP BY s.EVENT_DAY, d.VERIFIED;

-- 7. Read one archived day back from the stage (replace the date). The same check ARCHIVE_DAY runs.
SELECT COUNT(*) AS ROWS_IN_ARCHIVE, COUNT(DISTINCT $1:EVENT_ID) AS DISTINCT_IDS, MIN($1:CREATED_AT) AS FIRST_EVENT
FROM @ARCHIVE.ARCHIVE_STAGE/events/dt=2026-11-09/ (FILE_FORMAT => 'ARCHIVE.FF_PARQUET');

-- 8. Source drift (expect rows around source changes only, for example October 2025 and the 2026 PR actions).
SELECT * FROM OPS.SOURCE_DRIFT ORDER BY EVENT_DAY DESC, METRIC;

-- 9. Field ratios per day: the evidence behind drift.
SELECT EVENT_DAY, CHECK_NAME, NUMERATOR, DENOMINATOR, ROUND(NUMERATOR / NULLIF(DENOMINATOR, 0), 3) AS RATIO
FROM OPS.SOURCE_PROFILE_DAILY
ORDER BY EVENT_DAY DESC, CHECK_NAME;

-- 10. Event type mix per day: a pipeline bug changes all types, a source change only some.
SELECT EVENT_DAY, EVENT_TYPE, EVENTS, ROUND(100 * RATIO_TO_REPORT(EVENTS) OVER (PARTITION BY EVENT_DAY), 1) AS PCT
FROM MART.EVENT_TYPE_DAILY
ORDER BY EVENT_DAY DESC, EVENTS DESC;

-- 11. Credits by Airflow task over the last 7 days (QUERY_TAG p10/<dag>/<task>/<interval>).
SELECT SPLIT_PART(QUERY_TAG, '/', 2) AS DAG, SPLIT_PART(QUERY_TAG, '/', 3) AS TASK, COUNT(*) AS QUERIES,
       ROUND(SUM(EXECUTION_TIME) / 1000 / 60, 1) AS EXECUTION_MINUTES
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE WAREHOUSE_NAME = 'P10_WH' AND START_TIME > DATEADD(day, -7, CURRENT_TIMESTAMP()) AND QUERY_TAG LIKE 'p10/%'
GROUP BY DAG, TASK
ORDER BY EXECUTION_MINUTES DESC;
