-- P10 procedures: everything Airflow calls. Run as P10_OWNER after 01_schemas_and_tables.sql.
-- Each procedure works on one hour or one day and can be called again with the same argument at any time:
-- it replaces what it wrote before. That is what makes Airflow retries, cleared tasks, and backfills safe.
-- EXECUTE AS OWNER: the Airflow role can call them but cannot touch the tables directly.

USE ROLE P10_OWNER;
USE WAREHOUSE P10_WH;
USE DATABASE P10_GH;

-- 1. RAW: reload one hour file. Check the file, delete the hour, COPY with FORCE, log.
CREATE OR REPLACE PROCEDURE OPS.LOAD_HOUR(HOUR_START TIMESTAMP_NTZ, RUN_ID STRING)
RETURNS OBJECT
LANGUAGE SQL
EXECUTE AS OWNER
AS
$$
DECLARE
  h         TIMESTAMP_NTZ;
  rel_path  STRING;
  stmt      STRING;
  files     NUMBER DEFAULT 0;
  raw_rows  NUMBER DEFAULT 0;
  load_qid  STRING;
  missing_file EXCEPTION (-20101, 'P10 LOAD_HOUR: hour file not found on RAW.LANDING_STAGE; land it first');
  empty_load   EXCEPTION (-20102, 'P10 LOAD_HOUR: COPY loaded 0 rows');
