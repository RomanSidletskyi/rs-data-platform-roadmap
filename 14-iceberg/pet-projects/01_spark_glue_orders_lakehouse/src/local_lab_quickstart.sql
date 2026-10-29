CREATE NAMESPACE IF NOT EXISTS lab.analytics;

CREATE TABLE IF NOT EXISTS lab.analytics.raw_order_events (
  event_id STRING,
  order_id STRING,
  customer_id STRING,
  event_type STRING,
  order_status STRING,
  order_total DECIMAL(10, 2),
  event_ts TIMESTAMP,
  source_file STRING
)
USING iceberg
PARTITIONED BY (days(event_ts));

INSERT INTO lab.analytics.raw_order_events VALUES
  (
    'evt-1001',
    'ord-9001',
    'cust-120',
    'UPSERT',
    'created',
    149.99,
    TIMESTAMP '2026-03-27 10:00:00',
    'orders_20260327_1000.json'
  ),
  (
    'evt-1002',
    'ord-9001',
    'cust-120',
    'UPSERT',
    'paid',
    149.99,
    TIMESTAMP '2026-03-27 10:05:00',
    'orders_20260327_1005.json'
  );

SELECT order_id, order_status, order_total, event_ts
FROM lab.analytics.raw_order_events
ORDER BY event_ts;