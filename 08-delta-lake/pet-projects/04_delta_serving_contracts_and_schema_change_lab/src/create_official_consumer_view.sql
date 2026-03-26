CREATE OR REPLACE VIEW analytics.daily_store_sales AS
SELECT
  business_date,
  store_id,
  CAST(gross_sales AS DECIMAL(18,2)) AS gross_sales,
  order_count,
  refund_count
FROM gold.daily_store_sales
WHERE business_date >= DATE '{{ publish_start_date }}';
