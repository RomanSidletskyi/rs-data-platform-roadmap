-- P07 raw load: COPY new monthly files; the month comes from the folder name. Run as P07_OWNER.
-- The task in 40_task.sql runs the same statement before calling the procedure.

USE ROLE P07_OWNER;
USE WAREHOUSE P07_WH;
USE DATABASE P07_RETAIL;

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

SELECT MONTH, COUNT(*) AS ROWS_, COUNT(DISTINCT SRC_FILE) AS FILES
FROM RAW.ONLINE_RETAIL
GROUP BY 1
ORDER BY 1;
