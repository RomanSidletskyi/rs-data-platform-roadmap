-- P11 semantic view: the metric definitions Snowflake itself knows about. Run as P11_OWNER after 40_mart.sql.
-- SQL users, notebooks, and Cortex Analyst query these metrics by name; Power BI keeps its own measures in DAX,
-- and tests/data_quality_checks.sql compares the two so the definitions cannot drift apart silently.

USE ROLE P11_OWNER;
USE WAREHOUSE P11_WH;
USE DATABASE P11_MARKETS;

CREATE OR REPLACE SEMANTIC VIEW SEM.FOOD_PRICES
  TABLES (
    prices AS MART.FACT_FOOD_PRICE
      PRIMARY KEY (PRICE_KEY)
      COMMENT = 'One comparable monthly price per market, commodity, price type, and unit',
    countries AS MART.DIM_COUNTRY
      PRIMARY KEY (COUNTRY_ISO3),
    commodities AS MART.DIM_COMMODITY
      PRIMARY KEY (COMMODITY_ID),
    markets AS MART.DIM_MARKET
      PRIMARY KEY (MARKET_ID)
  )
  RELATIONSHIPS (
    prices_to_countries AS prices (COUNTRY_ISO3) REFERENCES countries,
    prices_to_commodities AS prices (COMMODITY_ID) REFERENCES commodities,
    prices_to_markets AS prices (MARKET_ID) REFERENCES markets
  )
  FACTS (
    prices.price_usd_per_base AS PRICE_USD_PER_BASE
      COMMENT = 'USD per kg or litre',
    prices.price_eur_per_base AS PRICE_EUR_PER_BASE
      COMMENT = 'EUR per kg or litre',
    prices.price_local_per_base AS PRICE_LOCAL_PER_BASE
      COMMENT = 'Local currency per kg or litre; compare only within one country'
  )
  DIMENSIONS (
    countries.country_name AS COUNTRY_NAME WITH SYNONYMS = ('country'),
    countries.currency AS CURRENCY,
    commodities.commodity AS COMMODITY WITH SYNONYMS = ('food item', 'product'),
    commodities.category AS CATEGORY,
    markets.market AS MARKET,
    markets.admin1 AS ADMIN1 WITH SYNONYMS = ('region', 'province'),
    prices.month_start AS MONTH_START,
    prices.price_year AS YEAR(MONTH_START),
    prices.price_type AS PRICE_TYPE COMMENT = 'Retail or Wholesale; never mix them in one number',
    prices.base_unit AS BASE_UNIT,
    prices.fx_source AS FX_SOURCE
  )
  METRICS (
    prices.median_price_usd AS MEDIAN(prices.price_usd_per_base)
      COMMENT = 'Median USD per kg or litre across the selected markets and months',
    prices.median_price_eur AS MEDIAN(prices.price_eur_per_base),
    prices.median_price_local AS MEDIAN(prices.price_local_per_base),
    prices.price_observations AS COUNT(prices.price_usd_per_base),
    prices.markets_reporting AS COUNT(DISTINCT prices.MARKET_ID)
  )
  COMMENT = 'P11 food prices: comparable prices per kg or litre by country, commodity, market, and month';

GRANT USAGE ON SCHEMA SEM TO ROLE P11_BI_READER;
GRANT SELECT ON SEMANTIC VIEW SEM.FOOD_PRICES TO ROLE P11_BI_READER;

-- Same question, two ways: the semantic view by metric name, and plain SQL over the star.
SELECT * FROM SEMANTIC_VIEW(
  SEM.FOOD_PRICES
  METRICS prices.median_price_usd, prices.markets_reporting
  DIMENSIONS countries.country_name, commodities.commodity, prices.price_year
  WHERE prices.price_year = 2025 AND prices.price_type = 'Retail'
)
ORDER BY 1, 2
LIMIT 20;
