# Contract Checks

Use checks like:

- one accepted row per `order_id` in `curated_orders_current`
- at most one `is_current = true` row per `customer_id` in `dim_customer_history`
- no consumer depends on `raw_orders_events` as final business truth
- compaction and snapshot expiration are scheduled for curated tables