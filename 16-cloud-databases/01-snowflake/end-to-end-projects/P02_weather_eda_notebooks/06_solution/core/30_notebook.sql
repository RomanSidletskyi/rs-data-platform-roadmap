-- P02 notebook: create a Snowflake Notebook from the staged .ipynb. Run as P02_OWNER after ./upload.sh notebook.
-- Alternative without SQL: Snowsight, Projects, Notebooks, Import .ipynb file.

USE ROLE P02_OWNER;
USE WAREHOUSE P02_WH;
USE DATABASE P02_WEATHER;

LIST @ANALYSIS.NOTEBOOK_STAGE;

CREATE OR REPLACE NOTEBOOK ANALYSIS.WEATHER_EDA
  FROM '@P02_WEATHER.ANALYSIS.NOTEBOOK_STAGE'
  MAIN_FILE = 'weather_eda.ipynb'
  QUERY_WAREHOUSE = P02_WH
  COMMENT = 'P02 exploratory analysis';

-- Notebooks created with SQL need a live version before they open in Snowsight.
ALTER NOTEBOOK ANALYSIS.WEATHER_EDA ADD LIVE VERSION FROM LAST;

SHOW NOTEBOOKS IN SCHEMA ANALYSIS;
