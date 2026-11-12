-- P14 operational evidence: offset integrity, freshness, latency, alert. Run as P14_OWNER.

USE ROLE P14_OWNER;
USE WAREHOUSE P14_TRANSFORM_WH;
USE DATABASE P14_WIKI_STREAM;

-- Exactly-once evidence per partition. Gaps are legitimate for offsets routed to the DLQ.
CREATE OR REPLACE VIEW OPS.V_OFFSET_INTEGRITY AS
SELECT
  RECORD_METADATA:topic::STRING                                          AS TOPIC,
  RECORD_METADATA:partition::NUMBER                                      AS KAFKA_PARTITION,
  COUNT(*)                                                               AS ROWS_LOADED,
  COUNT(DISTINCT RECORD_METADATA:offset::NUMBER)                         AS DISTINCT_OFFSETS,
  MIN(RECORD_METADATA:offset::NUMBER)                                    AS MIN_OFFSET,
  MAX(RECORD_METADATA:offset::NUMBER)                                    AS MAX_OFFSET,
  COUNT(*) - COUNT(DISTINCT RECORD_METADATA:offset::NUMBER)              AS DUPLICATE_OFFSETS,
  (MAX(RECORD_METADATA:offset::NUMBER) - MIN(RECORD_METADATA:offset::NUMBER) + 1)
    - COUNT(DISTINCT RECORD_METADATA:offset::NUMBER)                     AS MISSING_OFFSETS
FROM RAW.WIKI_RECENTCHANGE_RAW
GROUP BY 1, 2;

CREATE OR REPLACE VIEW OPS.V_PIPELINE_FRESHNESS AS
WITH last_updates AS (
  SELECT 'RAW' AS LAYER,
         MAX(TO_TIMESTAMP_LTZ(COALESCE(RECORD_METADATA:SnowflakeConnectorPushTime::NUMBER,
                                       RECORD_METADATA:CreateTime::NUMBER), 3)) AS LAST_UPDATE_AT
  FROM RAW.WIKI_RECENTCHANGE_RAW
  UNION ALL
  SELECT 'STG', MAX(STAGED_AT) FROM STG.WIKI_CHANGE
)
SELECT LAYER, LAST_UPDATE_AT, DATEDIFF('second', LAST_UPDATE_AT, CURRENT_TIMESTAMP()) AS SECONDS_SINCE_UPDATE
FROM last_updates;

-- Hops: event -> Kafka (producer), Kafka -> connector buffer, buffer -> visible (flush + commit), raw -> staging (task).
CREATE OR REPLACE VIEW OPS.V_LATENCY_LAST_HOUR AS
SELECT
  COUNT(*)                                                                      AS EVENTS,
  APPROX_PERCENTILE(DATEDIFF('millisecond', EVENT_TS, KAFKA_TS), 0.50) / 1000   AS P50_EVENT_TO_KAFKA_S,
  APPROX_PERCENTILE(DATEDIFF('millisecond', EVENT_TS, KAFKA_TS), 0.95) / 1000   AS P95_EVENT_TO_KAFKA_S,
  APPROX_PERCENTILE(DATEDIFF('millisecond', KAFKA_TS, CONNECTOR_PUSH_TS), 0.50) / 1000 AS P50_KAFKA_TO_CONNECTOR_S,
  APPROX_PERCENTILE(DATEDIFF('millisecond', KAFKA_TS, CONNECTOR_PUSH_TS), 0.95) / 1000 AS P95_KAFKA_TO_CONNECTOR_S,
  APPROX_PERCENTILE(DATEDIFF('second', EVENT_TS, STAGED_AT), 0.50)              AS P50_EVENT_TO_STG_S,
  APPROX_PERCENTILE(DATEDIFF('second', EVENT_TS, STAGED_AT), 0.95)              AS P95_EVENT_TO_STG_S
FROM STG.WIKI_CHANGE
WHERE STAGED_AT >= DATEADD('hour', -1, CURRENT_TIMESTAMP());

GRANT SELECT ON VIEW OPS.V_OFFSET_INTEGRITY   TO ROLE P14_READER;
GRANT SELECT ON VIEW OPS.V_PIPELINE_FRESHNESS TO ROLE P14_READER;
GRANT SELECT ON VIEW OPS.V_LATENCY_LAST_HOUR  TO ROLE P14_READER;

-- Stricter than P04: seconds-level ingestion should never be silent for 2 minutes while the producer runs.
CREATE OR REPLACE ALERT OPS.ALERT_RAW_STALE
  WAREHOUSE = P14_TRANSFORM_WH
  SCHEDULE = '10 MINUTE'
  IF (EXISTS (
    SELECT 1 FROM OPS.V_PIPELINE_FRESHNESS
    WHERE LAYER = 'RAW' AND SECONDS_SINCE_UPDATE > 120
  ))
  THEN
    CALL SYSTEM$SEND_EMAIL(
      'P14_EMAIL_INT',
      '<your-verified-email>',
      'P14: connector stopped delivering',
      'No new rows in RAW for more than 2 minutes. Check the connector status, consumer lag, and the DLQ topic.'
    );

ALTER ALERT OPS.ALERT_RAW_STALE RESUME;
