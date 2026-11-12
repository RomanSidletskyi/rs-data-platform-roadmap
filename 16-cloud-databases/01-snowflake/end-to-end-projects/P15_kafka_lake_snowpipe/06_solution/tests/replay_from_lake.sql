-- P15 replay from the lake into a separate table, independent of Kafka retention. Run as P15_OWNER.
-- Edit the folder in the FROM clause to the hour you want to replay (folders follow the record-time window).

USE ROLE P15_OWNER;
USE WAREHOUSE P15_TRANSFORM_WH;
USE DATABASE P15_WIKI_LAKE;

CREATE OR REPLACE TABLE RAW.WIKI_RECENTCHANGE_REPLAY LIKE RAW.WIKI_RECENTCHANGE_RAW;

-- FORCE = TRUE ignores load metadata, so files the pipe already loaded load again into the replay table.
COPY INTO RAW.WIKI_RECENTCHANGE_REPLAY
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
  FROM @RAW.LAKE_STAGE/topic=wiki.recentchange/dt=2026-11-10/hour=14/
)
FILE_FORMAT = (FORMAT_NAME = 'RAW.FF_KAFKA_NDJSON')
FORCE = TRUE;

-- The replay must match what the pipe loaded for the same files.
SELECT 'raw' AS SOURCE, COUNT(*) AS ROWS_LOADED, COUNT(DISTINCT KAFKA_PARTITION || ':' || KAFKA_OFFSET) AS DISTINCT_OFFSETS
FROM RAW.WIKI_RECENTCHANGE_RAW
WHERE SRC_FILE IN (SELECT DISTINCT SRC_FILE FROM RAW.WIKI_RECENTCHANGE_REPLAY)
UNION ALL
SELECT 'replay', COUNT(*), COUNT(DISTINCT KAFKA_PARTITION || ':' || KAFKA_OFFSET)
FROM RAW.WIKI_RECENTCHANGE_REPLAY;

DROP TABLE RAW.WIKI_RECENTCHANGE_REPLAY;
