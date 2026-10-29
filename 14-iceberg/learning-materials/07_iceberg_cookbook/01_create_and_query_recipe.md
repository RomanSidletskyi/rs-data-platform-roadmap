# Create And Query Recipe

## Goal

Create a first production-shaped Iceberg table and query it with a clear mental model.

This recipe is not only about syntax.

It is about creating the table in a way that already matches real platform thinking:

- explicit schema
- explicit partition transform
- explicit format-version choice
- explicit follow-up metadata inspection

## Example With Spark SQL

```sql
CREATE TABLE demo.sales.orders (
  order_id BIGINT,
  customer_id STRING,
  order_ts TIMESTAMP,
  order_date DATE,
  amount DECIMAL(18,2),
  status STRING
)
USING iceberg
PARTITIONED BY (days(order_ts), status)
TBLPROPERTIES (
  'format-version'='2',
  'write.format.default'='parquet',
  'write.target-file-size-bytes'='536870912'
);
```

```sql
INSERT INTO demo.sales.orders VALUES
  (1, 'c_101', TIMESTAMP '2026-03-01 10:00:00', DATE '2026-03-01', 120.50, 'paid'),
  (2, 'c_102', TIMESTAMP '2026-03-01 11:00:00', DATE '2026-03-01', 90.00, 'paid');
```

```sql
SELECT order_date, status, COUNT(*) AS orders_cnt, SUM(amount) AS total_amount
FROM demo.sales.orders
GROUP BY order_date, status
ORDER BY order_date, status;
```

## Equivalent PySpark Write

```python
source_df.writeTo("demo.sales.orders").append()
```

## Why This Shape

- the table is partitioned by transformed time, not raw path naming convention
- schema is explicit
- the table is now governed by metadata, not only folders

## What Files Usually Appear After The First Insert

After the first successful insert, a simplified file set often looks conceptually like:

```text
table_root/
  data/
    00000-0-....parquet
  metadata/
    00000-....metadata.json
    snap-....avro
    manifest-....avro
```

That means even the first table write usually creates:

- a data file
- a manifest
- a manifest list
- a metadata root

## Checklist After The First Create And Insert

1. Which catalog resolved the table?
2. Where is the current metadata root?
3. Which snapshot was created?
4. Which manifest indexes the new parquet file?
5. Did the table use `v1` or `v2` as intended?

## What To Inspect Next

After creating the table, inspect:

- where metadata files are written
- which catalog resolved the table
- how the first snapshot was recorded