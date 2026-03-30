CREATE OR REPLACE DYNAMIC TABLE int_customer_daily_metrics
  TARGET_LAG = '15 minutes'
  WAREHOUSE = transform_wh
AS
SELECT
  customer_id,
  order_date,
  COUNT(*) AS orders_cnt,
  SUM(gross_amount) AS gross_revenue,
  COUNT_IF(order_status = 'cancelled') AS cancelled_orders_cnt
FROM stg_orders_clean
GROUP BY customer_id, order_date;

CREATE OR REPLACE DYNAMIC TABLE int_paid_orders
  TARGET_LAG = '15 minutes'
  WAREHOUSE = transform_wh
AS
SELECT
  o.order_id,
  o.customer_id,
  o.order_ts,
  o.order_date,
  o.gross_amount,
  p.payment_ts,
  p.amount AS paid_amount
FROM stg_orders_clean AS o
INNER JOIN stg_payments_clean AS p
  ON p.order_id = o.order_id
WHERE p.payment_status = 'paid';