-- P01 task graph: LOAD_RAW (root) -> BUILD_SILVER -> BUILD_GOLD. Run as P01_OWNER.
-- All three are serverless; the root has a daily schedule but is normally started with EXECUTE TASK.
-- All tasks of one graph must be in the same schema, so they live in OPS and write to the other schemas.

USE ROLE P01_OWNER;
USE WAREHOUSE P01_WH;
USE DATABASE P01_CRICKET;

-- Changing a graph requires the root to be suspended.
ALTER TASK IF EXISTS OPS.LOAD_RAW SUSPEND;

CREATE OR REPLACE TASK OPS.LOAD_RAW
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = 'USING CRON 0 6 * * * UTC'
  COMMENT = 'Root: load new or changed match files from the internal stage'
AS
EXECUTE IMMEDIATE $$
BEGIN
  ALTER STAGE RAW.MATCH_STAGE REFRESH;
  -- COPY load metadata skips files already loaded with the same name and checksum.
  COPY INTO RAW.MATCH_RAW (PAYLOAD, SRC_FILE, FILE_LAST_MODIFIED, LOADED_AT)
  FROM (
    SELECT $1, METADATA$FILENAME, METADATA$FILE_LAST_MODIFIED, METADATA$START_SCAN_TIME
    FROM @RAW.MATCH_STAGE
  )
  FILE_FORMAT = (FORMAT_NAME = 'RAW.FF_MATCH_JSON')
  ON_ERROR = SKIP_FILE;
  INSERT INTO OPS.RUN_LOG SELECT CURRENT_TIMESTAMP(), 'LOAD_RAW', NULL, 'copy finished';
END;
$$;

CREATE OR REPLACE TASK OPS.BUILD_SILVER
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  COMMENT = 'Matches, squads, and deliveries for new or changed match files'
  AFTER OPS.LOAD_RAW
AS
EXECUTE IMMEDIATE $$
DECLARE
  batch_size NUMBER DEFAULT 0;
