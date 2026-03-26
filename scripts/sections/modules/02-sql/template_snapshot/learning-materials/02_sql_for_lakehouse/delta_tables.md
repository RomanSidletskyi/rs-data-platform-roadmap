# Delta Tables

## What They Are

Delta tables provide:

- ACID transactions on data lake storage
- schema enforcement
- time travel
- merge support
- scalable reads and writes

## Example

```sql
CREATE TABLE silver_orders (
    order_id BIGINT,
    customer_id BIGINT,
    order_date TIMESTAMP,
    status STRING,
    amount DECIMAL(12,2)
)
USING DELTA;
```

## Why Important

Delta tables are a core abstraction for lakehouse architectures.
