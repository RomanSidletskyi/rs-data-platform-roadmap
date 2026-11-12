-- P08 checks. Run as P08_OWNER after at least 15 minutes of producing.

USE ROLE P08_OWNER;
USE WAREHOUSE P08_WH;
USE DATABASE P08_SOCIAL;

WITH checks AS (
  SELECT 'duplicate_event_key_in_stg' AS CHECK_NAME, COUNT(*) AS FAILURES
  FROM (SELECT EVENT_KEY FROM STG.EVENT WHERE EVENT_TIME >= DATEADD(day, -1, SYSDATE()) GROUP BY 1 HAVING COUNT(*) > 1)

  UNION ALL
  SELECT 'files_not_loaded_last_hour', SUM(NOT_LOADED) FROM OPS.V_FILE_PROFILE

  UNION ALL
  SELECT 'unknown_collection', COUNT(*)
  FROM STG.EVENT WHERE COLLECTION NOT IN ('post', 'like', 'repost', 'follow')

  UNION ALL
  SELECT 'like_or_repost_without_subject', COUNT(*)
  FROM STG.EVENT WHERE COLLECTION IN ('like', 'repost') AND OPERATION = 'create' AND SUBJECT_URI IS NULL

  UNION ALL
  SELECT 'event_time_in_future', COUNT(*)
  FROM STG.EVENT WHERE EVENT_TIME > DATEADD(minute, 5, SYSDATE())

  UNION ALL
  -- Every raw row is either in STG or a removed duplicate: STG never has more rows than RAW.
  SELECT 'stg_more_rows_than_raw', COUNT_IF(REMOVED_OR_PENDING < 0) FROM OPS.V_DEDUP_LAST_DAY
)
SELECT CHECK_NAME, FAILURES, IFF(FAILURES = 0, 'PASS', 'FAIL') AS RESULT
FROM checks
ORDER BY RESULT, CHECK_NAME;

-- Read, do not just pass.
SELECT * FROM OPS.V_FILE_PROFILE ORDER BY FILES DESC;
SELECT * FROM OPS.V_LATENCY_LAST_HOUR;
-- Deletes whose create was never captured: their subject is unknown, so they cannot reduce any count.
SELECT d.COLLECTION, COUNT(*) AS UNRESOLVED_DELETES
FROM STG.EVENT d
WHERE d.OPERATION = 'delete'
  AND NOT EXISTS (SELECT 1 FROM STG.EVENT c WHERE c.OPERATION = 'create' AND c.DID = d.DID AND c.COLLECTION = d.COLLECTION AND c.RKEY = d.RKEY)
GROUP BY 1;
-- Engagement on posts created before capture started: counted, but the text is unknown.
SELECT COUNT_IF(p.POST_URI IS NULL) AS POSTS_NOT_CAPTURED, COUNT(*) AS POSTS_WITH_ENGAGEMENT
FROM MART.DT_POST_ENGAGEMENT e LEFT JOIN MART.DT_POST p ON p.POST_URI = e.POST_URI;
