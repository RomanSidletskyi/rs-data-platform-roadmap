-- P04 schemas, raw tables, and reader grants. Run as P04_OWNER.

USE ROLE P04_OWNER;
USE WAREHOUSE P04_TRANSFORM_WH;
USE DATABASE P04_WIKI_RT;

CREATE SCHEMA IF NOT EXISTS RAW  COMMENT = 'As delivered, plus load metadata';
CREATE SCHEMA IF NOT EXISTS STG  COMMENT = 'Typed, one row per event_id';
CREATE SCHEMA IF NOT EXISTS MART COMMENT = 'Consumer-shaped models';
CREATE SCHEMA IF NOT EXISTS OPS  COMMENT = 'Manifest, reconciliation, freshness, alerts';

-- One JSON document per line; gzip is detected from the file.
CREATE FILE FORMAT IF NOT EXISTS RAW.FF_WIKI_JSON
  TYPE = JSON
  COMPRESSION = AUTO
  STRIP_OUTER_ARRAY = FALSE;

CREATE TABLE IF NOT EXISTS RAW.WIKI_RECENTCHANGE_RAW (
  PAYLOAD                VARIANT,
  SRC_FILE               STRING,
  SRC_FILE_ROW           NUMBER,
  SRC_FILE_LAST_MODIFIED TIMESTAMP_NTZ,
  LOADED_AT              TIMESTAMP_LTZ
)
COMMENT = 'One row per line per loaded file. Duplicates possible by design.';

CREATE TABLE IF NOT EXISTS OPS.PRODUCER_MANIFEST (
  PAYLOAD   VARIANT,
  SRC_FILE  STRING,
  LOADED_AT TIMESTAMP_LTZ
)
COMMENT = 'What the producer says it sent: one row per data file.';

-- Readers see serving and operational evidence, never RAW.
-- Object-level SELECT grants are issued by the scripts that create MART and OPS objects.
GRANT USAGE ON DATABASE P04_WIKI_RT TO ROLE P04_READER;
GRANT USAGE ON SCHEMA MART TO ROLE P04_READER;
GRANT USAGE ON SCHEMA OPS  TO ROLE P04_READER;
