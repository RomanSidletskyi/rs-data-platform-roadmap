-- P14 data quality checks. Run as P14_OWNER after stopping the producer and waiting one task run.

USE ROLE P14_OWNER;
USE WAREHOUSE P14_TRANSFORM_WH;
USE DATABASE P14_WIKI_STREAM;

-- Count of DLQ messages: kcat -b localhost:9092 -t wiki.recentchange.dlq -C -e -q | wc -l
SET dlq_records = 0;

WITH checks AS (
  SELECT 'raw_duplicate_partition_offset' AS CHECK_NAME, COALESCE(SUM(DUPLICATE_OFFSETS), 0) AS FAILURES
  FROM OPS.V_OFFSET_INTEGRITY

  UNION ALL
  -- Expected to equal the number of records sent to the DLQ; anything above that is lost data.
  SELECT 'raw_missing_offsets_minus_dlq', COALESCE(SUM(MISSING_OFFSETS), 0) - $dlq_records
  FROM OPS.V_OFFSET_INTEGRITY

  UNION ALL
  SELECT 'stg_duplicate_event_id', COUNT(*)
  FROM (SELECT EVENT_ID FROM STG.WIKI_CHANGE GROUP BY EVENT_ID HAVING COUNT(*) > 1)

  UNION ALL
  SELECT 'stg_null_event_ts', COUNT(*) FROM STG.WIKI_CHANGE WHERE EVENT_TS IS NULL

  UNION ALL
  SELECT 'raw_events_missing_in_stg', COUNT(*)
  FROM (
    SELECT DISTINCT RECORD_CONTENT:meta:id::STRING AS EVENT_ID
    FROM RAW.WIKI_RECENTCHANGE_RAW
    WHERE RECORD_CONTENT:meta:id::STRING IS NOT NULL
      AND RECORD_METADATA:CreateTime::NUMBER < DATE_PART(EPOCH_MILLISECOND, DATEADD('minute', -3, CURRENT_TIMESTAMP()))
  ) r
  WHERE NOT EXISTS (SELECT 1 FROM STG.WIKI_CHANGE s WHERE s.EVENT_ID = r.EVENT_ID)
)
SELECT CHECK_NAME, FAILURES, IFF(FAILURES = 0, 'PASS', 'FAIL') AS RESULT
FROM checks
ORDER BY RESULT, CHECK_NAME;
