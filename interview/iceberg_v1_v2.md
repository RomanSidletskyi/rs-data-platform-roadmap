# Iceberg v1 And v2 Interview Cheat Sheet

## Core idea

Iceberg format version defines what table semantics are allowed.

It is not the same thing as:

- Spark version
- Iceberg library version
- catalog type

The most important interview distinction is usually between `v1` and `v2`.

## Key Interview Questions And Answers

### 1. What is the difference between Iceberg `v1` and `v2`?

Strong short answer:

- `v1` is strong for snapshot-based analytics, schema evolution, partition evolution, and append-heavy workloads
- `v2` adds row-level mutation semantics such as delete-aware behavior and richer sequencing metadata

### 2. Is `v1` read-only?

No.

That is a common mistake.

`v1` supports real writes, especially:

- append
- many overwrite-style analytical patterns
- compaction and maintenance workflows

What it does not provide is the full row-level delete-file mutation model associated with `v2`.

### 3. When is `v1` a good choice?

`v1` is a good choice when the workload is mostly:

- append-heavy
- batch-oriented
- low-mutation
- compatibility-sensitive across readers

### 4. When is `v2` a good choice?

`v2` is a good choice when the table contract needs:

- row-level deletes
- merge-like updates
- mutation-aware planning
- current-state tables fed by CDC-like workloads

### 5. What does `v2` add conceptually?

The main conceptual additions are:

- delete-file semantics
- stronger sequence-number model
- richer metadata for mutation-aware planning
- better support for row-level change workflows

### 6. Does `v2` mean every engine supports every mutation equally?

No.

This is one of the strongest interview points.

Good phrasing:

- `v2` enables richer semantics at the table-format level
- engine support for those semantics must still be checked in practice

### 7. Why do sequence numbers matter more in `v2`?

They help the engine understand change ordering and how delete artifacts apply to data files.

This is one reason `v2` is more operationally subtle than `v1`.

### 8. What is the relationship between `MERGE` and `v2`?

In interviews, a strong short answer is:

- append-heavy tables can often stay on `v1`
- mutation-heavy current-state tables usually push you into `v2` plus engine compatibility checks

### 9. What is the difference between equality deletes and position deletes?

Equality delete:

- row identity is value-based, for example `order_id`

Position delete:

- row identity is physical-file-based, for example file path plus row position

Both are mutation-aware concepts associated with modern Iceberg semantics.

### 10. What is a good architecture answer if asked how to choose `v1` or `v2`?

Say this clearly:

I choose based on workload semantics, not fashion. If the table is append-heavy and compatibility matters, `v1` is often enough. If the table contract includes row-level updates or deletes, then `v2` is usually the right direction, but I also verify engine support before standardizing it.

## Fast Comparison Table

| Concern | v1 | v2 |
|---|---|---|
| Snapshot-based reads | Yes | Yes |
| Schema evolution | Yes | Yes |
| Partition evolution | Yes | Yes |
| Append writes | Yes | Yes |
| Row-level delete semantics | No | Yes |
| Merge-heavy workload fit | Weak | Stronger |
| Broad compatibility pressure | Better | Must be checked more carefully |

## Practical SQL Example

### Table creation with explicit format version

```sql
CREATE TABLE prod.analytics.orders (
  order_id STRING,
  customer_id STRING,
  order_ts TIMESTAMP,
  amount DECIMAL(18,2)
)
USING iceberg
PARTITIONED BY (days(order_ts))
TBLPROPERTIES (
  'format-version'='2'
);
```

### Merge-like current-state example

```sql
MERGE INTO prod.analytics.orders_current AS target
USING staging.latest_orders AS source
ON target.order_id = source.order_id
WHEN MATCHED THEN UPDATE SET
  customer_id = source.customer_id,
  order_ts = source.order_ts,
  amount = source.amount
WHEN NOT MATCHED THEN INSERT (
  order_id,
  customer_id,
  order_ts,
  amount
) VALUES (
  source.order_id,
  source.customer_id,
  source.order_ts,
  source.amount
);
```

## PySpark Configuration Example

```python
from pyspark.sql import SparkSession


spark = (
    SparkSession.builder
    .appName("iceberg-v2-example")
    .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions")
    .config("spark.sql.catalog.prod", "org.apache.iceberg.spark.SparkCatalog")
    .config("spark.sql.catalog.prod.type", "glue")
    .config("spark.sql.catalog.prod.warehouse", "s3://company-lakehouse/warehouse")
    .config("spark.sql.catalog.prod.io-impl", "org.apache.iceberg.aws.s3.S3FileIO")
    .getOrCreate()
)
```

## Good Interview Phrases

- "`v1` is not read-only; it is still a serious analytical table format."
- "`v2` matters when row-level mutation semantics become part of the table contract."
- "I do not choose `v2` only because it sounds newer. I choose it when the workload actually needs it."
- "Table-format capability and engine capability are related, but they are not identical."

## Common Mistakes To Avoid In Answers

- saying `v1` cannot write
- saying `v2` automatically means universal merge support everywhere
- confusing Iceberg format version with Spark version
- choosing `v2` with no real mutation requirement

## Quick Summary

Use `v1` for append-heavy, compatibility-sensitive analytical tables. Use `v2` when row-level mutation semantics are genuinely required. The strongest interview answer is not only the feature difference, but the workload reasoning and the engine-compatibility caution.