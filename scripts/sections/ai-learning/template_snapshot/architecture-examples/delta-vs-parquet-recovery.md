# Delta Versus Raw Parquet For Recovery

## Scenario

A learning-oriented data platform needs reliable replay, schema management, and easier operational recovery.

The team is Spark-first today but wants to avoid creating fragile manual recovery logic.

## Core Tension

Is raw Parquet with custom conventions enough, or does the table layer need transactional and metadata-aware behavior?

## Trade-Offs

- raw Parquet is simple at the file level, but pushes more recovery and consistency burden into custom logic
- Delta Lake adds conventions and platform expectations, but improves replay confidence and state management
- the right choice depends on whether operational trust matters more than minimalism

## Failure Modes

- partial writes leaving ambiguous table state
- manual replay rules diverging across pipelines
- schema changes handled inconsistently between teams

## Code-Backed Discussion Point

```sql
MERGE INTO curated.customer_orders AS target
USING staging.customer_orders AS source
ON target.order_id = source.order_id
WHEN MATCHED THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *
```

The query looks clean.

The architecture question is whether the surrounding storage model makes merge, replay, and recovery operationally trustworthy.

## Decision Signal

Choose the richer table layer when recovery confidence and data contract stability matter repeatedly, not just once.

## Review Questions

- what recovery tasks stay manual with raw Parquet
- what operational guarantees are gained from a richer table layer
- when does table-format complexity become unjustified
- how would this decision change if multi-engine support became urgent

## AI Prompt Pack

```text
Compare raw Parquet plus custom recovery conventions against Delta Lake for a Spark-first training platform. Focus on replay confidence, schema handling, downstream contract stability, and operational burden.
```

```text
Challenge this storage-layer decision. What assumptions about recovery, merge safety, and downstream trust are still unproven?
```