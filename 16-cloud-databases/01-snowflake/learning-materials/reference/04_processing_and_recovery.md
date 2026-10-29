# Processing and Recovery

## `MERGE`

```sql
MERGE INTO curated.customer AS target
USING stage.customer_changes AS source
  ON target.customer_id = source.customer_id
WHEN MATCHED THEN UPDATE SET target.email = source.email
WHEN NOT MATCHED THEN INSERT (customer_id, email)
  VALUES (source.customer_id, source.email);
```

Deduplicate the source to one intended row per key before merging. Define delete, late-arriving update, and replay behavior explicitly.

## Streams and Tasks

```sql
CREATE STREAM raw.orders_stream ON TABLE raw.orders;

CREATE TASK transform_orders
  WAREHOUSE = transform_wh
  SCHEDULE = '5 MINUTE'
AS
  INSERT INTO curated.orders
  SELECT * FROM raw.orders_stream;
```

A stream exposes change information for supported objects. A task schedules SQL or procedure execution. Validate task ownership, privileges, failure handling, and stream consumption behavior. A committed transaction that consumes a stream advances its offset; design the target write and stream consumption atomically where possible.

## Dynamic Tables

Dynamic tables express a target query and freshness objective; Snowflake manages refresh behavior for supported queries. They differ from streams and tasks, where the developer wires explicit incremental steps. Inspect supported SQL, lag, refresh history, and cost for the actual workload.

## Time Travel

```sql
SELECT *
FROM curated.orders AT (OFFSET => -60 * 5);
```

This example queries a historical point. Retention, object eligibility, and syntax depend on current product behavior and configuration.

## Cloning and Undrop

```sql
CREATE TABLE dev.orders_test CLONE prod.curated.orders;
UNDROP TABLE prod.curated.orders;
```

Use recovery commands only after confirming the target object and impact. Test recovery procedures in a disposable environment. Fail-safe is not a customer-operated backup or general-purpose historical query interface.

See [Incremental Processing](../deep-dives/04_incremental_processing.md) and [Availability and Recovery](../architecture/05_availability_and_recovery.md) for design guidance.