BEGIN
  h := DATE_TRUNC('hour', HOUR_START);
  -- GH Archive writes the hour without a leading zero: 2026-11-09-5.json.gz
  rel_path := 'gharchive/dt=' || TO_CHAR(h, 'YYYY-MM-DD') || '/' || TO_CHAR(h, 'YYYY-MM-DD') || '-' || HOUR(h)::STRING || '.json.gz';

  -- COPY of a missing path succeeds with 0 files, so check first and never delete a good hour for nothing.
  stmt := 'LIST @RAW.LANDING_STAGE/' || rel_path;
  EXECUTE IMMEDIATE stmt;
  SELECT COUNT(*) INTO :files FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
  IF (files = 0) THEN
    RAISE missing_file;
  END IF;

  -- Delete, then load. No explicit transaction: if COPY fails the hour is absent and unlogged,
  -- BUILD_HOUR refuses to run, and the Airflow retry loads it again.
  DELETE FROM RAW.GH_EVENT_RAW WHERE EVENT_HOUR = :h;
  stmt := 'COPY INTO RAW.GH_EVENT_RAW (EVENT_HOUR, V, SRC_FILE, SRC_ROW, LOADED_AT) '
    || 'FROM (SELECT ''' || TO_CHAR(h, 'YYYY-MM-DD HH24:MI:SS') || '''::TIMESTAMP_NTZ, $1, METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, CURRENT_TIMESTAMP() '
    || 'FROM @RAW.LANDING_STAGE/' || rel_path || ') '
    || 'FILE_FORMAT = (FORMAT_NAME = ''RAW.FF_GH_JSON'') ON_ERROR = ABORT_STATEMENT FORCE = TRUE';
  EXECUTE IMMEDIATE stmt;
  load_qid := LAST_QUERY_ID();

  SELECT COUNT(*) INTO :raw_rows FROM RAW.GH_EVENT_RAW WHERE EVENT_HOUR = :h;
  IF (raw_rows = 0) THEN
    RAISE empty_load;
  END IF;

  MERGE INTO OPS.HOUR_LOG t
  USING (SELECT :h AS EVENT_HOUR) s
    ON t.EVENT_HOUR = s.EVENT_HOUR
  WHEN MATCHED THEN UPDATE SET
    SRC_FILE = :rel_path, RAW_ROWS = :raw_rows, STG_ROWS = NULL, OUTSIDE_HOUR = NULL,
    LOAD_COUNT = t.LOAD_COUNT + 1, LOAD_QUERY_ID = :load_qid, LOADED_AT = CURRENT_TIMESTAMP(),
    BUILT_AT = NULL, AIRFLOW_RUN_ID = :RUN_ID
  WHEN NOT MATCHED THEN INSERT
    (EVENT_HOUR, EVENT_DAY, SRC_FILE, RAW_ROWS, LOAD_COUNT, LOAD_QUERY_ID, LOADED_AT, AIRFLOW_RUN_ID)
    VALUES (:h, TO_DATE(:h), :rel_path, :raw_rows, 1, :load_qid, CURRENT_TIMESTAMP(), :RUN_ID);

  RETURN OBJECT_CONSTRUCT('event_hour', h, 'file', rel_path, 'raw_rows', raw_rows, 'copy_query_id', load_qid);
END;
$$;

-- 2. STG: rebuild one hour from RAW in one transaction. Readers never see a half-built hour.
CREATE OR REPLACE PROCEDURE OPS.BUILD_HOUR(HOUR_START TIMESTAMP_NTZ, RUN_ID STRING)
RETURNS OBJECT
LANGUAGE SQL
EXECUTE AS OWNER
AS
$$
DECLARE
  h            TIMESTAMP_NTZ;
  logged_rows  NUMBER;
  raw_rows     NUMBER DEFAULT 0;
  stg_rows     NUMBER DEFAULT 0;
  outside      NUMBER DEFAULT 0;
  not_loaded   EXCEPTION (-20111, 'P10 BUILD_HOUR: hour is not loaded or RAW differs from HOUR_LOG; run LOAD_HOUR first');
BEGIN
  h := DATE_TRUNC('hour', HOUR_START);
  SELECT MAX(RAW_ROWS) INTO :logged_rows FROM OPS.HOUR_LOG WHERE EVENT_HOUR = :h;
  SELECT COUNT(*) INTO :raw_rows FROM RAW.GH_EVENT_RAW WHERE EVENT_HOUR = :h;
  IF (logged_rows IS NULL OR raw_rows = 0 OR raw_rows <> logged_rows) THEN
    RAISE not_loaded;
  END IF;

  BEGIN TRANSACTION;
  DELETE FROM STG.GH_EVENT WHERE EVENT_HOUR = :h;
  INSERT INTO STG.GH_EVENT (
    EVENT_ID, EVENT_HOUR, EVENT_DAY, CREATED_AT, EVENT_TYPE, ACTION, ACTOR_ID, ACTOR_LOGIN, IS_BOT,
    REPO_ID, REPO_NAME, ORG_LOGIN, PR_NUMBER, PR_OUTCOME, ISSUE_NUMBER, PUSH_COMMITS, REF_TYPE, RELEASE_TAG, LOADED_AT)
  SELECT
    EVENT_ID, EVENT_HOUR, TO_DATE(EVENT_HOUR), CREATED_AT, EVENT_TYPE, ACTION, ACTOR_ID, ACTOR_LOGIN,
    ENDSWITH(ACTOR_LOGIN, '[bot]'),
    REPO_ID, REPO_NAME, ORG_LOGIN,
    IFF(EVENT_TYPE LIKE 'PullRequest%', COALESCE(V:payload:number, V:payload:pull_request:number)::NUMBER, NULL),
    -- Two eras of the same fact: closed + merged flag until October 2025, action 'merged' since early 2026.
    -- Between them the payload has neither, so the outcome of a closed pull request is unknown, not 'unmerged'.
    CASE
      WHEN EVENT_TYPE <> 'PullRequestEvent' THEN NULL
      WHEN ACTION = 'merged' THEN 'merged'
      WHEN ACTION = 'closed' AND V:payload:pull_request:merged::BOOLEAN THEN 'merged'
      WHEN ACTION = 'closed' AND V:payload:pull_request:merged::BOOLEAN = FALSE THEN 'closed_unmerged'
      WHEN ACTION = 'closed' THEN 'closed_unknown'
    END,
    IFF(EVENT_TYPE IN ('IssuesEvent', 'IssueCommentEvent'), V:payload:issue:number::NUMBER, NULL),
    IFF(EVENT_TYPE = 'PushEvent', V:payload:size::NUMBER, NULL),
    V:payload:ref_type::STRING,
    IFF(EVENT_TYPE = 'ReleaseEvent', V:payload:release:tag_name::STRING, NULL),
    CURRENT_TIMESTAMP()
  FROM (
    SELECT
      r.V,
      r.EVENT_HOUR,
      r.SRC_ROW,
      r.V:id::NUMBER(38, 0)                                                           AS EVENT_ID,
      TRY_TO_TIMESTAMP_NTZ(r.V:created_at::STRING, 'YYYY-MM-DD"T"HH24:MI:SS"Z"')      AS CREATED_AT,
      r.V:type::STRING                                                                AS EVENT_TYPE,
      r.V:payload:action::STRING                                                      AS ACTION,
      r.V:actor:id::NUMBER                                                            AS ACTOR_ID,
      r.V:actor:login::STRING                                                         AS ACTOR_LOGIN,
      r.V:repo:id::NUMBER                                                             AS REPO_ID,
      r.V:repo:name::STRING                                                           AS REPO_NAME,
      r.V:org:login::STRING                                                           AS ORG_LOGIN
    FROM RAW.GH_EVENT_RAW r
    WHERE r.EVENT_HOUR = :h
  )
  QUALIFY ROW_NUMBER() OVER (PARTITION BY EVENT_ID ORDER BY SRC_ROW) = 1;

  SELECT COUNT(*), COUNT_IF(CREATED_AT IS NULL OR CREATED_AT < :h OR CREATED_AT >= DATEADD(hour, 1, :h))
    INTO :stg_rows, :outside
  FROM STG.GH_EVENT WHERE EVENT_HOUR = :h;

  UPDATE OPS.HOUR_LOG
     SET STG_ROWS = :stg_rows, OUTSIDE_HOUR = :outside, BUILT_AT = CURRENT_TIMESTAMP(), AIRFLOW_RUN_ID = :RUN_ID
   WHERE EVENT_HOUR = :h;
  COMMIT;

  RETURN OBJECT_CONSTRUCT('event_hour', h, 'raw_rows', raw_rows, 'stg_rows', stg_rows, 'created_outside_hour', outside);
END;
$$;

-- 3. MART and source profile: rebuild one complete day.
CREATE OR REPLACE PROCEDURE OPS.BUILD_DAY(DAY DATE, RUN_ID STRING)
RETURNS OBJECT
LANGUAGE SQL
EXECUTE AS OWNER
AS
$$
DECLARE
  hours_built  NUMBER DEFAULT 0;
  logged_rows  NUMBER DEFAULT 0;
  stg_rows     NUMBER DEFAULT 0;
  stg_hash     NUMBER;
  incomplete   EXCEPTION (-20121, 'P10 BUILD_DAY: fewer than 24 hours built for this day');
  stg_mismatch EXCEPTION (-20122, 'P10 BUILD_DAY: STG rows differ from HOUR_LOG (day purged or partly reloaded); re-run the hourly DAG for the day');
BEGIN
  SELECT COUNT_IF(BUILT_AT IS NOT NULL), COALESCE(SUM(STG_ROWS), 0)
    INTO :hours_built, :logged_rows
  FROM OPS.HOUR_LOG WHERE EVENT_DAY = :DAY;
  IF (hours_built < 24) THEN
    RAISE incomplete;
  END IF;

  SELECT COUNT(*), HASH_AGG(EVENT_ID) INTO :stg_rows, :stg_hash FROM STG.GH_EVENT WHERE EVENT_DAY = :DAY;
  IF (stg_rows <> logged_rows) THEN
    RAISE stg_mismatch;
  END IF;

  BEGIN TRANSACTION;
  DELETE FROM MART.EVENT_TYPE_DAILY WHERE EVENT_DAY = :DAY;
  INSERT INTO MART.EVENT_TYPE_DAILY (EVENT_DAY, EVENT_TYPE, EVENTS, ACTORS, REPOS, BOT_EVENTS, BUILT_AT)
  SELECT EVENT_DAY, EVENT_TYPE, COUNT(*), COUNT(DISTINCT ACTOR_ID), COUNT(DISTINCT REPO_ID), COUNT_IF(IS_BOT), CURRENT_TIMESTAMP()
  FROM STG.GH_EVENT WHERE EVENT_DAY = :DAY
  GROUP BY EVENT_DAY, EVENT_TYPE;

  DELETE FROM MART.REPO_DAILY WHERE EVENT_DAY = :DAY;
  INSERT INTO MART.REPO_DAILY (
    EVENT_DAY, REPO_ID, REPO_NAME, EVENTS, STARS, FORKS, PUSHES, PRS_OPENED, PRS_MERGED, ISSUES_OPENED,
    RELEASES, HUMAN_ACTORS, BOT_EVENTS, BUILT_AT)
  SELECT
    EVENT_DAY, REPO_ID, MAX_BY(REPO_NAME, CREATED_AT), COUNT(*),
    COUNT_IF(EVENT_TYPE = 'WatchEvent'),
    COUNT_IF(EVENT_TYPE = 'ForkEvent'),
    COUNT_IF(EVENT_TYPE = 'PushEvent'),
    COUNT_IF(EVENT_TYPE = 'PullRequestEvent' AND ACTION = 'opened'),
    COUNT_IF(PR_OUTCOME = 'merged'),
    COUNT_IF(EVENT_TYPE = 'IssuesEvent' AND ACTION = 'opened'),
    COUNT_IF(EVENT_TYPE = 'ReleaseEvent' AND ACTION = 'published'),
    COUNT(DISTINCT IFF(IS_BOT, NULL, ACTOR_ID)),
    COUNT_IF(IS_BOT),
    CURRENT_TIMESTAMP()
  FROM STG.GH_EVENT WHERE EVENT_DAY = :DAY
  GROUP BY EVENT_DAY, REPO_ID;

  DELETE FROM OPS.SOURCE_PROFILE_DAILY WHERE EVENT_DAY = :DAY;
  INSERT INTO OPS.SOURCE_PROFILE_DAILY (EVENT_DAY, CHECK_NAME, NUMERATOR, DENOMINATOR, BUILT_AT)
  SELECT :DAY, 'push_events_with_commit_count', COUNT_IF(PUSH_COMMITS IS NOT NULL), COUNT(*), CURRENT_TIMESTAMP()
  FROM STG.GH_EVENT WHERE EVENT_DAY = :DAY AND EVENT_TYPE = 'PushEvent'
  UNION ALL
  SELECT :DAY, 'closed_prs_with_known_outcome', COUNT_IF(PR_OUTCOME IN ('merged', 'closed_unmerged')), COUNT(PR_OUTCOME), CURRENT_TIMESTAMP()
  FROM STG.GH_EVENT WHERE EVENT_DAY = :DAY AND EVENT_TYPE = 'PullRequestEvent'
  UNION ALL
  SELECT :DAY, 'pr_events_with_action_merged', COUNT_IF(ACTION = 'merged'), COUNT(*), CURRENT_TIMESTAMP()
  FROM STG.GH_EVENT WHERE EVENT_DAY = :DAY AND EVENT_TYPE = 'PullRequestEvent';

  -- A rebuilt day must be archived again before it may be purged.
  MERGE INTO OPS.DAY_LOG t
  USING (SELECT :DAY AS EVENT_DAY) s
    ON t.EVENT_DAY = s.EVENT_DAY
  WHEN MATCHED THEN UPDATE SET
    STG_ROWS = :stg_rows, STG_ID_HASH = :stg_hash, MART_BUILT_AT = CURRENT_TIMESTAMP(),
    ARCHIVE_ROWS = NULL, ARCHIVE_ID_HASH = NULL, ARCHIVE_FILES = NULL, ARCHIVE_BYTES = NULL,
    VERIFIED = NULL, ARCHIVED_AT = NULL, PURGED_AT = NULL, AIRFLOW_RUN_ID = :RUN_ID
  WHEN NOT MATCHED THEN INSERT (EVENT_DAY, STG_ROWS, STG_ID_HASH, MART_BUILT_AT, AIRFLOW_RUN_ID)
    VALUES (:DAY, :stg_rows, :stg_hash, CURRENT_TIMESTAMP(), :RUN_ID);
  COMMIT;

  RETURN OBJECT_CONSTRUCT('event_day', DAY, 'stg_rows', stg_rows);
END;
$$;

-- 4. ARCHIVE: unload one day as Parquet, read it back, compare, write a manifest.
CREATE OR REPLACE PROCEDURE OPS.ARCHIVE_DAY(DAY DATE, RUN_ID STRING)
RETURNS OBJECT
LANGUAGE SQL
EXECUTE AS OWNER
AS
$$
DECLARE
  d             STRING;
  prefix        STRING;
  stmt          STRING;
  expected_rows NUMBER;
  expected_hash NUMBER;
  stg_rows      NUMBER DEFAULT 0;
  arch_rows     NUMBER DEFAULT 0;
  arch_hash     NUMBER;
  arch_files    NUMBER DEFAULT 0;
  arch_bytes    NUMBER DEFAULT 0;
  ok            BOOLEAN DEFAULT FALSE;
  ext_tables    NUMBER DEFAULT 0;
  not_built     EXCEPTION (-20131, 'P10 ARCHIVE_DAY: day not built or STG changed since BUILD_DAY');
  not_verified  EXCEPTION (-20132, 'P10 ARCHIVE_DAY: archive read-back differs from STG; nothing will be purged');
BEGIN
  d := TO_CHAR(DAY, 'YYYY-MM-DD');
  prefix := 'events/dt=' || d || '/';

  SELECT MAX(STG_ROWS), MAX(STG_ID_HASH) INTO :expected_rows, :expected_hash
  FROM OPS.DAY_LOG WHERE EVENT_DAY = :DAY AND MART_BUILT_AT IS NOT NULL;
  SELECT COUNT(*) INTO :stg_rows FROM STG.GH_EVENT WHERE EVENT_DAY = :DAY;
  IF (expected_rows IS NULL OR stg_rows <> expected_rows) THEN
    RAISE not_built;
  END IF;

  -- OVERWRITE only replaces files with the same names; a re-run with fewer files would leave stale ones.
  stmt := 'REMOVE @ARCHIVE.ARCHIVE_STAGE/' || prefix;
  EXECUTE IMMEDIATE stmt;
  stmt := 'COPY INTO @ARCHIVE.ARCHIVE_STAGE/' || prefix || 'part '
    || 'FROM (SELECT EVENT_ID, EVENT_HOUR, CREATED_AT, EVENT_TYPE, ACTION, ACTOR_ID, ACTOR_LOGIN, IS_BOT, REPO_ID, '
    || 'REPO_NAME, ORG_LOGIN, PR_NUMBER, PR_OUTCOME, ISSUE_NUMBER, PUSH_COMMITS, REF_TYPE, RELEASE_TAG '
    || 'FROM STG.GH_EVENT WHERE EVENT_DAY = ''' || d || '''::DATE ORDER BY EVENT_TYPE, REPO_ID) '
    || 'FILE_FORMAT = (FORMAT_NAME = ''ARCHIVE.FF_PARQUET'') HEADER = TRUE MAX_FILE_SIZE = 134217728';
  EXECUTE IMMEDIATE stmt;

  -- Verify by reading the files back, not by trusting the unload result.
  stmt := 'SELECT COUNT(*), HASH_AGG($1:EVENT_ID::NUMBER(38, 0)) FROM @ARCHIVE.ARCHIVE_STAGE/' || prefix
    || ' (FILE_FORMAT => ''ARCHIVE.FF_PARQUET'')';
  EXECUTE IMMEDIATE stmt;
  SELECT $1, $2 INTO :arch_rows, :arch_hash FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

  stmt := 'LIST @ARCHIVE.ARCHIVE_STAGE/' || prefix;
  EXECUTE IMMEDIATE stmt;
  SELECT COUNT(*), COALESCE(SUM("size"), 0) INTO :arch_files, :arch_bytes FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

  ok := (arch_rows = expected_rows AND arch_hash = expected_hash);

  stmt := 'COPY INTO @ARCHIVE.ARCHIVE_STAGE/_manifests/events/dt=' || d || '.json '
    || 'FROM (SELECT OBJECT_CONSTRUCT(''event_day'', ''' || d || ''', ''rows'', ' || arch_rows::STRING
    || ', ''event_id_hash'', ' || COALESCE(arch_hash::STRING, 'NULL') || ', ''files'', ' || arch_files::STRING
    || ', ''bytes'', ' || arch_bytes::STRING || ', ''verified'', ' || ok::STRING
    || ', ''archived_at'', CURRENT_TIMESTAMP()::STRING)) '
    || 'FILE_FORMAT = (FORMAT_NAME = ''ARCHIVE.FF_MANIFEST'') SINGLE = TRUE OVERWRITE = TRUE';
  EXECUTE IMMEDIATE stmt;

  UPDATE OPS.DAY_LOG
     SET ARCHIVE_ROWS = :arch_rows, ARCHIVE_ID_HASH = :arch_hash, ARCHIVE_FILES = :arch_files,
         ARCHIVE_BYTES = :arch_bytes, VERIFIED = :ok, ARCHIVED_AT = CURRENT_TIMESTAMP(), AIRFLOW_RUN_ID = :RUN_ID
   WHERE EVENT_DAY = :DAY;

  IF (NOT ok) THEN
    RAISE not_verified;
  END IF;

  -- External table exists only with a cloud archive (azure/11 or aws/11); internal stages cannot back one.
  SELECT COUNT(*) INTO :ext_tables FROM INFORMATION_SCHEMA.EXTERNAL_TABLES
  WHERE TABLE_SCHEMA = 'ARCHIVE' AND TABLE_NAME = 'GH_EVENT_ARCHIVE';
  IF (ext_tables > 0) THEN
    stmt := 'ALTER EXTERNAL TABLE ARCHIVE.GH_EVENT_ARCHIVE REFRESH ''dt=' || d || '/''';
    EXECUTE IMMEDIATE stmt;
  END IF;

  RETURN OBJECT_CONSTRUCT('event_day', d, 'rows', arch_rows, 'files', arch_files, 'bytes', arch_bytes, 'verified', ok);
