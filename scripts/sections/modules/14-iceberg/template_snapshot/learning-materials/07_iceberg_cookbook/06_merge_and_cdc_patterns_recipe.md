# Merge And CDC Patterns Recipe

## Goal

Provide one practical playbook for the most common mutation-oriented Iceberg workflows:

- append-only ingestion
- late-arriving corrections
- equality-delete style logical removals
- compaction after deletes

The point is not just syntax.

The point is to understand which write pattern matches which table contract.

## 1. First Decision: Do You Really Need CDC Semantics

Before writing any `MERGE`, ask:

1. Is the table truly append-only?
2. Do corrections arrive later for existing business keys?
3. Do deletes exist in the upstream contract?
4. Do readers expect current-state semantics or event-log semantics?

If the table is really an immutable event log, forcing `MERGE` into it is often a design mistake.

## 2. Scenario A: Append-Only Ingestion

Use this when:

- every source record is a new fact
- old rows are not corrected in place
- consumers can aggregate over duplicates or late arrivals explicitly

Representative Spark pattern:

```python
incoming_df = (
    spark.read.json("s3://raw-company/orders/events/dt=2026-03-27/")
    .select(
        "event_id",
        "order_id",
        "event_ts",
        "event_type",
        "payload"
    )
)

incoming_df.writeTo("glue_prod.analytics.order_events").append()
```

Representative table shape:

```sql
CREATE TABLE IF NOT EXISTS glue_prod.analytics.order_events (
  event_id STRING,
  order_id BIGINT,
  event_ts TIMESTAMP,
  event_type STRING,
  payload STRING
)
USING iceberg
PARTITIONED BY (days(event_ts), event_type)
TBLPROPERTIES (
  'format-version'='1'
);
```

Why this is good:

- simple commit model
- broad compatibility
- cheap mental model for downstream readers

Architect rule:

If the business truth is an event stream, prefer append-only semantics unless a curated current-state table is explicitly needed.

## 3. Scenario B: Late-Arriving Corrections

Use this when:

- a record may first arrive incomplete
- later a more correct version for the same business key arrives
- downstream readers want current state, not raw event history

Typical shape:

1. land corrections into a staging table
2. deduplicate staging rows by business key and recency
3. `MERGE` the deduplicated batch into the curated Iceberg table

Representative staging deduplication:

```python
from pyspark.sql import functions as F
from pyspark.sql import Window


window_spec = Window.partitionBy("order_id").orderBy(F.col("event_ts").desc())

latest_updates_df = (
    spark.read.table("glue_prod.stage.orders_cdc")
    .withColumn("row_rank", F.row_number().over(window_spec))
    .filter("row_rank = 1")
    .drop("row_rank")
)

latest_updates_df.createOrReplaceTempView("latest_orders_cdc")
```

Representative `MERGE`:

```sql
MERGE INTO glue_prod.analytics.orders_curated AS target
USING latest_orders_cdc AS source
ON target.order_id = source.order_id
WHEN MATCHED AND source.op IN ('U', 'C') THEN UPDATE SET
  target.customer_id = source.customer_id,
  target.order_ts = source.order_ts,
  target.order_date = source.order_date,
  target.amount = source.amount,
  target.status = source.status,
  target.source_event_ts = source.event_ts
WHEN NOT MATCHED AND source.op IN ('I', 'U', 'C') THEN INSERT (
  order_id,
  customer_id,
  order_ts,
  order_date,
  amount,
  status,
  source_event_ts
) VALUES (
  source.order_id,
  source.customer_id,
  source.order_ts,
  source.order_date,
  source.amount,
  source.status,
  source.event_ts
);
```

Important design point:

- the staging area absorbs source messiness
- the curated table exposes stable current-state semantics

Anti-pattern:

Running raw, duplicate-rich CDC directly into the final table without deduplication usually creates unstable `MERGE` results and harder debugging.

## 4. Scenario C: Equality-Delete Style Logical Removals

Use this when:

- the source emits delete tombstones by business key
- you know which rows are invalid logically
- physical row positions are not part of the contract

Conceptual CDC feed:

