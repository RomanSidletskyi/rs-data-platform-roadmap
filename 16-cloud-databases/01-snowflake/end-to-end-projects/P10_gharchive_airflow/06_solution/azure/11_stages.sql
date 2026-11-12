-- P10 Azure stages: replace the internal stages of core/01 with external ones of the same names.
-- Run as P10_OWNER via run_sql.sh after 02_grant_snowflake_access.sh. Switch before loading data:
-- files already PUT to the internal stages are dropped with them.

USE ROLE P10_OWNER;
USE WAREHOUSE P10_WH;
USE DATABASE P10_GH;

CREATE OR REPLACE STAGE RAW.LANDING_STAGE
  URL = 'azure://<storage-account>.blob.core.windows.net/landing/'
  STORAGE_INTEGRATION = P10_AZURE_STORAGE_INT
  COMMENT = 'gharchive/dt=YYYY-MM-DD/YYYY-MM-DD-H.json.gz, written by Airflow';

CREATE OR REPLACE STAGE ARCHIVE.ARCHIVE_STAGE
  URL = 'azure://<storage-account>.blob.core.windows.net/archive/'
  STORAGE_INTEGRATION = P10_AZURE_STORAGE_INT
  COMMENT = 'events/dt=YYYY-MM-DD/*.parquet and _manifests/, written by OPS.ARCHIVE_DAY';

-- Expect the landing files Airflow wrote; an authorization error means the role assignment has not propagated yet.
LIST @RAW.LANDING_STAGE/gharchive/;

-- Cold data stays queryable without loading it back. ARCHIVE_DAY refreshes one partition after each unload.
CREATE OR REPLACE EXTERNAL TABLE ARCHIVE.GH_EVENT_ARCHIVE (
  EVENT_DAY    DATE          AS TO_DATE(REGEXP_SUBSTR(METADATA$FILENAME, 'dt=([0-9-]+)', 1, 1, 'e')),
  EVENT_ID     NUMBER(38, 0) AS (VALUE:EVENT_ID::NUMBER(38, 0)),
  EVENT_HOUR   TIMESTAMP_NTZ AS (VALUE:EVENT_HOUR::TIMESTAMP_NTZ),
  CREATED_AT   TIMESTAMP_NTZ AS (VALUE:CREATED_AT::TIMESTAMP_NTZ),
  EVENT_TYPE   STRING        AS (VALUE:EVENT_TYPE::STRING),
  ACTION       STRING        AS (VALUE:ACTION::STRING),
  ACTOR_LOGIN  STRING        AS (VALUE:ACTOR_LOGIN::STRING),
  IS_BOT       BOOLEAN       AS (VALUE:IS_BOT::BOOLEAN),
  REPO_ID      NUMBER        AS (VALUE:REPO_ID::NUMBER),
  REPO_NAME    STRING        AS (VALUE:REPO_NAME::STRING),
  PR_OUTCOME   STRING        AS (VALUE:PR_OUTCOME::STRING),
  PUSH_COMMITS NUMBER        AS (VALUE:PUSH_COMMITS::NUMBER)
)
PARTITION BY (EVENT_DAY)
LOCATION = @ARCHIVE.ARCHIVE_STAGE/events/
PATTERN = '.*[.]parquet'
FILE_FORMAT = (FORMAT_NAME = 'ARCHIVE.FF_PARQUET')
AUTO_REFRESH = FALSE
COMMENT = 'Archived days; refreshed per day by OPS.ARCHIVE_DAY';

-- Hot plus cold behind one name. A filter on EVENT_DAY prunes both sides.
CREATE OR REPLACE VIEW ARCHIVE.GH_EVENT_ALL AS
SELECT EVENT_DAY, EVENT_ID, EVENT_HOUR, CREATED_AT, EVENT_TYPE, ACTION, ACTOR_LOGIN, IS_BOT, REPO_ID, REPO_NAME,
       PR_OUTCOME, PUSH_COMMITS, 'hot' AS STORAGE_TIER
FROM STG.GH_EVENT
UNION ALL
SELECT EVENT_DAY, EVENT_ID, EVENT_HOUR, CREATED_AT, EVENT_TYPE, ACTION, ACTOR_LOGIN, IS_BOT, REPO_ID, REPO_NAME,
       PR_OUTCOME, PUSH_COMMITS, 'archive'
FROM ARCHIVE.GH_EVENT_ARCHIVE
WHERE EVENT_DAY NOT IN (SELECT DISTINCT EVENT_DAY FROM STG.GH_EVENT);
