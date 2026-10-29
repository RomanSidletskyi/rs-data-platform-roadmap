MERGE INTO prod.analytics.curated_orders_current AS target
USING (
  SELECT
    order_id,
    customer_id,
    order_status,
    order_ts,
    amount,
    updated_at
  FROM staging.latest_orders_snapshot
) AS source
ON target.order_id = source.order_id
WHEN MATCHED AND source.updated_at >= target.updated_at THEN UPDATE SET
  customer_id = source.customer_id,
  order_status = source.order_status,
  order_ts = source.order_ts,
  amount = source.amount,
  updated_at = source.updated_at
WHEN NOT MATCHED THEN INSERT (
  order_id,
  customer_id,
  order_status,
  order_ts,
  amount,
  updated_at
) VALUES (
  source.order_id,
  source.customer_id,
  source.order_status,
  source.order_ts,
  source.amount,
  source.updated_at
);