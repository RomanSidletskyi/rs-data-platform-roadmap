CREATE OR REPLACE DYNAMIC TABLE stg_orders_clean
  TARGET_LAG = '5 minutes'
  WAREHOUSE = transform_wh
AS
SELECT
  order_id,
  customer_id,
  order_ts,
  CAST(order_ts AS DATE) AS order_date,
  order_status,
  gross_amount,
  src_filename,
  load_ts
FROM raw.orders_raw
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY order_id
  ORDER BY load_ts DESC, src_filename DESC
) = 1;

CREATE OR REPLACE DYNAMIC TABLE stg_payments_clean
  TARGET_LAG = '5 minutes'
  WAREHOUSE = transform_wh
AS
SELECT
  payment_id,
  order_id,
  payment_ts,
  payment_status,
  amount,
  load_ts
FROM raw.payments_raw
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY payment_id
  ORDER BY load_ts DESC
) = 1;