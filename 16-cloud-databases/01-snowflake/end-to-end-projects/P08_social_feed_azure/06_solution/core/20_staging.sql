-- P08 staging graph in schema PIPE: LOAD_EVENTS (root, every 5 minutes when any stream has data) and PURGE_RAW.
-- Run as P08_OWNER after the pipes exist.

USE ROLE P08_OWNER;
USE WAREHOUSE P08_WH;
USE DATABASE P08_SOCIAL;

ALTER TASK IF EXISTS PIPE.LOAD_EVENTS SUSPEND;

CREATE OR REPLACE TASK PIPE.LOAD_EVENTS
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = '5 MINUTE'
  SUSPEND_TASK_AFTER_NUM_FAILURES = 3
  COMMENT = 'Four raw streams -> STG.EVENT, typed and deduplicated'
  WHEN SYSTEM$STREAM_HAS_DATA('P08_SOCIAL.RAW.POST_STREAM')
    OR SYSTEM$STREAM_HAS_DATA('P08_SOCIAL.RAW.LIKE_STREAM')
    OR SYSTEM$STREAM_HAS_DATA('P08_SOCIAL.RAW.REPOST_STREAM')
    OR SYSTEM$STREAM_HAS_DATA('P08_SOCIAL.RAW.FOLLOW_STREAM')
AS
EXECUTE IMMEDIATE $$
DECLARE
  inserted NUMBER DEFAULT 0;
BEGIN
  -- One INSERT reads all four streams, so their offsets advance together.
  INSERT INTO STG.EVENT
  WITH batch AS (
    SELECT PAYLOAD, SRC_FILE, LOADED_AT FROM RAW.POST_STREAM
    UNION ALL SELECT PAYLOAD, SRC_FILE, LOADED_AT FROM RAW.LIKE_STREAM
    UNION ALL SELECT PAYLOAD, SRC_FILE, LOADED_AT FROM RAW.REPOST_STREAM
    UNION ALL SELECT PAYLOAD, SRC_FILE, LOADED_AT FROM RAW.FOLLOW_STREAM
  ),
  typed AS (
    SELECT
      PAYLOAD:did::STRING || '/' || PAYLOAD:commit:collection::STRING || '/' || PAYLOAD:commit:rkey::STRING
        || '/' || PAYLOAD:commit:operation::STRING || '/' || COALESCE(PAYLOAD:commit:rev::STRING, '')  AS EVENT_KEY,
      TO_TIMESTAMP_NTZ(PAYLOAD:time_us::NUMBER, 6)                                                    AS EVENT_TIME,
      PAYLOAD:did::STRING                                                                              AS DID,
      SPLIT_PART(PAYLOAD:commit:collection::STRING, '.', -1)                                           AS COLLECTION,
      PAYLOAD:commit:operation::STRING                                                                 AS OPERATION,
      PAYLOAD:commit:rkey::STRING                                                                      AS RKEY,
      'at://' || PAYLOAD:did::STRING || '/' || PAYLOAD:commit:collection::STRING || '/' || PAYLOAD:commit:rkey::STRING AS URI,
      PAYLOAD:commit:record:subject:uri::STRING                                                        AS SUBJECT_URI,
      IFF(IS_VARCHAR(PAYLOAD:commit:record:subject), PAYLOAD:commit:record:subject::STRING, NULL)      AS SUBJECT_DID,
      PAYLOAD:commit:record:text::STRING                                                               AS TEXT,
      PAYLOAD:commit:record:langs[0]::STRING                                                           AS LANG,
      PAYLOAD:commit:record:reply:parent:uri::STRING                                                   AS REPLY_PARENT_URI,
      TRY_TO_TIMESTAMP_NTZ(PAYLOAD:commit:record:createdAt::STRING)                                    AS CREATED_AT,
      SRC_FILE,
      LOADED_AT
    FROM batch
    -- The same event can arrive twice in one batch (producer rewind): keep one.
    QUALIFY ROW_NUMBER() OVER (PARTITION BY EVENT_KEY ORDER BY LOADED_AT) = 1
  )
  SELECT t.*, CURRENT_TIMESTAMP()
  FROM typed t
  -- Duplicates across batches only come from a rewind of seconds, so a two-hour window is enough.
  -- Checking the whole table would scan billions of rows at this volume.
  WHERE NOT EXISTS (
    SELECT 1 FROM STG.EVENT e
    WHERE e.EVENT_KEY = t.EVENT_KEY
      AND e.EVENT_TIME >= DATEADD(hour, -2, (SELECT MIN(EVENT_TIME) FROM typed))
  );
  inserted := SQLROWCOUNT;

  INSERT INTO OPS.RUN_LOG
  SELECT CURRENT_TIMESTAMP(), SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID'), 'LOAD_EVENTS', :inserted, NULL;
END;
$$;

-- RAW is a buffer: the lake keeps the files. Deletes do not show up in append-only streams.
CREATE OR REPLACE TASK PIPE.PURGE_RAW
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = 'USING CRON 30 3 * * * UTC'
  COMMENT = 'Delete raw rows older than 3 days'
AS
EXECUTE IMMEDIATE $$
BEGIN
  DELETE FROM RAW.POST_RAW   WHERE LOADED_AT < DATEADD(day, -3, CURRENT_TIMESTAMP());
  DELETE FROM RAW.LIKE_RAW   WHERE LOADED_AT < DATEADD(day, -3, CURRENT_TIMESTAMP());
  DELETE FROM RAW.REPOST_RAW WHERE LOADED_AT < DATEADD(day, -3, CURRENT_TIMESTAMP());
  DELETE FROM RAW.FOLLOW_RAW WHERE LOADED_AT < DATEADD(day, -3, CURRENT_TIMESTAMP());
END;
$$;

ALTER TASK PIPE.LOAD_EVENTS RESUME;
ALTER TASK PIPE.PURGE_RAW RESUME;
SHOW TASKS IN SCHEMA PIPE;
