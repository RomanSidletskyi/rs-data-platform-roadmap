-- P03 deploy: create the Streamlit app from the staged files and share it with viewers. Run as P03_APP_OWNER
-- after ./upload.sh app. Rerun after every code change: CREATE copies the files once, so a new upload alone
-- does not change the running app. OR REPLACE drops grants, so the viewer grant is repeated below.

USE ROLE P03_APP_OWNER;
USE WAREHOUSE P03_WH;
USE DATABASE P03_CONTENT;

LIST @APP.APP_STAGE;

CREATE OR REPLACE STREAMLIT APP.CONTENT_ANALYTICS
  FROM '@P03_CONTENT.APP.APP_STAGE'
  MAIN_FILE = 'streamlit_app.py'
  QUERY_WAREHOUSE = P03_WH
  TITLE = 'Wikipedia content analytics'
  COMMENT = 'P03 serving-layer app over MART';

-- Without a live version the app is not available until its owner opens it in Snowsight.
ALTER STREAMLIT APP.CONTENT_ANALYTICS ADD LIVE VERSION FROM LAST;

GRANT USAGE ON STREAMLIT APP.CONTENT_ANALYTICS TO ROLE P03_VIEWER;

SHOW STREAMLITS IN SCHEMA APP;
