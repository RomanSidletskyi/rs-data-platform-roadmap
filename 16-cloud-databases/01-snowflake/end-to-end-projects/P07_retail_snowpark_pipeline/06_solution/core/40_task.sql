-- P07 task: monthly load and process. Run as P07_OWNER. Start it by hand with EXECUTE TASK during the project.

USE ROLE P07_OWNER;
USE WAREHOUSE P07_WH;
USE DATABASE P07_RETAIL;

ALTER TASK IF EXISTS OPS.MONTHLY_RUN SUSPEND;

-- Runs on P07_WH, not serverless: the Python procedure and its Snowpark queries need a warehouse they can size predictably.
CREATE OR REPLACE TASK OPS.MONTHLY_RUN
  WAREHOUSE = P07_WH
  SCHEDULE = 'USING CRON 0 5 2 * * UTC'
  SUSPEND_TASK_AFTER_NUM_FAILURES = 2
  COMMENT = 'COPY new monthly files, then process pending months'
AS
EXECUTE IMMEDIATE $$
BEGIN
  COPY INTO RAW.ONLINE_RETAIL
  FROM (
    SELECT $1, $2, $3, $4, $5, $6, $7, $8,
           REGEXP_SUBSTR(METADATA$FILENAME, 'month=([0-9]{4}-[0-9]{2})', 1, 1, 'e'),
           METADATA$FILENAME,
           METADATA$START_SCAN_TIME
    FROM @RAW.RETAIL_STAGE
  )
  FILE_FORMAT = (FORMAT_NAME = 'RAW.FF_CSV')
  ON_ERROR = SKIP_FILE;
  CALL OPS.SP_PROCESS_NEW_MONTHS();
END;
$$;

ALTER TASK OPS.MONTHLY_RUN RESUME;
SHOW TASKS IN SCHEMA OPS;
