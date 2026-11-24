-- P11 core tables written by the Snowpark build, plus the country-year view. Run as P11_OWNER.
-- Types are declared here; the pipeline appends into a LIKE copy and swaps, so these definitions survive every build.

USE ROLE P11_OWNER;
USE WAREHOUSE P11_WH;
USE DATABASE P11_MARKETS;

CREATE TABLE IF NOT EXISTS CORE.UNIT_MAP (
  UNIT             STRING,
  BASE_UNIT        STRING  COMMENT 'KG or L; NULL for counts and services',
  QUANTITY_IN_BASE FLOAT   COMMENT '90 KG -> 90, 500 ML -> 0.5',
  IS_COMPARABLE    BOOLEAN
);

CREATE TABLE IF NOT EXISTS CORE.FX_MONTHLY (
  CURRENCY          STRING,
  MONTH             STRING  COMMENT 'YYYY-MM',
  UNITS_PER_USD     FLOAT   COMMENT 'Chosen rate: ECB cross rate if published, else WFP implied',
  USD_PER_EUR       FLOAT,
  FX_SOURCE         STRING  COMMENT 'ECB | WFP_IMPLIED',
  ECB_UNITS_PER_USD FLOAT,
  WFP_UNITS_PER_USD FLOAT,
  ECB_WFP_DIFF_PCT  FLOAT   COMMENT 'Reconciliation where both sources exist'
);

CREATE TABLE IF NOT EXISTS CORE.FOOD_PRICE (
  COUNTRY_ISO3         STRING,
  MONTH                STRING,
  MARKET_ID            NUMBER,
  MARKET               STRING,
  ADMIN1               STRING,
  LATITUDE             FLOAT,
  LONGITUDE            FLOAT,
  CATEGORY             STRING,
  COMMODITY_ID         NUMBER,
  COMMODITY            STRING,
  UNIT                 STRING,
  PRICE_TYPE           STRING,
  PRICE_FLAG           STRING,
  CURRENCY             STRING,
  PRICE_LOCAL          FLOAT,
  WFP_USD_PRICE        FLOAT  COMMENT 'As published by WFP, rounded to cents',
  IS_COMPARABLE        BOOLEAN,
  BASE_UNIT            STRING,
  PRICE_LOCAL_PER_BASE FLOAT,
  PRICE_USD_PER_BASE   FLOAT,
  PRICE_EUR_PER_BASE   FLOAT,
  FX_SOURCE            STRING,
  SOURCE_VERSION       STRING
);

-- World Bank indicators pivoted to one row per country and year.
CREATE OR REPLACE VIEW CORE.COUNTRY_YEAR AS
SELECT
  COUNTRY_ISO3,
  YEAR,
  MAX(COUNTRY_NAME)                                               AS COUNTRY_NAME,
  MAX(IFF(INDICATOR_ID = 'FP.CPI.TOTL', VALUE, NULL))             AS CPI_INDEX_2010,
  MAX(IFF(INDICATOR_ID = 'FP.CPI.TOTL.ZG', VALUE, NULL))          AS CPI_INFLATION_PCT,
  MAX(IFF(INDICATOR_ID = 'NY.GDP.PCAP.CD', VALUE, NULL))          AS GDP_PER_CAPITA_USD,
  MAX(IFF(INDICATOR_ID = 'SP.POP.TOTL', VALUE, NULL))             AS POPULATION,
  MAX(IFF(INDICATOR_ID = 'PA.NUS.FCRF', VALUE, NULL))             AS OFFICIAL_LCU_PER_USD
FROM RAW.WB_INDICATOR_V
GROUP BY COUNTRY_ISO3, YEAR;
