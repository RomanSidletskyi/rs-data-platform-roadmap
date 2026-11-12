-- P01 bronze: internal stage, file format, raw table, and exploration of staged files. Run as P01_OWNER.

USE ROLE P01_OWNER;
USE WAREHOUSE P01_WH;
USE DATABASE P01_CRICKET;

CREATE SCHEMA IF NOT EXISTS RAW  COMMENT = 'Bronze: one row per match file, as delivered';
CREATE SCHEMA IF NOT EXISTS STG  COMMENT = 'Silver: matches, players, deliveries';
CREATE SCHEMA IF NOT EXISTS MART COMMENT = 'Gold: facts and dimensions for analytics';
CREATE SCHEMA IF NOT EXISTS OPS  COMMENT = 'Run log, stage reconciliation';

-- One JSON document per file (a whole match), so no outer array to strip.
CREATE FILE FORMAT IF NOT EXISTS RAW.FF_MATCH_JSON
  TYPE = JSON
  COMPRESSION = AUTO
  STRIP_OUTER_ARRAY = FALSE;

-- Internal stage with a directory table: the stage can be listed and reconciled with SQL.
CREATE STAGE IF NOT EXISTS RAW.MATCH_STAGE
  FILE_FORMAT = (FORMAT_NAME = 'RAW.FF_MATCH_JSON')
  DIRECTORY = (ENABLE = TRUE)
  COMMENT = 'Cricsheet match files, folders year=YYYY/';

CREATE TABLE IF NOT EXISTS RAW.MATCH_RAW (
  PAYLOAD            VARIANT,
  SRC_FILE           STRING,
  FILE_LAST_MODIFIED TIMESTAMP_NTZ,
  LOADED_AT          TIMESTAMP_LTZ
)
CHANGE_TRACKING = TRUE
COMMENT = 'One row per loaded file version; a corrected file loads again as a new row.';

CREATE TABLE IF NOT EXISTS OPS.RUN_LOG (
  RUN_AT          TIMESTAMP_LTZ,
  STEP            STRING,
  MATCHES_IN_BATCH NUMBER,
  NOTE            STRING
);

GRANT USAGE ON DATABASE P01_CRICKET TO ROLE P01_READER;
GRANT USAGE ON SCHEMA MART TO ROLE P01_READER;
GRANT USAGE ON SCHEMA OPS  TO ROLE P01_READER;

-- ---------------------------------------------------------------------
-- Exploration with $ notation, after the first upload_batch.sh run.
-- $1 is the whole document of each staged file; no table needed.
-- ---------------------------------------------------------------------
-- LIST @RAW.MATCH_STAGE;
--
-- SELECT METADATA$FILENAME,
--        $1:info:dates[0]::DATE        AS MATCH_DATE,
--        $1:info:teams                 AS TEAMS,
--        $1:info:outcome               AS OUTCOME,
--        ARRAY_SIZE($1:innings)        AS INNINGS
-- FROM @RAW.MATCH_STAGE/year=2023/ (FILE_FORMAT => 'RAW.FF_MATCH_JSON')
-- LIMIT 10;
