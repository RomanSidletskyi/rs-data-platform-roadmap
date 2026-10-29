# Snapshot Versus CDC Ingestion Recipe

## Goal

Explain one of the most important ingestion design decisions on Iceberg:

- should the pipeline ingest periodic full snapshots of source state
- or ingest CDC events that describe row-level changes

These are not just two transport formats.

They create different table contracts, different write logic, and different failure modes.

## 1. The Difference In One Sentence

Snapshot ingestion says:

- here is the source state as of a point in time

CDC ingestion says:

- here are the row-level changes that happened over time

That difference changes almost everything downstream.

## 2. Snapshot Ingestion Mental Model

A snapshot feed usually contains a full extract or a partition-scoped current-state extract.

Typical examples:

- nightly export of all customers
- daily dump of current product catalog
- hourly extract of current open orders

What the feed does not necessarily tell you:

- which row was inserted
- which row was updated
- which row was deleted

It mostly tells you current visible state at extraction time.

## 3. CDC Ingestion Mental Model

A CDC feed usually contains change records such as:

- insert
- update
- delete

Typical examples:

- Debezium stream from OLTP database
- log-based replication feed
- change events from operational service bus

CDC tells you change intent over time, not only final state.

## 4. When Snapshot Ingestion Is A Good Fit

Use snapshot-based ingestion when:

- source system can reliably publish current-state extracts
- refresh frequency is acceptable
- exact row-level history is not needed from the source feed
- simplicity matters more than real-time mutation fidelity

Typical strong use cases:

- dimension refreshes
- slower-moving master data
- moderate-size current-state domains

## 5. When CDC Ingestion Is A Good Fit

Use CDC ingestion when:

- source emits meaningful row-level change events
- low-latency propagation matters
- delete semantics matter explicitly
- downstream current-state table must reflect inserts, updates, and deletes incrementally

Typical strong use cases:

- transactional order pipelines
- account balance or status changes
- operational domains where delete and update fidelity matters

## 6. Representative Snapshot Feed

Example shape:

```text
customer_id | customer_name | customer_tier | country_code | extracted_at
------------+---------------+---------------+--------------+-------------------
1001        | Alice         | gold          | DE           | 2026-03-27 01:00
1002        | Bob           | silver        | FR           | 2026-03-27 01:00
```

This feed does not tell you whether `customer_tier` changed from bronze to gold.

It only tells you what was true in the source snapshot.

## 7. Representative CDC Feed

Example shape:

```text
customer_id | op | customer_name | customer_tier | country_code | event_ts
------------+----+---------------+---------------+--------------+-------------------
1001        | U  | Alice         | gold          | DE           | 2026-03-27 00:13
1002        | D  | null          | null          | null         | 2026-03-27 00:24
1003        | I  | Carol         | bronze        | ES           | 2026-03-27 00:31
```

This feed explicitly says what kind of change happened.

## 8. Snapshot Ingestion Write Pattern

With snapshots, the typical question is:

- how do I replace or reconcile current visible state safely

Common write patterns:

- full table rebuild for small domains
- partition-scoped overwrite
- stage snapshot and derive delta versus current table

Representative partition-oriented overwrite:

```python
snapshot_df = spark.read.parquet("s3://landing/customers_snapshot/dt=2026-03-27/")

(
    snapshot_df
    .writeTo("glue_prod.analytics.dim_customer_current")
    .overwritePartitions()
)
```

This is a snapshot-driven refresh pattern, not CDC.

## 9. Snapshot Ingestion With Delta Derivation

Sometimes you still want to compare snapshot versus current Iceberg table before writing.

Representative pattern:

```python
current_df = spark.read.table("glue_prod.analytics.dim_customer_current")
snapshot_df = spark.read.parquet("s3://landing/customers_snapshot/dt=2026-03-27/")

changed_df = (
    snapshot_df.alias("source")
    .join(current_df.alias("target"), on="customer_id", how="left")
    .filter(
        "target.customer_id IS NULL OR "
        "source.customer_name <> target.customer_name OR "
        "source.customer_tier <> target.customer_tier OR "
        "source.country_code <> target.country_code"
    )
)
```

