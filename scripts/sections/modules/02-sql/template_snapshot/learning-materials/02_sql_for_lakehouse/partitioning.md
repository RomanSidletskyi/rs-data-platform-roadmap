# Partitioning

## Purpose

Partitioning reduces the amount of data scanned when queries filter on partition columns.

## Example

```sql
CREATE TABLE gold_daily_orders
USING DELTA
PARTITIONED BY (order_date)
AS
SELECT *
FROM silver_orders;
```

## Good Partition Columns

- low to medium cardinality
- common filter usage
- stable values

## Bad Partition Columns

- user_id
- order_id
- highly unique keys

## Main Warning

Over-partitioning creates too many small files and hurts performance.
