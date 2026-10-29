# dbt Interview Cheat Sheet

## What dbt is

dbt is a transformation framework that lets analytics engineers build SQL models as code.

Its core value is:

- dependency management through `ref()`
- reusable logic through macros
- tests and documentation close to the models
- environment-aware builds through configs and vars

## Key Interview Questions And Answers

### 1. What problem does dbt solve?

dbt solves the problem of managing SQL transformations as a real software project.

Instead of writing disconnected SQL scripts, it gives you:

- modular models
- lineage and DAG resolution
- testing
- documentation
- environment-aware deployment

### 2. What is the difference between `source()` and `ref()`?

`source()` is for raw or externally managed tables.

`ref()` is for dbt-managed dependencies between models.

Strong short answer:

- `source()` points to upstream raw data
- `ref()` points to another dbt model and creates a DAG dependency

### 3. What does `ref()` actually use?

By default, `ref()` uses the model name, which usually matches the SQL file name.

`alias` changes the database object name, but not the `ref()` target.

### 4. What does `this` mean in dbt?

`this` refers to the current model relation being built.

It is often used in incremental logic, for example to read the current max loaded timestamp.

### 5. What is an incremental model?

An incremental model loads only new or changed data instead of rebuilding the full dataset on every run.

The point is to reduce runtime and warehouse cost for large tables.

### 6. What is the difference between incremental logic and `--full-refresh`?

Incremental logic applies only the delta.

`--full-refresh` forces a full rebuild of the table.

Good interview phrasing:

- incremental is the normal operating path
- full refresh is the recovery or rebuild path

### 7. When is dbt a good fit and when is it not?

dbt is a strong fit for:

- warehouse transformations
- staging, intermediate, and mart layers
- analytics contracts and testing

dbt is a weaker fit for:

- heavy orchestration logic
- event streaming control
- long-running non-SQL operational workflows

### 8. What are dbt macros used for?

Macros are reusable Jinja-based logic blocks.

They are useful for:

- repeated SQL patterns
- date window logic
- cross-database abstraction
- reusable business filters

### 9. How do you handle multi-source architecture with similar logic?

A strong pattern is:

- keep one source definition per raw dataset
- keep one model per output contract
- move repeated transformation logic into macros

That avoids copy-paste SQL across brands or regions.

### 10. How do you check source readiness before dbt models run?

Common options are:

- `dbt source freshness`
- orchestration-level checks in Airflow
- control tables or ingestion audit tables
- pre-run warehouse checks

Best answer in interviews:

- dbt should validate transformation assumptions
- orchestration should validate operational readiness

## Practical Examples

### Minimal `sources.yml`

```yaml
version: 2

sources:
  - name: raw_brand_1
    schema: raw
    tables:
      - name: orders_brand_1
```

### Staging model

```sql
select
    id,
    order_id,
    order_dt,
    amount
from {{ source('raw_brand_1', 'orders_brand_1') }}
```

### Mart model with `ref()`

```sql
{{ config(
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key='order_id'
) }}

select
    order_id,
    order_dt,
    amount
from {{ ref('stg_orders_brand_1') }}
```

### Incremental filter using `this`

```sql
{% if is_incremental() %}
where order_dt > (
    select coalesce(max(order_dt), '1900-01-01')
    from {{ this }}
)
{% endif %}
```

### Reusable macro for multi-brand logic

```sql
{% macro brand_orders_select(source_name, table_name, brand_id) %}
select
    id,
    order_id,
    order_dt,
    amount,
    {{ brand_id }} as brand_id
from {{ source(source_name, table_name) }}
{% endmacro %}
```

## Useful Run Commands

```bash
dbt run --select fct_orders_brand_1
dbt run --select +fct_orders_brand_1+
dbt run --vars '{start_date: "2024-01-01", end_date: "2024-01-10"}'
dbt run --vars '{full_reload: true}'
dbt run --full-refresh
dbt test --select fct_orders_brand_1
dbt source freshness
dbt docs generate
dbt docs serve
```

## Good Interview Phrases

- "I use `source()` for raw ingestion boundaries and `ref()` for dbt-managed lineage."
- "dbt is strongest at transformation and testing, while orchestration should stay in Airflow."
- "For repeated brand logic, I prefer macros plus one model per output contract."
- "Incremental models reduce cost, but I always keep a safe full-refresh path."

## Common Mistakes To Avoid In Answers

- saying dbt is an orchestrator
- mixing `alias` and `ref()` semantics
- describing `this` as a dependency builder
- treating macros as a substitute for clean model design

## Quick Summary

If the interviewer pushes for architecture, the strongest short answer is:

dbt is the transformation layer. It should own SQL model logic, lineage, tests, and documentation. Airflow should own scheduling and runtime orchestration. Raw inputs should come through `source()`, internal dependencies should go through `ref()`, and incremental models should always have a clear rebuild strategy.