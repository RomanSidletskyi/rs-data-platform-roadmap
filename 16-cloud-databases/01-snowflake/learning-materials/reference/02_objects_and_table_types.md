# Objects and Table Types

## Common Object Path

```text
database.schema.object
```

```sql
CREATE DATABASE ANALYTICS;
CREATE SCHEMA ANALYTICS.RAW;
CREATE TABLE ANALYTICS.RAW.ORDERS (
  order_id NUMBER,
  order_ts TIMESTAMP_NTZ,
  payload VARIANT
);
```

Use fully qualified names in deployment code when session context could resolve to the wrong environment. Names organize objects; grants and policies enforce access.

```mermaid
flowchart TD
    ORG["Organization"] --> ACC["Account"]
    ACC --> WH["Warehouses<br/>account-level compute"]
    ACC --> ID["Users and roles<br/>account-level identity"]
    ACC --> AO["Integrations and<br/>resource monitors"]
    ACC --> DB["Database"]
    DB --> SCH["Schema"]
    SCH --> T["Tables"]
    SCH --> V["Views"]
    SCH --> OPS["Stages, file formats,<br/>streams, tasks, pipes"]
    ID -. "grants control access" .-> SCH
    WH -. "executes queries on" .-> T
```

Warehouses and roles sit beside databases, not inside them: moving a table to another database does not change which compute or role hierarchy is used, and dropping a warehouse never drops data.

## Permanent, Transient, and Temporary

| Type | Typical use | Lifecycle and recovery note |
| --- | --- | --- |
| Permanent | Durable business or curated data | Standard durable table behavior; eligible Time Travel and provider recovery characteristics depend on configuration and edition |
| Transient | Re-creatable intermediate or staging data that does not need Fail-safe | Reduced recovery guarantees; keep only when upstream data and rebuild procedures are trustworthy |
| Temporary | Session-scoped scratch data | Automatically removed with the session; unsuitable as a durable pipeline handoff |

```sql
CREATE TABLE curated.customer_daily (...);
CREATE TRANSIENT TABLE work.customer_merge_stage (...);
CREATE TEMPORARY TABLE session_debug_rows (...);
```

Choose by data value, rebuildability, access, and recovery objective, not by table size alone. Retention and recovery details are edition- and configuration-sensitive; verify the current table-type documentation.

```mermaid
flowchart TD
    Q1{"Needed after the<br/>session ends?"} -- No --> TEMP["TEMPORARY<br/>Time Travel 0-1 day, within the session<br/>no Fail-safe<br/>purged when the session ends"]
    Q1 -- Yes --> Q2{"Cheap and proven to rebuild<br/>from retained source?"}
    Q2 -- Yes --> TRAN["TRANSIENT<br/>Time Travel 0-1 day<br/>no Fail-safe"]
    Q2 -- "No, or business-critical" --> PERM["PERMANENT<br/>Time Travel 0-1 day on Standard<br/>up to 90 days on Enterprise and above"]
    PERM --> FS["Plus 7-day Fail-safe<br/>Snowflake-operated recovery<br/>not customer-accessible"]
```

The trade-off is storage cost versus recovery: Time Travel and Fail-safe keep changed micro-partitions billable, so a high-churn staging table is often transient, while the curated table it feeds stays permanent.

## Views

```sql
CREATE VIEW analytics.reporting.active_customers AS
SELECT customer_id, region
FROM analytics.curated.dim_customer
WHERE is_active;
```

A view stores a query definition rather than an independently maintained result set. A secure view has additional protections for governed sharing and information exposure; it is not automatically a complete security boundary. See [Secure Views](../deep-dives/02_secure_views.md) before using one for sensitive data.

```mermaid
flowchart TD
    S["Need a reusable query result"] --> Q1{"Is computing at<br/>read time acceptable?"}
    Q1 -- Yes --> Q2{"Consumers must not see the<br/>definition or underlying data<br/>through optimizer behavior?"}
    Q2 -- No --> VIEW["View<br/>stored query only"]
    Q2 -- Yes --> SVIEW["Secure view<br/>hides definition, limits<br/>exposing optimizations"]
    Q1 -- "No, precompute" --> Q3{"Single table, eligible query,<br/>results must always be current?"}
    Q3 -- Yes --> MV["Materialized view<br/>Snowflake-maintained<br/>Enterprise feature"]
    Q3 -- "No, joins or a pipeline<br/>with a freshness target" --> DT["Dynamic table<br/>query plus target lag"]
```

Moving down the tree trades read latency for background maintenance credits and storage. A secure view can also run slower than a plain view because some optimizations are disabled.

## Cloning Reminder

```sql
CREATE TABLE dev.customer_copy
  CLONE prod.curated.customer;
```

Cloning is efficient for many development and validation scenarios, but grants, sensitive values, retention, and cleanup still need explicit design. See [Recovery Reference](04_processing_and_recovery.md) and [Availability Architecture](../architecture/05_availability_and_recovery.md).