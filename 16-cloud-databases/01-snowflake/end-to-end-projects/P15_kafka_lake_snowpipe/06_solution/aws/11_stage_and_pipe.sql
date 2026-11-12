-- P15 AWS stage and auto-ingest pipe. Run as P15_OWNER via run_sql.sh.

USE ROLE P15_OWNER;
USE WAREHOUSE P15_TRANSFORM_WH;
USE DATABASE P15_WIKI_LAKE;

CREATE STAGE IF NOT EXISTS RAW.LAKE_STAGE
  URL = 's3://<bucket>/landing/kafka/'
  STORAGE_INTEGRATION = P15_AWS_STORAGE_INT
  FILE_FORMAT = (FORMAT_NAME = 'RAW.FF_KAFKA_NDJSON');

CREATE PIPE IF NOT EXISTS RAW.WIKI_LAKE_PIPE
  AUTO_INGEST = TRUE
AS
COPY INTO RAW.WIKI_RECENTCHANGE_RAW
  (PAYLOAD, VALUE_RAW, KAFKA_TOPIC, KAFKA_PARTITION, KAFKA_OFFSET, KAFKA_TS, SRC_FILE, LOADED_AT)
FROM (
  SELECT
    $1:value,
    $1:value_raw::STRING,
    $1:kafka:topic::STRING,
    $1:kafka:partition::NUMBER,
    $1:kafka:offset::NUMBER,
    TO_TIMESTAMP_LTZ($1:kafka:timestamp::NUMBER, 3),
    METADATA$FILENAME,
    METADATA$START_SCAN_TIME
  FROM @RAW.LAKE_STAGE/topic=wiki.recentchange/
)
FILE_FORMAT = (FORMAT_NAME = 'RAW.FF_KAFKA_NDJSON')
ON_ERROR = SKIP_FILE;

-- notification_channel is the SQS ARN for the P04 aws/02_connect_snowflake.sh script (with P04_* overrides).
SHOW PIPES IN DATABASE P15_WIKI_LAKE;

-- After the bucket notification and role trust are in place:
LIST @RAW.LAKE_STAGE/topic=wiki.recentchange/;
ALTER PIPE RAW.WIKI_LAKE_PIPE REFRESH;
