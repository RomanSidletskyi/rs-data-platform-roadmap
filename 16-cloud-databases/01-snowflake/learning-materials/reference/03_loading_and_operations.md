# Loading and Operations

Use fictional locations and names in examples. Real integrations require account-specific cloud IAM, network, and security review.

## File Format and Stage

```sql
CREATE FILE FORMAT landing.csv_format
  TYPE = CSV
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"';

CREATE STAGE landing.orders_stage
  URL = 's3://example-bucket/orders/'
  STORAGE_INTEGRATION = orders_storage_integration
  FILE_FORMAT = landing.csv_format;
```

An external stage points to external storage through an integration. An internal stage uses Snowflake-managed staging. Avoid embedding long-lived cloud secrets in scripts.

## Bulk Load

```sql
COPY INTO raw.orders
FROM @landing.orders_stage
PATTERN = '.*[.]csv'
ON_ERROR = 'ABORT_STATEMENT';
```

Choose error handling deliberately. Inspect load history and rejected records, and retain enough source data to replay safely. See [Data Loading Patterns](../deep-dives/03_data_loading_patterns.md).

```mermaid
flowchart LR
    BUCKET["Cloud object storage<br/>s3://example-bucket/orders/"] --> INTG["Storage integration<br/>cloud IAM trust, no secrets in SQL"]
    INTG --> STAGE["External stage<br/>landing.orders_stage"]
    FF["File format<br/>landing.csv_format"] --> STAGE
    ISTAGE["Internal stage<br/>Snowflake-managed files"] --> COPY
    STAGE --> COPY["COPY INTO raw.orders<br/>scheduled batch on a warehouse"]
    STAGE --> PIPE["Pipe<br/>wraps a COPY, runs on file arrival"]
    COPY --> RAW["raw.orders"]
    PIPE --> RAW
    COPY --> HIST["Load metadata and history<br/>rejected records"]
    PIPE --> HIST
```

Load metadata makes a rerun skip files already loaded, but a renamed or corrected file looks new. Business idempotency still needs stable record or batch keys downstream.

## Warehouse Basics

```sql
CREATE WAREHOUSE transform_wh
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;
```

Warehouse sizes, scaling, billing, and service behavior can change. Start small, use auto-suspend, and measure. A larger warehouse is not a substitute for diagnosing the query.

```mermaid
stateDiagram-v2
    [*] --> Suspended: created with INITIALLY_SUSPENDED
    Suspended --> Started: query arrives with AUTO_RESUME, or manual RESUME
    Started --> Started: queries run, billed per second
    Started --> Resizing: ALTER WAREHOUSE SET WAREHOUSE_SIZE
    Resizing --> Started: new queries use the new size
    Started --> Suspended: idle for AUTO_SUSPEND seconds, or manual SUSPEND
    Suspended --> [*]: DROP WAREHOUSE
```

Each resume bills a 60-second minimum, then per second. A very short auto-suspend with bursty queries can cost more than staying up a little longer, and every suspend also drops the warehouse's local data cache.

## Session Context and Diagnostics

```sql
SELECT
  CURRENT_ROLE(),
  CURRENT_WAREHOUSE(),
  CURRENT_DATABASE(),
  CURRENT_SCHEMA();
```

Use query history and Query Profile to distinguish queueing, scan volume, joins, spill, and execution time. Record query IDs when investigating an incident.

## Cost Guardrails

Use available resource monitors, budget controls, usage views, tags, and ownership conventions. A threshold without an owner and response procedure is not a complete cost-control system. Consult [Compute, Workloads, and Cost](../architecture/02_compute_workload_cost.md).

```mermaid
flowchart LR
    Q["Credit quota per interval<br/>illustrative: 100 credits per month"] --> U["Warehouse credits<br/>accumulate"]
    U --> T1{"50 percent"}
    T1 --> A1["NOTIFY<br/>owner reviews trend"]
    U --> T2{"90 percent"}
    T2 --> A2["SUSPEND<br/>running queries finish,<br/>no new queries"]
    U --> T3{"100 percent"}
    T3 --> A3["SUSPEND_IMMEDIATE<br/>running queries cancelled"]
    A1 --> RB["Runbook owner decides:<br/>fix job, raise quota, or accept"]
    A2 --> RB
    A3 --> RB
```

Thresholds are illustrative. Resource monitors cover warehouse credits only; serverless features need budgets or usage views, and a suspend action on a shared warehouse can stop production work along with the runaway job.

## Security Reminder

Do not commit passwords, tokens, private keys, account locators, or real data. Prefer managed identity and integrations supported by your account. Verify access under the role used by the actual workload, not only your administrator role.