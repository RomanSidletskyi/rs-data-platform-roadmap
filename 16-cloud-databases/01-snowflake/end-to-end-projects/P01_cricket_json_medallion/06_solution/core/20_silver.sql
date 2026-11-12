-- P01 silver tables and the stream that feeds them. Run as P01_OWNER.

USE ROLE P01_OWNER;
USE WAREHOUSE P01_WH;
USE DATABASE P01_CRICKET;

CREATE STREAM IF NOT EXISTS RAW.MATCH_RAW_STREAM
  ON TABLE RAW.MATCH_RAW
  APPEND_ONLY = TRUE
  SHOW_INITIAL_ROWS = TRUE;

-- The batch is copied out of the stream once per run, so every later statement sees the same matches.
CREATE TABLE IF NOT EXISTS STG.MATCH_BATCH (
  MATCH_ID  STRING,
  PAYLOAD   VARIANT,
  SRC_FILE  STRING,
  LOADED_AT TIMESTAMP_LTZ
);

CREATE TABLE IF NOT EXISTS STG.MATCH (
  MATCH_ID          STRING NOT NULL,
  MATCH_DATE        DATE,
  SEASON            STRING,
  MATCH_TYPE        STRING,
  GENDER            STRING,
  TEAM_TYPE         STRING,
  TEAM_1            STRING,
  TEAM_2            STRING,
  VENUE             STRING,
  CITY              STRING,
  EVENT_NAME        STRING,
  TOSS_WINNER       STRING,
  TOSS_DECISION     STRING,
  WINNER            STRING,
  WIN_BY_RUNS       NUMBER,
  WIN_BY_WICKETS    NUMBER,
  RESULT            STRING,
  METHOD            STRING,
  PLAYER_OF_MATCH   STRING,
  DATA_REVISION     NUMBER,
  SRC_FILE          STRING,
  UPDATED_AT        TIMESTAMP_LTZ
)
COMMENT = 'One row per match; latest data revision wins.';

CREATE TABLE IF NOT EXISTS STG.MATCH_PLAYER (
  MATCH_ID    STRING NOT NULL,
  TEAM        STRING,
  PLAYER_NAME STRING,
  PLAYER_ID   STRING
)
COMMENT = 'Squads per match with Cricsheet registry ids; names are not unique across matches, ids are.';

CREATE TABLE IF NOT EXISTS STG.DELIVERY (
  MATCH_ID        STRING NOT NULL,
  INNINGS_NO      NUMBER,
  IS_SUPER_OVER   BOOLEAN,
  BATTING_TEAM    STRING,
  OVER_NO         NUMBER,
  BALL_SEQ        NUMBER,
  BATTER          STRING,
  BOWLER          STRING,
  NON_STRIKER     STRING,
  RUNS_BATTER     NUMBER,
  RUNS_EXTRAS     NUMBER,
  RUNS_TOTAL      NUMBER,
  WIDES           NUMBER,
  NOBALLS         NUMBER,
  BYES            NUMBER,
  LEGBYES         NUMBER,
  IS_LEGAL_BALL   BOOLEAN,
  WICKET_COUNT    NUMBER,
  WICKET_KIND     STRING,
  PLAYER_OUT      STRING
)
COMMENT = 'One row per delivery; BALL_SEQ is the position within the over including extras.';