That still begins from snapshot logic:

- compare two states
- derive what must change

## 10. CDC Ingestion Write Pattern

With CDC, the typical question is:

- how do I apply inserts, updates, and deletes incrementally and correctly

Representative staging and deduplication:

```python
from pyspark.sql import Window
from pyspark.sql import functions as F


window_spec = Window.partitionBy("customer_id").orderBy(F.col("event_ts").desc())

latest_cdc_df = (
    spark.read.table("glue_prod.stage.customer_cdc")
    .withColumn("row_rank", F.row_number().over(window_spec))
    .filter("row_rank = 1")
    .drop("row_rank")
)

latest_cdc_df.createOrReplaceTempView("latest_customer_cdc")
```

Representative `MERGE`:

```sql
MERGE INTO glue_prod.analytics.dim_customer_current AS target
USING latest_customer_cdc AS source
ON target.customer_id = source.customer_id
WHEN MATCHED AND source.op = 'D' THEN DELETE
WHEN MATCHED AND source.op IN ('U', 'C') THEN UPDATE SET
  target.customer_name = source.customer_name,
  target.customer_tier = source.customer_tier,
  target.country_code = source.country_code,
  target.updated_at = source.event_ts
WHEN NOT MATCHED AND source.op IN ('I', 'U', 'C') THEN INSERT (
  customer_id,
  customer_name,
  customer_tier,
  country_code,
  updated_at
) VALUES (
  source.customer_id,
  source.customer_name,
  source.customer_tier,
  source.country_code,
  source.event_ts
);
```

That is a CDC-native pattern.

## 11. Deletions Are The Sharpest Boundary

This is the most important difference operationally.

With CDC:

- deletes are explicit events

With snapshots:

- a missing row may imply deletion, but only if the extraction contract guarantees full state completeness

That assumption is dangerous unless documented very clearly.

## 12. Snapshot Delete Risk

A common mistake is:

- treat row absence in a partial snapshot as a delete signal

That is only valid if the feed is guaranteed to be a complete authoritative snapshot for the key domain.

Otherwise, the pipeline can delete correct rows accidentally.

## 13. Latency And Complexity Tradeoff

Snapshot ingestion usually gives:

- simpler reasoning
- heavier batch movement
- weaker native mutation fidelity

CDC ingestion usually gives:

- better mutation fidelity
- lower propagation latency
- more complex deduplication and ordering logic

## 14. Snapshot Versus CDC In One Table

```text
Question / Need                         Snapshot Ingestion                       CDC Ingestion
------------------------------------    ---------------------------------------  -----------------------------------------------
What arrives from source                Current visible state                    Change records over time
Insert/update/delete meaning            Usually inferred                         Explicit in feed
Best write pattern                      Overwrite or state comparison            Stage + deduplicate + MERGE/DELETE
Delete handling                         Risky without full snapshot guarantee    Natural if delete events exist
Latency                                 Usually batch-oriented                   Lower-latency incremental
Operational complexity                  Lower                                    Higher
```

## 15. Recommended Architecture Pattern

Use snapshot ingestion for:

- dimensions and master data where current state matters more than change log fidelity

Use CDC ingestion for:

- transactional tables where row-level inserts, updates, and deletes must be preserved and applied incrementally

Sometimes the best design is both:

- CDC landing for fidelity and audit
- curated current-state Iceberg table derived from that CDC

## 16. Common Anti-Patterns

1. forcing CDC-style `MERGE` logic onto a simple nightly snapshot feed
2. inferring deletes from incomplete snapshots
3. using snapshot overwrite on a domain that requires precise incremental delete semantics
4. treating CDC as if ordering, duplicates, and replay do not matter

## 17. Where Iceberg Helps

Iceberg helps both ingestion models because it gives:

- atomic commits
- overwrite-friendly table operations
- mutation-aware `v2` semantics where needed
- time travel for debugging unexpected refresh behavior

But Iceberg does not tell you whether the upstream contract is a snapshot contract or a CDC contract.

You must model that boundary deliberately.

## 18. Architect Rule

If the source tells you state, design for state refresh.

If the source tells you changes, design for change application.