BEGIN
  -- One transaction: the stream advances only if every silver table was rebuilt for the batch.
  BEGIN TRANSACTION;

  DELETE FROM STG.MATCH_BATCH;
  INSERT INTO STG.MATCH_BATCH (MATCH_ID, PAYLOAD, SRC_FILE, LOADED_AT)
  SELECT SPLIT_PART(SPLIT_PART(SRC_FILE, '/', -1), '.', 1), PAYLOAD, SRC_FILE, LOADED_AT
  FROM RAW.MATCH_RAW_STREAM
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY SPLIT_PART(SPLIT_PART(SRC_FILE, '/', -1), '.', 1)
    ORDER BY PAYLOAD:meta:revision::NUMBER DESC, LOADED_AT DESC
  ) = 1;

  SELECT COUNT(*) INTO :batch_size FROM STG.MATCH_BATCH;

  MERGE INTO STG.MATCH AS T
  USING (
    SELECT
      MATCH_ID,
      TRY_TO_DATE(PAYLOAD:info:dates[0]::STRING)       AS MATCH_DATE,
      PAYLOAD:info:season::STRING                       AS SEASON,
      PAYLOAD:info:match_type::STRING                   AS MATCH_TYPE,
      PAYLOAD:info:gender::STRING                       AS GENDER,
      PAYLOAD:info:team_type::STRING                    AS TEAM_TYPE,
      PAYLOAD:info:teams[0]::STRING                     AS TEAM_1,
      PAYLOAD:info:teams[1]::STRING                     AS TEAM_2,
      PAYLOAD:info:venue::STRING                        AS VENUE,
      PAYLOAD:info:city::STRING                         AS CITY,
      PAYLOAD:info:event:name::STRING                   AS EVENT_NAME,
      PAYLOAD:info:toss:winner::STRING                  AS TOSS_WINNER,
      PAYLOAD:info:toss:decision::STRING                AS TOSS_DECISION,
      PAYLOAD:info:outcome:winner::STRING               AS WINNER,
      PAYLOAD:info:outcome:by:runs::NUMBER              AS WIN_BY_RUNS,
      PAYLOAD:info:outcome:by:wickets::NUMBER           AS WIN_BY_WICKETS,
      PAYLOAD:info:outcome:result::STRING               AS RESULT,
      PAYLOAD:info:outcome:method::STRING               AS METHOD,
      PAYLOAD:info:player_of_match[0]::STRING           AS PLAYER_OF_MATCH,
      PAYLOAD:meta:revision::NUMBER                     AS DATA_REVISION,
      SRC_FILE
    FROM STG.MATCH_BATCH
  ) AS S
  ON T.MATCH_ID = S.MATCH_ID
  WHEN MATCHED AND S.DATA_REVISION >= T.DATA_REVISION THEN UPDATE SET
    MATCH_DATE = S.MATCH_DATE, SEASON = S.SEASON, MATCH_TYPE = S.MATCH_TYPE, GENDER = S.GENDER,
    TEAM_TYPE = S.TEAM_TYPE, TEAM_1 = S.TEAM_1, TEAM_2 = S.TEAM_2, VENUE = S.VENUE, CITY = S.CITY,
    EVENT_NAME = S.EVENT_NAME, TOSS_WINNER = S.TOSS_WINNER, TOSS_DECISION = S.TOSS_DECISION,
    WINNER = S.WINNER, WIN_BY_RUNS = S.WIN_BY_RUNS, WIN_BY_WICKETS = S.WIN_BY_WICKETS, RESULT = S.RESULT,
    METHOD = S.METHOD, PLAYER_OF_MATCH = S.PLAYER_OF_MATCH, DATA_REVISION = S.DATA_REVISION,
    SRC_FILE = S.SRC_FILE, UPDATED_AT = CURRENT_TIMESTAMP()
  WHEN NOT MATCHED THEN INSERT (
    MATCH_ID, MATCH_DATE, SEASON, MATCH_TYPE, GENDER, TEAM_TYPE, TEAM_1, TEAM_2, VENUE, CITY, EVENT_NAME,
    TOSS_WINNER, TOSS_DECISION, WINNER, WIN_BY_RUNS, WIN_BY_WICKETS, RESULT, METHOD, PLAYER_OF_MATCH,
    DATA_REVISION, SRC_FILE, UPDATED_AT
  ) VALUES (
    S.MATCH_ID, S.MATCH_DATE, S.SEASON, S.MATCH_TYPE, S.GENDER, S.TEAM_TYPE, S.TEAM_1, S.TEAM_2, S.VENUE, S.CITY,
    S.EVENT_NAME, S.TOSS_WINNER, S.TOSS_DECISION, S.WINNER, S.WIN_BY_RUNS, S.WIN_BY_WICKETS, S.RESULT, S.METHOD,
    S.PLAYER_OF_MATCH, S.DATA_REVISION, S.SRC_FILE, CURRENT_TIMESTAMP()
  );

  DELETE FROM STG.MATCH_PLAYER WHERE MATCH_ID IN (SELECT MATCH_ID FROM STG.MATCH_BATCH);
  INSERT INTO STG.MATCH_PLAYER (MATCH_ID, TEAM, PLAYER_NAME, PLAYER_ID)
  SELECT
    b.MATCH_ID,
    team.key,
    player.value::STRING,
    GET(b.PAYLOAD:info:registry:people, player.value::STRING)::STRING
  FROM STG.MATCH_BATCH b,
    LATERAL FLATTEN(input => b.PAYLOAD:info:players) team,
    LATERAL FLATTEN(input => team.value) player;

  -- Rebuild deliveries per match instead of merging per ball: a corrected file replaces the whole match.
  DELETE FROM STG.DELIVERY WHERE MATCH_ID IN (SELECT MATCH_ID FROM STG.MATCH_BATCH);
  INSERT INTO STG.DELIVERY (
    MATCH_ID, INNINGS_NO, IS_SUPER_OVER, BATTING_TEAM, OVER_NO, BALL_SEQ, BATTER, BOWLER, NON_STRIKER,
    RUNS_BATTER, RUNS_EXTRAS, RUNS_TOTAL, WIDES, NOBALLS, BYES, LEGBYES, IS_LEGAL_BALL,
    WICKET_COUNT, WICKET_KIND, PLAYER_OUT
  )
  SELECT
    b.MATCH_ID,
    inn.index + 1,
    COALESCE(inn.value:super_over::BOOLEAN, FALSE),
    inn.value:team::STRING,
    ov.value:over::NUMBER,
    d.index + 1,
    d.value:batter::STRING,
    d.value:bowler::STRING,
    d.value:non_striker::STRING,
    d.value:runs:batter::NUMBER,
    d.value:runs:extras::NUMBER,
    d.value:runs:total::NUMBER,
    d.value:extras:wides::NUMBER,
    d.value:extras:noballs::NUMBER,
    d.value:extras:byes::NUMBER,
    d.value:extras:legbyes::NUMBER,
    d.value:extras:wides IS NULL AND d.value:extras:noballs IS NULL,
    COALESCE(ARRAY_SIZE(d.value:wickets), 0),
    d.value:wickets[0]:kind::STRING,
    d.value:wickets[0]:player_out::STRING
  FROM STG.MATCH_BATCH b,
    LATERAL FLATTEN(input => b.PAYLOAD:innings) inn,
    LATERAL FLATTEN(input => inn.value:overs) ov,
    LATERAL FLATTEN(input => ov.value:deliveries) d;

  INSERT INTO OPS.RUN_LOG SELECT CURRENT_TIMESTAMP(), 'BUILD_SILVER', :batch_size, NULL;
  COMMIT;
