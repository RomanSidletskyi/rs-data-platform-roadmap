# Branch Flow

Representative SQL flow:

```sql
CREATE BRANCH IF NOT EXISTS dev_price_fix IN lab FROM main;

USE REFERENCE dev_price_fix IN lab;

CREATE TABLE IF NOT EXISTS lab.sales.orders_fix (
  order_id STRING,
  amount DECIMAL(18,2),
  updated_at TIMESTAMP
)
USING iceberg;

LIST REFERENCES IN lab;
SHOW REFERENCE IN lab;

USE REFERENCE main IN lab;
MERGE BRANCH dev_price_fix INTO main IN lab;
```

## Why This Matters

- branch isolation is visible
- publish state is promoted deliberately
- users are not forced to infer release state from physical file paths