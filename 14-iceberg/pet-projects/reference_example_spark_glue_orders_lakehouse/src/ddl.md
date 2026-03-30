# DDL

## Raw Events Table

```sql
CREATE TABLE IF NOT EXISTS prod.analytics.raw_orders_events (
  event_id STRING,
  order_id STRING,
  customer_id STRING,
  event_type STRING,
  event_ts TIMESTAMP,
  payload STRING
)
USING iceberg
PARTITIONED BY (days(event_ts));
```

## Current State Orders Table

```sql
CREATE TABLE IF NOT EXISTS prod.analytics.curated_orders_current (
  order_id STRING,
  customer_id STRING,
  order_status STRING,
  order_ts TIMESTAMP,
  amount DECIMAL(18,2),
  updated_at TIMESTAMP
)
USING iceberg
PARTITIONED BY (days(order_ts));
```

## Customer History Table

```sql
CREATE TABLE IF NOT EXISTS prod.analytics.dim_customer_history (
  customer_id STRING,
  customer_tier STRING,
  valid_from TIMESTAMP,
  valid_to TIMESTAMP,
  is_current BOOLEAN
)
USING iceberg;
```