EXCEPTION
  WHEN OTHER THEN
    ROLLBACK;
    RAISE;
END;
$$;

CREATE OR REPLACE TASK OPS.BUILD_GOLD
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  COMMENT = 'Recompute player dimension and batting/bowling facts'
  AFTER OPS.BUILD_SILVER
AS
EXECUTE IMMEDIATE $$
BEGIN
  -- Full recompute is cheap at ODI scale and avoids incremental edge cases; see ADR-004.
  INSERT OVERWRITE INTO MART.DIM_PLAYER
  SELECT p.PLAYER_ID, MODE(p.PLAYER_NAME), MIN(m.MATCH_DATE), MAX(m.MATCH_DATE), COUNT(DISTINCT p.MATCH_ID)
  FROM STG.MATCH_PLAYER p
  JOIN STG.MATCH m ON m.MATCH_ID = p.MATCH_ID
  WHERE p.PLAYER_ID IS NOT NULL
  GROUP BY p.PLAYER_ID;

  INSERT OVERWRITE INTO MART.FACT_BATTING_INNINGS
  WITH bat AS (
    SELECT MATCH_ID, INNINGS_NO, BATTING_TEAM, BATTER,
           SUM(RUNS_BATTER) AS RUNS,
           COUNT_IF(WIDES IS NULL) AS BALLS_FACED,
           COUNT_IF(RUNS_BATTER = 4) AS FOURS,
           COUNT_IF(RUNS_BATTER = 6) AS SIXES
    FROM STG.DELIVERY
    WHERE NOT IS_SUPER_OVER
    GROUP BY 1, 2, 3, 4
  ),
  outs AS (
    SELECT MATCH_ID, INNINGS_NO, PLAYER_OUT, ANY_VALUE(WICKET_KIND) AS HOW_OUT
    FROM STG.DELIVERY
    WHERE PLAYER_OUT IS NOT NULL AND NOT IS_SUPER_OVER
    GROUP BY 1, 2, 3
  )
  SELECT b.MATCH_ID, m.MATCH_DATE, b.INNINGS_NO, b.BATTING_TEAM, p.PLAYER_ID, b.BATTER,
         b.RUNS, b.BALLS_FACED, b.FOURS, b.SIXES,
         o.PLAYER_OUT IS NOT NULL AND o.HOW_OUT NOT IN ('retired hurt', 'retired not out'),
         o.HOW_OUT,
         ROUND(100 * DIV0(b.RUNS, b.BALLS_FACED), 2)
  FROM bat b
  JOIN STG.MATCH m ON m.MATCH_ID = b.MATCH_ID
  LEFT JOIN outs o ON o.MATCH_ID = b.MATCH_ID AND o.INNINGS_NO = b.INNINGS_NO AND o.PLAYER_OUT = b.BATTER
  LEFT JOIN STG.MATCH_PLAYER p ON p.MATCH_ID = b.MATCH_ID AND p.PLAYER_NAME = b.BATTER;

  INSERT OVERWRITE INTO MART.FACT_BOWLING_INNINGS
  WITH bowl AS (
    SELECT MATCH_ID, INNINGS_NO, BATTING_TEAM, BOWLER,
           COUNT_IF(IS_LEGAL_BALL) AS LEGAL_BALLS,
           SUM(RUNS_BATTER + COALESCE(WIDES, 0) + COALESCE(NOBALLS, 0)) AS RUNS_CONCEDED,
           COUNT_IF(WICKET_KIND IN ('bowled', 'caught', 'lbw', 'stumped', 'caught and bowled', 'hit wicket')) AS WICKETS
    FROM STG.DELIVERY
    WHERE NOT IS_SUPER_OVER
    GROUP BY 1, 2, 3, 4
  )
  SELECT w.MATCH_ID, m.MATCH_DATE, w.INNINGS_NO,
         IFF(w.BATTING_TEAM = m.TEAM_1, m.TEAM_2, m.TEAM_1),
         p.PLAYER_ID, w.BOWLER, w.LEGAL_BALLS, w.RUNS_CONCEDED, w.WICKETS,
         ROUND(6 * DIV0(w.RUNS_CONCEDED, w.LEGAL_BALLS), 2)
  FROM bowl w
  JOIN STG.MATCH m ON m.MATCH_ID = w.MATCH_ID
  LEFT JOIN STG.MATCH_PLAYER p ON p.MATCH_ID = w.MATCH_ID AND p.PLAYER_NAME = w.BOWLER;

  INSERT INTO OPS.RUN_LOG SELECT CURRENT_TIMESTAMP(), 'BUILD_GOLD', NULL, 'facts recomputed';
END;
$$;

-- Enables the root and every dependent task in one call.
SELECT SYSTEM$TASK_DEPENDENTS_ENABLE('P01_CRICKET.OPS.LOAD_RAW');
SHOW TASKS IN DATABASE P01_CRICKET;
