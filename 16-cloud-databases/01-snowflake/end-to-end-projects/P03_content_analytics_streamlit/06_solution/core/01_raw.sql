-- P03 schemas, stage, raw table, reference tables, app grants. Run as P03_OWNER.

USE ROLE P03_OWNER;
USE WAREHOUSE P03_WH;
USE DATABASE P03_CONTENT;

CREATE SCHEMA IF NOT EXISTS RAW  COMMENT = 'API responses as delivered';
CREATE SCHEMA IF NOT EXISTS STG  COMMENT = 'Typed, deduplicated rows';
CREATE SCHEMA IF NOT EXISTS MART COMMENT = 'Serving layer for the app';
CREATE SCHEMA IF NOT EXISTS APP  COMMENT = 'Streamlit app and its stage, owned by P03_APP_OWNER';

CREATE FILE FORMAT IF NOT EXISTS RAW.FF_API_JSON
  TYPE = JSON
  COMPRESSION = AUTO;

CREATE STAGE IF NOT EXISTS RAW.PAGEVIEWS_STAGE
  FILE_FORMAT = (FORMAT_NAME = 'RAW.FF_API_JSON')
  DIRECTORY = (ENABLE = TRUE)
  COMMENT = 'kind=top|aggregate/project=<project>/';

CREATE TABLE IF NOT EXISTS RAW.PAGEVIEWS_RAW (
  PAYLOAD   VARIANT,
  SRC_FILE  STRING,
  LOADED_AT TIMESTAMP_LTZ
);

CREATE OR REPLACE TABLE STG.PROJECT (
  PROJECT   STRING,
  LABEL     STRING,
  MAIN_PAGE STRING
) AS
SELECT * FROM VALUES
  ('en.wikipedia', 'English Wikipedia',   'Main_Page'),
  ('de.wikipedia', 'German Wikipedia',    'Wikipedia:Hauptseite'),
  ('uk.wikipedia', 'Ukrainian Wikipedia', 'Головна_сторінка');

-- Pages that are not articles. Titles like 'Ramayana:_Part_1' contain a colon but are content,
-- so the filter compares the exact prefix before the first colon with this list.
CREATE OR REPLACE TABLE STG.NON_CONTENT_NAMESPACE (
  PROJECT   STRING,
  NAMESPACE STRING
) AS
SELECT * FROM VALUES
  ('en.wikipedia', 'Special'),   ('en.wikipedia', 'Wikipedia'), ('en.wikipedia', 'File'),
  ('en.wikipedia', 'Portal'),    ('en.wikipedia', 'Category'),  ('en.wikipedia', 'Help'),
  ('en.wikipedia', 'Template'),  ('en.wikipedia', 'User'),      ('en.wikipedia', 'Talk'),
  ('de.wikipedia', 'Spezial'),   ('de.wikipedia', 'Wikipedia'), ('de.wikipedia', 'Datei'),
  ('de.wikipedia', 'Portal'),    ('de.wikipedia', 'Kategorie'), ('de.wikipedia', 'Hilfe'),
  ('de.wikipedia', 'Vorlage'),   ('de.wikipedia', 'Benutzer'),  ('de.wikipedia', 'Diskussion'),
  ('uk.wikipedia', 'Спеціальна'), ('uk.wikipedia', 'Вікіпедія'), ('uk.wikipedia', 'Файл'),
  ('uk.wikipedia', 'Портал'),     ('uk.wikipedia', 'Категорія'), ('uk.wikipedia', 'Довідка'),
  ('uk.wikipedia', 'Шаблон'),     ('uk.wikipedia', 'Користувач'), ('uk.wikipedia', 'Обговорення');

-- The app owner reads MART and builds in APP; nothing else.
GRANT USAGE ON DATABASE P03_CONTENT TO ROLE P03_APP_OWNER;
GRANT USAGE ON SCHEMA MART TO ROLE P03_APP_OWNER;
GRANT USAGE ON SCHEMA APP  TO ROLE P03_APP_OWNER;
GRANT CREATE STAGE, CREATE STREAMLIT ON SCHEMA APP TO ROLE P03_APP_OWNER;

-- Viewers only need to reach the app object.
GRANT USAGE ON DATABASE P03_CONTENT TO ROLE P03_VIEWER;
GRANT USAGE ON SCHEMA APP TO ROLE P03_VIEWER;
