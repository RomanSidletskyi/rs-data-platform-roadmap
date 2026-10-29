# Source Landscape

## Incoming Feeds

### Orders Event Feed

- lands in S3 every 5 minutes
- includes inserts, updates, and delete tombstones
- event key is `order_id`

### Customer Snapshot Feed

- lands daily in S3
- full-state snapshot of current customer attributes
- main business key is `customer_id`

## Important Implication

The two feeds should not be handled with the same ingestion mental model.

- orders feed is CDC-like and mutation-aware
- customer snapshot feed is full-state oriented and should be reconciled accordingly

## Initial Storage Assumption

- raw landing path for orders: `s3://company-raw/orders_cdc/`
- raw landing path for customers: `s3://company-raw/customer_snapshot/`
- warehouse root for Iceberg: `s3://company-lakehouse/warehouse/`