END;
$$;

-- 5. Retention: drop hot copies only for days whose archive was verified.
CREATE OR REPLACE PROCEDURE OPS.PURGE_HOT(HOT_DAYS NUMBER, RAW_DAYS NUMBER)
RETURNS OBJECT
LANGUAGE SQL
EXECUTE AS OWNER
AS
$$
DECLARE
  stg_deleted NUMBER DEFAULT 0;
  raw_deleted NUMBER DEFAULT 0;
BEGIN
  BEGIN TRANSACTION;
  DELETE FROM STG.GH_EVENT
   WHERE EVENT_DAY < DATEADD(day, -1 * :HOT_DAYS, CURRENT_DATE())
     AND EVENT_DAY IN (SELECT EVENT_DAY FROM OPS.DAY_LOG WHERE VERIFIED);
  stg_deleted := SQLROWCOUNT;

  DELETE FROM RAW.GH_EVENT_RAW
   WHERE EVENT_HOUR < DATEADD(day, -1 * :RAW_DAYS, CURRENT_DATE())
     AND TO_DATE(EVENT_HOUR) IN (SELECT EVENT_DAY FROM OPS.DAY_LOG WHERE VERIFIED);
  raw_deleted := SQLROWCOUNT;

  UPDATE OPS.DAY_LOG SET PURGED_AT = CURRENT_TIMESTAMP()
   WHERE VERIFIED AND PURGED_AT IS NULL AND EVENT_DAY < DATEADD(day, -1 * :HOT_DAYS, CURRENT_DATE());
  COMMIT;

  RETURN OBJECT_CONSTRUCT('stg_rows_deleted', stg_deleted, 'raw_rows_deleted', raw_deleted);
