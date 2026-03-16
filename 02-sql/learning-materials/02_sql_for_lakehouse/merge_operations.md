# Merge Operations

## Goal

Perform upserts and synchronized loads.

## Example

```sql
MERGE INTO silver_orders t
USING staged_orders s
ON t.order_id = s.order_id
WHEN MATCHED THEN UPDATE SET
    t.customer_id = s.customer_id,
    t.order_date = s.order_date,
    t.status = s.status,
    t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (
    order_id, customer_id, order_date, status, amount
) VALUES (
    s.order_id, s.customer_id, s.order_date, s.status, s.amount
);
```

## Use Cases

- CDC ingestion
- incremental loads
- deduplicated upserts
- dimension maintenance
