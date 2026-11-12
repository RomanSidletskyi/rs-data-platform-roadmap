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

```mermaid
flowchart TD
    SRC["stage.customer_changes"] --> DEDUP["Deduplicate source<br/>one row per customer_id"]
    DEDUP --> KEY{"ON target.customer_id<br/>= source.customer_id"}
    KEY -- Matched --> UPD["WHEN MATCHED<br/>UPDATE email"]
    KEY -- "Not matched" --> INS["WHEN NOT MATCHED<br/>INSERT new customer"]
    UPD --> TGT["curated.customer"]
    INS --> TGT
    DUP["Skipped dedup: several source<br/>rows match one target row"] -.-> ERR["Nondeterministic update<br/>fails by default"]
```

Rerunning the same deduplicated source produces the same target state, which is what makes the `MERGE` safe to retry.

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

```mermaid
sequenceDiagram
    participant L as Loader
    participant R as RawOrders
    participant S as OrdersStream
    participant T as TransformTask
    participant C as CuratedOrders
    L->>R: INSERT new rows
    R-->>S: changes since the stream offset become visible
    T->>S: scheduled run checks for changes
    alt no changes
        T-->>T: skip run, for example WHEN SYSTEM$STREAM_HAS_DATA
    else changes present
        T->>C: INSERT SELECT FROM the stream inside one transaction
        T->>S: COMMIT advances the offset
    end
    Note over T,S: Failure before COMMIT leaves the offset unchanged, so the retry sees the same changes
```

The failure path is the design point: if the target write and the offset advance are in different transactions, a retry can skip or duplicate rows.

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

A zero-copy clone shares micro-partitions with its source until either side changes data:

```mermaid
flowchart LR
    subgraph T0["At clone time: metadata only"]
        PROD0["prod.curated.orders"] --> MP["Micro-partitions<br/>P1 P2 P3"]
        DEV0["dev.orders_test"] --> MP
    end
    subgraph T1["After an UPDATE on the clone touches P3"]
        PROD1["prod.curated.orders"] --> SH["Shared P1 P2"]
        PROD1 --> P3["Original P3"]
        DEV1["dev.orders_test"] --> SH
        DEV1 --> P3N["New P3 version<br/>new storage billed"]
    end
```

Storage grows only for partitions that diverge. Dropping the source does not free partitions a clone still references, and grants on a cloned table should be checked explicitly rather than assumed.

Use recovery commands only after confirming the target object and impact. Test recovery procedures in a disposable environment. Fail-safe is not a customer-operated backup or general-purpose historical query interface.

```mermaid
flowchart TD
    INC["Data incident"] --> Q1{"Object dropped?"}
    Q1 -- Yes --> Q2{"Within Time Travel<br/>retention?"}
    Q2 -- Yes --> UNDROP["UNDROP<br/>fails if the name is reused,<br/>rename the new object first"]
    Q1 -- "No, bad update or delete" --> Q3{"Within Time Travel<br/>retention?"}
    Q3 -- Yes --> CLONE["CLONE with AT or BEFORE<br/>into a side table, validate,<br/>then swap or repair"]
    Q2 -- No --> FS{"Permanent table within<br/>7-day Fail-safe?"}
    Q3 -- No --> FS
    FS -- Yes --> SUP["Snowflake Support recovery<br/>best effort, not self-service"]
    FS -- No --> REPLAY["Replay from retained<br/>raw or source data"]
```

Restore into a side object and validate before touching production; the fastest command is not always the safest recovery. Source replay remains the fallback when retention windows have passed.

See [Incremental Processing](../deep-dives/04_incremental_processing.md) and [Availability and Recovery](../architecture/05_availability_and_recovery.md) for design guidance.