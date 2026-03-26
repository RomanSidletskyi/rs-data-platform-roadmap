-- Example official publish-facing view
CREATE VIEW publish_daily_orders AS
SELECT business_date, store_id, net_sales
FROM external_daily_orders;
