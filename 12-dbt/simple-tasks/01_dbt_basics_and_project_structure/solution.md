# Solution

## Task 1 — Where dbt fits in the platform

dbt should be placed after ingestion and before BI consumption.

Typical flow:

    source systems / Kafka / APIs
        ↓
    ingestion layer
        ↓
    Snowflake RAW tables
        ↓
    dbt staging
        ↓
    dbt intermediate
        ↓
    dbt marts
        ↓
    BI / analytics / reverse ETL

Why this is the right boundary:

- dbt does not ingest data from Kafka, APIs, or SaaS tools directly
- dbt assumes data already exists in the warehouse or lakehouse SQL engine
- dbt is responsible for transformation, testing, documentation, and lineage in the analytical layer
- orchestration tools like Airflow decide when dbt runs, but dbt defines what transformations exist

Short architectural rule:

- ingestion moves data into RAW
- dbt turns RAW into trusted analytical datasets
- BI tools consume marts, not raw landing tables

## Task 2 — Minimal production-style dbt project structure

Example structure:

```text
dbt_warehouse/
  dbt_project.yml
  packages.yml
  selectors.yml
  README.md
  macros/
    generate_schema_name.sql
    safe_cast.sql
  models/
    sources/
      raw_sources.yml
    staging/
      orders/
        stg_orders.sql
        stg_orders.yml
      customers/
        stg_customers.sql
        stg_customers.yml
    intermediate/
      int_orders_enriched.sql
      intermediate.yml
    marts/
      dimensions/
        dim_customer.sql
        dim_customer.yml
      facts/
        fct_orders.sql
        fct_orders.yml
  snapshots/
  seeds/
  tests/
    assert_no_negative_amounts.sql
  analyses/
  target/
  logs/
```

Why each area exists:

- `models/` contains the warehouse transformation graph
- `sources/` keeps source definitions close to raw system contracts
- `staging/` standardizes raw data into clean typed relations
- `intermediate/` holds reusable business transformations and dedup logic
- `marts/` contains curated dimensions and facts for analytics consumers
- `macros/` stores reusable SQL generation logic
- `tests/` stores singular tests for custom business rules
- `selectors.yml` allows operational grouping such as daily vs frequent jobs

## Task 3 — `ref()` vs `source()`

Practical explanation:

- `source()` points to data that exists outside dbt model creation, usually raw ingestion tables
- `ref()` points to another dbt model and creates a dependency inside the dbt graph

Example:

```sql
select *
from {{ source('raw', 'orders') }}
```

Use `source()` when:

- reading RAW Snowflake tables
- referencing ingestion outputs
- attaching freshness checks and source metadata

Example:

```sql
select *
from {{ ref('stg_orders') }}
```

Use `ref()` when:

- building one dbt model from another dbt model
- you want lineage in docs and DAG
- you want dbt to resolve the final database, schema, and object name automatically

Why it matters:

- if you hardcode table names, dbt loses lineage awareness
- if you use `ref()`, dbt knows build order and can visualize dependencies
- if you use `source()`, dbt can run freshness and source-level tests

## Task 4 — Why layers matter

Recommended layering:

- staging: clean typing, renaming, lightweight normalization
- intermediate: joins, deduplication, reusable business logic
- marts: final dimensional and fact datasets for downstream consumption

Why not skip straight from raw to marts:

- raw tables often contain ingestion-specific fields and inconsistent types
- putting all logic in one mart makes debugging and testing harder
- shared logic becomes duplicated across marts
- late fixes become risky because there is no stable reusable middle layer

Short rule of thumb:

- staging creates consistent inputs
- intermediate creates reusable business-ready building blocks
- marts create consumer-facing outputs
