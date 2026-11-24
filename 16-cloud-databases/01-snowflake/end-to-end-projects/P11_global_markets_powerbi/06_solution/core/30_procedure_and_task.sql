-- P11 Snowpark procedure and the task that runs it. Run as P11_OWNER after ./package.sh.
-- Rerun after every ./package.sh: IMPORTS are resolved when the procedure is created.

USE ROLE P11_OWNER;
USE WAREHOUSE P11_WH;
USE DATABASE P11_MARKETS;

LIST @OPS.CODE_STAGE;

CREATE OR REPLACE PROCEDURE CORE.SP_BUILD_MARKETS()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  PACKAGES = ('snowflake-snowpark-python')
  IMPORTS = ('@OPS.CODE_STAGE/markets_pipeline.zip')
  HANDLER = 'markets_pipeline.pipeline.build'
  EXECUTE AS OWNER
  COMMENT = 'Units, FX, and comparable food prices; rebuilds CORE beside the live tables and swaps';

-- Sources change monthly at most. The task checks the streams at 06:30 UTC, after the 06:00 ingestion;
-- the WHEN condition is evaluated without a warehouse, so a day without new files costs nothing.
CREATE OR REPLACE TASK OPS.BUILD_MARKETS
  WAREHOUSE = P11_WH
  SCHEDULE = 'USING CRON 30 6 * * * UTC'
  SUSPEND_TASK_AFTER_NUM_FAILURES = 3
  COMMENT = 'Rebuild CORE when any raw stream has new files'
  WHEN SYSTEM$STREAM_HAS_DATA('P11_MARKETS.RAW.WFP_STREAM')
    OR SYSTEM$STREAM_HAS_DATA('P11_MARKETS.RAW.ECB_STREAM')
    OR SYSTEM$STREAM_HAS_DATA('P11_MARKETS.RAW.WB_STREAM')
AS
  CALL CORE.SP_BUILD_MARKETS();

ALTER TASK OPS.BUILD_MARKETS RESUME;

-- First build by hand: about a minute on XS for six countries.
CALL CORE.SP_BUILD_MARKETS();
