SELECT
  COUNT(*) AS duplicate_order_rows
FROM (
  SELECT
    order_id,
    COUNT(*) AS row_cnt
  FROM stg_orders_clean
  GROUP BY order_id
  HAVING COUNT(*) > 1
);

SELECT
  COUNT(*) AS null_customer_rows
FROM stg_orders_clean
WHERE customer_id IS NULL;

SELECT
  COUNT(*) AS mismatched_payment_rows
FROM int_paid_orders
WHERE paid_amount <= 0;

SELECT
  COUNT(*) AS missing_revenue_hour_rows
FROM mart_revenue_hourly
WHERE revenue_hour IS NULL;

SELECT
  table_name,
  target_lag
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLES())
WHERE table_name IN (
  'STG_ORDERS_CLEAN',
  'STG_PAYMENTS_CLEAN',
  'INT_CUSTOMER_DAILY_METRICS',
  'INT_PAID_ORDERS',
  'MART_REVENUE_HOURLY',
  'MART_CUSTOMER_DAILY_SUMMARY'
)
ORDER BY table_name;