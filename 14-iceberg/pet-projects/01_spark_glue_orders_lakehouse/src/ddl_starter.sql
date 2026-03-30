CREATE NAMESPACE IF NOT EXISTS prod.analytics;

CREATE TABLE IF NOT EXISTS prod.analytics.raw_order_events (
  event_id STRING,
  order_id STRING,
  customer_id STRING,
  event_type STRING,
  order_status STRING,
  order_ts TIMESTAMP,
  amount DECIMAL(18,2),
  updated_at TIMESTAMP
)
USING iceberg
PARTITIONED BY (days(updated_at));

CREATE TABLE IF NOT EXISTS prod.analytics.fct_orders_current (
  order_id STRING,
  customer_id STRING,
  order_status STRING,
  order_ts TIMESTAMP,
  amount DECIMAL(18,2),
  updated_at TIMESTAMP,
  is_deleted BOOLEAN
)
USING iceberg
PARTITIONED BY (days(order_ts));

CREATE TABLE IF NOT EXISTS prod.analytics.dim_customer_history (
  customer_id STRING,
  customer_name STRING,
  customer_tier STRING,
  valid_from DATE,
  valid_to DATE,
  is_current BOOLEAN
)
USING iceberg;