-- Example publish-facing external location definitions
CREATE EXTERNAL TABLE IF NOT EXISTS publish_daily_orders
LOCATION 'abfss://publish@adlsretailplatformdev.dfs.core.windows.net/commerce/daily_orders/'
AS SELECT * FROM curated_orders_daily;
