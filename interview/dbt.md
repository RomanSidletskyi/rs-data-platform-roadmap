# dbt Incremental + Vars + Multi-Source Architecture

## 📌 Problem Description

We have a pipeline with the following requirements:

- Incremental data loading
- Support for:
  - automated daily runs
  - manual backfills via `vars`
  - full reload
- 8 different `brand_id`
  - each has its own `source`
  - each has its own destination table
  - but identical transformation logic
- Need to check source readiness (task / pipeline)

---

# 🧠 Architecture Overview

## Core Principles

- Move SQL logic into **macros**
- One **model per brand**
- Define raw tables via `sources.yml`
- Control execution via:
  - `vars`
  - `is_incremental()`
  - date window macro
- Build DAG using:
  - `source()` for raw layer
  - `ref()` for model dependencies

---

# 🔁 Load Logic Priority

1. `start_date` + `end_date` → manual backfill  
2. `full_reload=true` → full reload (no filter)  
3. incremental:
   - before 10:00 → yesterday + today  
   - after 10:00 → yesterday only  
4. `--full-refresh` → full rebuild  

---

# 📅 Date Window Macro

```sql
{% macro get_reload_window(tz_name='Europe/Kyiv') %}
    {% set pytz = modules.pytz %}
    {% set datetime = modules.datetime %}
    {% set tz = pytz.timezone(tz_name) %}
    {% set now_local = run_started_at.astimezone(tz) %}

    {% set today = now_local.date() %}
    {% set yesterday = today - datetime.timedelta(days=1) %}
    {% set tomorrow = today + datetime.timedelta(days=1) %}

    {% if now_local.hour < 10 %}
        {{ return({
            "start_date": yesterday.isoformat(),
            "end_date": tomorrow.isoformat()
        }) }}
    {% else %}
        {{ return({
            "start_date": yesterday.isoformat(),
            "end_date": today.isoformat()
        }) }}
    {% endif %}
{% endmacro %}
```

---

# 🧩 Reusable Select Macro

```sql
{% macro brand_orders_select(source_name, table_name, brand_id) %}

    {% set start_date = var('start_date', none) %}
    {% set end_date   = var('end_date', none) %}
    {% set full_reload = var('full_reload', false) %}

    {% if start_date and end_date %}
        {% set window = {"start_date": start_date, "end_date": end_date} %}
    {% elif full_reload %}
        {% set window = none %}
    {% elif is_incremental() %}
        {% set window = get_reload_window() %}
    {% else %}
        {% set window = none %}
    {% endif %}

    select
        id,
        order_id,
        order_dt,
        amount,
        {{ brand_id }} as brand_id
    from {{ source(source_name, table_name) }}
    where 1=1

    {% if window %}
        and order_dt >= '{{ window["start_date"] }}'
        and order_dt < '{{ window["end_date"] }}'
    {% endif %}

{% endmacro %}
```

---

# 🏗️ Staging → Mart Example using ref()

## Staging model

```sql
-- models/staging/stg_orders_brand_1.sql

select
    id,
    order_id,
    order_dt,
    amount
from {{ source('raw_brand_1', 'orders_brand_1') }}
```

---

## Mart model

```sql
-- models/marts/fct_orders_brand_1.sql

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

---

## DAG Structure

```
source.raw_brand_1.orders_brand_1
        ↓
stg_orders_brand_1
        ↓
fct_orders_brand_1
```

---

# 🔗 How ref() Works

## ✅ Key Rule

```sql
{{ ref('stg_orders_brand_1') }}
```

The argument `'stg_orders_brand_1'` refers to:

👉 the **model name**, which by default equals the **SQL file name**

---

## ✅ Example

File:
```
models/staging/stg_orders_brand_1.sql
```

Usage:
```sql
{{ ref('stg_orders_brand_1') }}
```

---

## ⚠️ Important: alias does NOT affect ref()

```sql
{{ config(alias='orders_clean') }}
```

- Database table name → `orders_clean`
- ref still uses:

```sql
{{ ref('stg_orders_brand_1') }}
```

---

## ❌ YAML does NOT define ref()

```yaml
models:
  - name: stg_orders_brand_1
```

This is only for:
- documentation
- tests
- metadata

NOT for `ref()`

---

## ⚠️ Edge Case: custom name

```sql
{{ config(name='custom_model_name') }}
```

Then:

```sql
{{ ref('custom_model_name') }}
```

⚠️ Not recommended (can confuse DAG)

---

## 📊 Summary

| Component        | Affects ref() |
|-----------------|--------------|
| SQL file name    | ✅ Yes |
| alias            | ❌ No |
| schema.yml       | ❌ No |
| config(name=...) | ✅ Yes |

---

# 🪞 this in dbt

```sql
select max(order_dt)
from {{ this }}
```

- refers to current model
- does NOT create DAG dependency
- used for incremental logic

---

# 📦 sources.yml

```yaml
version: 2

sources:
  - name: raw_brand_1
    schema: raw
    tables:
      - name: orders_brand_1
```

---

# ▶️ Run Commands

```bash
dbt run --select fct_orders_brand_1
dbt run --select +fct_orders_brand_1+
dbt run --vars '{start_date: "2024-01-01", end_date: "2024-01-10"}'
dbt run --vars '{full_reload: true}'
dbt run --full-refresh
```

---

# ⏱️ Source Readiness

Options:

- `dbt source freshness`
- `TASK_HISTORY`
- `pre_hook`
- control table

---

# 📚 dbt docs

```bash
dbt docs generate
dbt docs serve
```

Docs include:

- DAG
- lineage via `ref()` and `source()`
- metadata
- descriptions

---

# 🧠 Best Practices

## ✅ Do

- use `source()` for raw  
- use `ref()` between models  
- use staging → mart layers  
- use macros for logic  
- use `this` for incremental  

## ❌ Don't

- hardcode table names  
- skip `ref()`  
- duplicate SQL  
- mix orchestration with transformation  

---

# 🏁 Final Architecture

- source → staging → marts  
- `source()` → raw  
- `ref()` → dependencies  
- `this` → incremental logic  

This ensures:

- correct DAG  
- clean lineage  
- scalable architecture  
- maintainable transformations  
*** Add File: /Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/interview/dbt_interview.md
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