# 03 Merge CDC And Modeling Patterns Solution

## Task 1 - Choose Snapshot Ingestion Versus CDC Ingestion

Scenario A: snapshot-based ingestion.

- the feed is a full state picture
- load logic usually involves replacement, overwrite, or reconciliation by slice

Scenario B: CDC-based ingestion.

- the feed contains row-level changes and delete intent
- load logic usually needs staging, deduplication, and mutation-aware merge/delete handling

Danger: if you pretend a full snapshot is CDC, you may keep appending whole-table state repeatedly and create duplicates instead of controlled replacement.

## Task 2 - Design A Current-State Fact Upsert Flow

One strong flow:

1. ingest raw CDC into a landing table
2. standardize types and operation codes
3. deduplicate to the latest change per `order_id`
4. expose the deduplicated result as a temp view or staging table
5. `MERGE` into the curated `fct_orders` table
6. schedule compaction and snapshot-retention maintenance

Why this is fact upsert: the goal is one accepted current fact row per order, not a historical entity attribute timeline.

## Task 3 - Write A Merge For Late Corrections

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
WHEN MATCHED AND source.op = 'D' THEN DELETE
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

Key point: this table generally belongs on `v2` because row-level mutation semantics are part of the contract.

## Task 4 - Choose Fact Upsert Versus SCD Type 2

Scenario A: fact upsert.

- need the correct current order fact
- the grain is transactional
- history of descriptive attributes is not the main contract

Scenario B: SCD Type 2.

- need historical customer tier truth by date
- the grain is entity-state over time
- validity intervals are part of the model

## Task 5 - Design A Type 2 History Table

```sql
CREATE TABLE IF NOT EXISTS glue_prod.analytics.dim_customer_history (
  customer_sk BIGINT,
  customer_id BIGINT,
  customer_name STRING,
  customer_tier STRING,
  country_code STRING,
  valid_from_ts TIMESTAMP,
  valid_to_ts TIMESTAMP,
  is_current BOOLEAN,
  source_event_ts TIMESTAMP
)
USING iceberg
PARTITIONED BY (days(valid_from_ts))
TBLPROPERTIES (
  'format-version'='2'
);
```

Key point: multiple current rows for one business key break the semantic contract of the dimension.

## Task 6 - Plan Post-Delete Maintenance

One strong plan:

1. run `rewrite_data_files` to improve physical layout and reduce fragmented logical-delete overhead
2. run `expire_snapshots` with explicit retention rules after confirming the history window you still need

Why separate concerns: business deletion changes row visibility, while maintenance improves storage layout and controls metadata growth.