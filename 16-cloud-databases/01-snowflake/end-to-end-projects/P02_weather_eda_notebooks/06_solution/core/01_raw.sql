-- P02 schemas, stage, raw table, city dimension. Run as P02_OWNER.

USE ROLE P02_OWNER;
USE WAREHOUSE P02_WH;
USE DATABASE P02_WEATHER;

CREATE SCHEMA IF NOT EXISTS RAW      COMMENT = 'API responses as delivered';
CREATE SCHEMA IF NOT EXISTS STG      COMMENT = 'One row per city per hour';
CREATE SCHEMA IF NOT EXISTS MART     COMMENT = 'Daily, monthly, climatology, anomalies';
CREATE SCHEMA IF NOT EXISTS ANALYSIS COMMENT = 'Notebooks and their stage';

CREATE FILE FORMAT IF NOT EXISTS RAW.FF_API_JSON
  TYPE = JSON
  COMPRESSION = AUTO
  STRIP_OUTER_ARRAY = FALSE;

CREATE STAGE IF NOT EXISTS RAW.WEATHER_STAGE
  FILE_FORMAT = (FORMAT_NAME = 'RAW.FF_API_JSON')
  DIRECTORY = (ENABLE = TRUE)
  COMMENT = 'Open-Meteo responses, city=<slug>/year=YYYY/';

CREATE STAGE IF NOT EXISTS ANALYSIS.NOTEBOOK_STAGE
  DIRECTORY = (ENABLE = TRUE)
  COMMENT = 'Notebook source files, uploaded uncompressed';

-- One API response per row: parallel arrays of hourly values, plus _source lineage added by the downloader.
CREATE TABLE IF NOT EXISTS RAW.WEATHER_RAW (
  PAYLOAD   VARIANT,
  SRC_FILE  STRING,
  LOADED_AT TIMESTAMP_LTZ
);

CREATE OR REPLACE TABLE STG.CITY (
  CITY_SLUG STRING,
  CITY_NAME STRING,
  LATITUDE  FLOAT,
  LONGITUDE FLOAT,
  TIME_ZONE STRING,
  HEMISPHERE STRING
) AS
SELECT * FROM VALUES
  ('nyc',       'New York',  40.7128,  -74.0060, 'America/New_York',  'north'),
  ('london',    'London',    51.5074,   -0.1278, 'Europe/London',     'north'),
  ('kyiv',      'Kyiv',      50.4501,   30.5234, 'Europe/Kiev',       'north'),
  ('tokyo',     'Tokyo',     35.6762,  139.6503, 'Asia/Tokyo',        'north'),
  ('sydney',    'Sydney',   -33.8688,  151.2093, 'Australia/Sydney',  'south'),
  ('sao_paulo', 'Sao Paulo', -23.5505, -46.6333, 'America/Sao_Paulo', 'south');

GRANT USAGE ON DATABASE P02_WEATHER TO ROLE P02_READER;
GRANT USAGE ON SCHEMA MART TO ROLE P02_READER;
GRANT USAGE ON SCHEMA STG  TO ROLE P02_READER;
GRANT SELECT ON TABLE STG.CITY TO ROLE P02_READER;
