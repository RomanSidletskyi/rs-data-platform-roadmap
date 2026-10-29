# Incremental Processing: Streams, Tasks, Dynamic Tables, and External Orchestration

## The Problem

Incremental processing avoids rebuilding all target data for every run. A correct design must define source change semantics, stable keys, transaction boundaries, deletes, late records, retries, freshness, and recovery. The Snowflake feature choice comes after those semantics.

## Streams and Tasks: Explicit Processing

A stream exposes change information for supported objects. A task schedules SQL or procedure execution and can be linked into a task graph. This is useful when engineers need explicit transformation steps, branching, custom SQL, or platform-native scheduling.

```sql
CREATE STREAM raw.orders_changes ON TABLE raw.orders;

CREATE TASK apply_order_changes
  WAREHOUSE = transform_wh
  SCHEDULE = '5 MINUTE'
AS
  MERGE INTO curated.orders AS target
  USING (
    SELECT order_id, status, changed_at
    FROM raw.orders_changes
    QUALIFY ROW_NUMBER() OVER (
      PARTITION BY order_id ORDER BY changed_at DESC
    ) = 1
  ) AS source
  ON target.order_id = source.order_id
  WHEN MATCHED THEN UPDATE SET
    target.status = source.status,
    target.changed_at = source.changed_at
  WHEN NOT MATCHED THEN INSERT (order_id, status, changed_at)
    VALUES (source.order_id, source.status, source.changed_at);
```

This example is illustrative. Production logic must handle deletes, duplicate ordering, null keys, source transaction behavior, late updates, task failure, and ownership. A transaction that consumes a stream advances its change position; design target writes and consumption so retries do not lose or duplicate intended changes.

## Dynamic Tables: Declarative Refresh

Dynamic tables let a developer define a query result and a freshness objective while Snowflake manages refresh behavior for supported query patterns. This can reduce custom scheduling and incremental SQL. It does not remove the need to inspect refresh history, lag, query support, cost, and lineage.

Choose a dynamic table when the transformation fits supported declarative semantics and the freshness target is more important than controlling every procedural step. Validate behavior under source changes and realistic volume before relying on it.

## dbt and Airflow Boundaries

dbt is useful for versioned warehouse transformations, model dependencies, tests, documentation, and environment-aware deployment. Airflow or another orchestrator is useful when one workflow spans Snowflake and external systems, with cross-system dependencies, sensors, retries, or operational ownership. Snowflake tasks can complement these tools; avoid making two systems independently own the same schedule and retry semantics.

## Comparison

| Option | Prefer when | Watch for |
| --- | --- | --- |
| Streams and tasks | Explicit incremental steps and Snowflake-native scheduling fit the problem | Stream consumption, transaction semantics, task graph observability, external dependencies |
| Dynamic tables | Declarative SQL and target freshness are the primary contract | Supported query patterns, refresh mode, lag, and opaque operational assumptions |
| dbt | Transformation project needs code review, tests, lineage, docs, and deployment workflow | Scheduling and source ingestion may belong elsewhere |
| Airflow/external orchestrator | Workflow crosses systems or needs centralized orchestration controls | Extra infrastructure and ownership; avoid redundant retries and schedules |
| Full rebuild | Data volume and SLA make rebuilding simple and affordable | Runtime and cost may grow; rebuild must remain deterministic |

## Correctness Questions

- What uniquely identifies a logical record or change?
- Are source rows events, snapshots, or mutable records?
- How are deletes and corrections represented?
- What happens if a task fails after partially writing?
- Can a batch be replayed without changing the final answer?
- How are late records reflected in freshness and downstream consumers?

## Decision Checklist

Choose the simplest design that meets correctness, freshness, and recovery needs. Record why a native feature is preferable to a full rebuild or external orchestration, then define observability and a failure/replay exercise.