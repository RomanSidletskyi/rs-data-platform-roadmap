-- P10 pause after a session. Run as P10_OWNER. Stop Airflow first, otherwise the next hourly run resumes the warehouse:
--   cd airflow && docker compose stop

USE ROLE P10_OWNER;

ALTER WAREHOUSE P10_WH SUSPEND;

-- What the session cost, by Airflow task (QUERY_TAG is set by every Snowflake task in the DAGs).
SELECT
  SPLIT_PART(QUERY_TAG, '/', 3)                    AS AIRFLOW_TASK,
  COUNT(*)                                         AS QUERIES,
  ROUND(SUM(TOTAL_ELAPSED_TIME) / 1000 / 60, 1)    AS ELAPSED_MINUTES,
  ROUND(SUM(BYTES_SCANNED) / POWER(1024, 3), 2)    AS GB_SCANNED
FROM TABLE(P10_GH.INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
  WAREHOUSE_NAME => 'P10_WH', END_TIME_RANGE_START => DATEADD(day, -1, CURRENT_TIMESTAMP()), RESULT_LIMIT => 10000))
WHERE QUERY_TAG LIKE 'p10/%'
GROUP BY AIRFLOW_TASK
ORDER BY ELAPSED_MINUTES DESC;
