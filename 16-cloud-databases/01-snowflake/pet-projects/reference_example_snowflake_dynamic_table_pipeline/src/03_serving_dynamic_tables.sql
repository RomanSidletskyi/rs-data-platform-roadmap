CREATE OR REPLACE DYNAMIC TABLE mart_revenue_hourly
  TARGET_LAG = '30 minutes'
  WAREHOUSE = serving_wh
AS
SELECT
  DATE_TRUNC('hour', order_ts) AS revenue_hour,
  SUM(paid_amount) AS paid_revenue,
  COUNT(*) AS paid_orders_cnt
FROM int_paid_orders
WHERE order_ts >= CURRENT_DATE - 14
GROUP BY DATE_TRUNC('hour', order_ts);

CREATE OR REPLACE DYNAMIC TABLE mart_customer_daily_summary
  TARGET_LAG = '30 minutes'
  WAREHOUSE = serving_wh
AS
SELECT
  customer_id,
  order_date,
  orders_cnt,
  gross_revenue,
  cancelled_orders_cnt
FROM int_customer_daily_metrics;