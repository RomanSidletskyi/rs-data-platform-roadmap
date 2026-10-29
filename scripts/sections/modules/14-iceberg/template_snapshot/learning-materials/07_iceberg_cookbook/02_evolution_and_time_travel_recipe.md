# Evolution And Time Travel Recipe

## Goal

Understand a simple change flow without losing the table mental model.

This recipe should teach two things at once:

- how the table evolves
- how snapshots become the real unit of historical truth

## Example Schema Evolution

```sql
ALTER TABLE demo.sales.orders ADD COLUMN sales_channel STRING;
```

Representative follow-up insert:

```sql
INSERT INTO demo.sales.orders VALUES
  (3, 'c_103', TIMESTAMP '2026-03-02 09:30:00', DATE '2026-03-02', 75.25, 'paid', 'web');
```

## Example Data Change

```sql
UPDATE demo.sales.orders
SET sales_channel = 'store'
WHERE order_id = 2;
```

Architect note:

- whether this update is really supported depends on engine behavior and table mutation semantics
- this is one of the places where `v1` versus `v2` matters operationally

## Example Time Travel Thinking

The exact syntax depends on engine and platform, but the conceptual flow is:

1. identify an older snapshot
2. query or restore relative to that snapshot
3. confirm whether you need read-only investigation or operational rollback

Representative Spark-style read by snapshot:

```python
historical_df = (
  spark.read
  .option("snapshot-id", 918273645546372819)
  .table("demo.sales.orders")
)
```

Representative Spark-style read by timestamp:

```python
historical_df = (
  spark.read
  .option("as-of-timestamp", 1774579200000)
  .table("demo.sales.orders")
)
```

## What Actually Changes In Metadata

When schema or rows change, Iceberg writes a new metadata root describing:

- the current schema state
- the new snapshot
- the manifest list for that snapshot

So evolution is always also metadata evolution.

## Schema Evolution Checklist

1. Is the change additive or contract-breaking?
2. Do all critical readers understand the change?
3. Does the change require backfill?
4. Are field identities preserved correctly?

## Time Travel Checklist

1. Do I need only to inspect old state or restore it?
2. Which snapshot or timestamp is the target?
3. Are the required snapshots still retained?
4. Is a branch or tag already preserving that state?

## What This Recipe Teaches

- schema change should be an explicit table operation
- history exists because snapshots are versioned metadata states
- rollback reasoning must be operationally intentional, not improvised