END;
$$;

-- Source drift: event type share or a field ratio moved far from the previous 7 calendar days.
CREATE OR REPLACE VIEW OPS.SOURCE_DRIFT AS
WITH days AS (SELECT DISTINCT EVENT_DAY FROM MART.EVENT_TYPE_DAILY),
types AS (SELECT DISTINCT EVENT_TYPE FROM MART.EVENT_TYPE_DAILY),
grid AS (
  SELECT d.EVENT_DAY, t.EVENT_TYPE, COALESCE(m.EVENTS, 0) AS EVENTS
  FROM days d
  CROSS JOIN types t
  LEFT JOIN MART.EVENT_TYPE_DAILY m ON m.EVENT_DAY = d.EVENT_DAY AND m.EVENT_TYPE = t.EVENT_TYPE
),
shares AS (
  SELECT EVENT_DAY, 'type_share:' || EVENT_TYPE AS METRIC,
         EVENTS / NULLIF(SUM(EVENTS) OVER (PARTITION BY EVENT_DAY), 0) AS METRIC_VALUE
  FROM grid
  UNION ALL
  SELECT EVENT_DAY, 'field_ratio:' || CHECK_NAME, NUMERATOR / NULLIF(DENOMINATOR, 0)
  FROM OPS.SOURCE_PROFILE_DAILY
),
compared AS (
  SELECT c.EVENT_DAY, c.METRIC, c.METRIC_VALUE, AVG(p.METRIC_VALUE) AS BASELINE, COUNT(p.METRIC_VALUE) AS BASELINE_DAYS
  FROM shares c
  LEFT JOIN shares p
    ON p.METRIC = c.METRIC AND p.EVENT_DAY BETWEEN DATEADD(day, -7, c.EVENT_DAY) AND DATEADD(day, -1, c.EVENT_DAY)
  GROUP BY c.EVENT_DAY, c.METRIC, c.METRIC_VALUE
),
classified AS (
  SELECT
    EVENT_DAY, METRIC, ROUND(METRIC_VALUE, 4) AS METRIC_VALUE, ROUND(BASELINE, 4) AS BASELINE, BASELINE_DAYS,
    CASE
      WHEN BASELINE >= 0.01 AND COALESCE(METRIC_VALUE, 0) = 0 THEN 'disappeared'
      WHEN COALESCE(BASELINE, 0) = 0 AND METRIC_VALUE >= 0.01 THEN 'appeared'
      WHEN STARTSWITH(METRIC, 'type_share:') AND BASELINE >= 0.01
           AND METRIC_VALUE / BASELINE NOT BETWEEN 0.5 AND 2 THEN 'share changed'
      WHEN STARTSWITH(METRIC, 'field_ratio:') AND ABS(METRIC_VALUE - BASELINE) >= 0.2 THEN 'ratio changed'
    END AS DRIFT
  FROM compared
  WHERE BASELINE_DAYS >= 3
)
SELECT * FROM classified WHERE DRIFT IS NOT NULL;

-- Airflow's role: call procedures, read the logs and the drift view. No table writes, no DDL.
GRANT USAGE ON SCHEMA OPS TO ROLE P10_PIPELINE;
GRANT USAGE ON PROCEDURE OPS.LOAD_HOUR(TIMESTAMP_NTZ, STRING) TO ROLE P10_PIPELINE;
GRANT USAGE ON PROCEDURE OPS.BUILD_HOUR(TIMESTAMP_NTZ, STRING) TO ROLE P10_PIPELINE;
GRANT USAGE ON PROCEDURE OPS.BUILD_DAY(DATE, STRING) TO ROLE P10_PIPELINE;
GRANT USAGE ON PROCEDURE OPS.ARCHIVE_DAY(DATE, STRING) TO ROLE P10_PIPELINE;
GRANT USAGE ON PROCEDURE OPS.PURGE_HOT(NUMBER, NUMBER) TO ROLE P10_PIPELINE;
GRANT SELECT ON TABLE OPS.HOUR_LOG TO ROLE P10_PIPELINE;
GRANT SELECT ON TABLE OPS.DAY_LOG TO ROLE P10_PIPELINE;
GRANT SELECT ON VIEW OPS.SOURCE_DRIFT TO ROLE P10_PIPELINE;
