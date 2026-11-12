-- P07 stored procedure from the packaged code. Run as P07_OWNER after ./package.sh.
-- Rerun after every ./package.sh: IMPORTS are resolved when the procedure is created.

USE ROLE P07_OWNER;
USE WAREHOUSE P07_WH;
USE DATABASE P07_RETAIL;

LIST @OPS.CODE_STAGE;

CREATE OR REPLACE PROCEDURE OPS.SP_PROCESS_NEW_MONTHS()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  PACKAGES = ('snowflake-snowpark-python')
  IMPORTS = ('@OPS.CODE_STAGE/retail_pipeline.zip')
  HANDLER = 'retail_pipeline.pipeline.process_new_months'
  EXECUTE AS OWNER
  COMMENT = 'Classify, deduplicate, and aggregate every pending month; refresh RFM';

-- First run: all months, several minutes on XS for the full dataset.
CALL OPS.SP_PROCESS_NEW_MONTHS();
