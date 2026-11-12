-- P03 app stage. Run as P03_APP_OWNER before ./upload.sh app.
-- The app owner owns its own stage: the data team cannot change app code, the app team cannot change data.

USE ROLE P03_APP_OWNER;
USE WAREHOUSE P03_WH;
USE DATABASE P03_CONTENT;

CREATE STAGE IF NOT EXISTS APP.APP_STAGE
  DIRECTORY = (ENABLE = TRUE)
  COMMENT = 'Streamlit source files, uploaded uncompressed';

-- What the app role can see. RAW and STG must not appear here.
SHOW GRANTS TO ROLE P03_APP_OWNER;