```text
order_id | op | event_ts
---------+----+-------------------
1001     | D  | 2026-03-27 10:05
1002     | D  | 2026-03-27 10:08
```

Representative delete step:

```sql
DELETE FROM glue_prod.analytics.orders_curated
WHERE order_id IN (
  SELECT order_id
  FROM latest_orders_cdc
  WHERE op = 'D'
);
```

Or combine it into one mutation-aware `MERGE`:

```sql
MERGE INTO glue_prod.analytics.orders_curated AS target
USING latest_orders_cdc AS source
ON target.order_id = source.order_id
WHEN MATCHED AND source.op = 'D' THEN DELETE
WHEN MATCHED AND source.op IN ('U', 'C') THEN UPDATE SET
  target.customer_id = source.customer_id,
  target.order_ts = source.order_ts,
  target.order_date = source.order_date,
  target.amount = source.amount,
  target.status = source.status,
  target.source_event_ts = source.event_ts
WHEN NOT MATCHED AND source.op IN ('I', 'U', 'C') THEN INSERT (
  order_id,
  customer_id,
  order_ts,
  order_date,
  amount,
  status,
  source_event_ts
) VALUES (
  source.order_id,
  source.customer_id,
  source.order_ts,
  source.order_date,
  source.amount,
  source.status,
  source.event_ts
);
```

What happens conceptually in `v2` thinking:

- a new snapshot is committed
- delete-aware metadata state is created
- readers now apply delete semantics when planning and scanning

Why this is usually described as equality-delete friendly:

- row identity comes from key columns like `order_id`
- the logical contract is value-based, not file-position-based

## 5. Scenario D: Compaction After Deletes

Delete-heavy tables should not be left forever in a purely fragmented logical-delete state.

Why compaction matters:

- many delete artifacts increase read cost
- too many small rewritten files increase planning overhead
- operationally, the table becomes harder to reason about

Representative maintenance sequence:

```python
spark.sql(
    """
    CALL glue_prod.system.rewrite_data_files(
      table => 'analytics.orders_curated'
    )
    """
)

spark.sql(
    """
    CALL glue_prod.system.expire_snapshots(
      table => 'analytics.orders_curated',
      older_than => TIMESTAMP '2026-03-20 00:00:00'
    )
    """
)
```

Operational meaning:

1. rewrite fragmented data layout into healthier files
2. let retention policy remove obsolete historical metadata later

Important nuance:

Compaction is not the same thing as business deletion.

Business deletion changes logical visibility.

Compaction improves physical layout after those logical changes.

## 6. One End-To-End CDC Shape

This is the common production pattern:

1. ingest raw CDC into `glue_prod.stage.orders_cdc_raw`
2. normalize and deduplicate into `latest_orders_cdc`
3. `MERGE` into `glue_prod.analytics.orders_curated`
4. schedule periodic compaction
5. schedule snapshot expiration with explicit retention rules

That gives you separation between:

- messy source history
- curated current-state table
- maintenance lifecycle

## 7. When To Keep Two Tables Instead Of One

Often the best architecture is:

- one append-only event table
- one current-state curated table maintained by `MERGE`

Why this is often better than a single all-purpose table:

- event history stays auditable
- current-state serving stays simple for consumers
- CDC debugging becomes easier

## 8. Failure Modes To Watch

Common mistakes:

1. using `MERGE` where append-only history would be enough
2. skipping deduplication before `MERGE`
3. using mutable business keys
4. ignoring post-delete compaction for months
5. assuming every engine supports the same mutation semantics equally well

## 9. Fast Decision Matrix

```text
Need / Situation                           Preferred Pattern
----------------------------------------   -------------------------------------------------
Immutable event history                    Append-only table
Current-state table with late updates      Stage + deduplicate + MERGE
Delete tombstones by business key          DELETE or MERGE with delete branch on V2 table
Many logical deletes accumulated           Rewrite data files + retention procedures
Need both audit trail and current state    Two-table design: events + curated current state
```

## 10. Architect Rule

`MERGE` is not the default ingestion pattern.

It is a specific answer to a specific contract: a table whose consumers expect current-state semantics under late updates and deletes.