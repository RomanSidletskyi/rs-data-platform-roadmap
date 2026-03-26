# Solution

## Task 1 — Full `profiles.yml`

```yaml
analytics_platform:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: my_account.eu-central-1
      user: ivan
      password: "{{ env_var('DBT_DEV_PASSWORD') }}"
      role: TRANSFORMER_DEV
      database: ANALYTICS_DEV
      warehouse: DBT_DEV_WH
      schema: dbt_ivan
      threads: 4
      query_tag: dbt_dev

    qa:
      type: snowflake
      account: my_account.eu-central-1
      user: dbt_ci_user
      password: "{{ env_var('DBT_QA_PASSWORD') }}"
      role: TRANSFORMER_QA
      database: ANALYTICS_QA
      warehouse: DBT_QA_WH
      schema: dbt_ci
      threads: 8
      query_tag: dbt_qa

    prod:
      type: snowflake
      account: my_account.eu-central-1
      user: dbt_prod_service
      password: "{{ env_var('DBT_PROD_PASSWORD') }}"
      role: TRANSFORMER_PROD
      database: ANALYTICS_PROD
      warehouse: DBT_PROD_WH
      schema: analytics
      threads: 8
      query_tag: dbt_prod
```

Why prod should use a service account:

- production jobs should not depend on a developer leaving or changing passwords
- access should be auditable and least-privilege
- operational ownership is cleaner when credentials belong to the platform, not a person

## Task 2 — Detailed `dbt_project.yml`

```yaml
name: analytics_platform
version: 1.0.0
config-version: 2

profile: analytics_platform

model-paths: ['models']
macro-paths: ['macros']
test-paths: ['tests']
seed-paths: ['seeds']
analysis-paths: ['analyses']
snapshot-paths: ['snapshots']

target-path: target
clean-targets:
  - target
  - dbt_packages
  - logs

models:
  analytics_platform:
    staging:
      +schema: staging
      +materialized: view
      +snowflake_warehouse: DBT_SMALL_WH

    intermediate:
      +schema: intermediate
      +materialized: view
      +snowflake_warehouse: DBT_MEDIUM_WH

    marts:
      dimensions:
        +schema: marts
        +materialized: table
        +snowflake_warehouse: DBT_SMALL_WH
        +tags: ['daily']

      facts:
        +schema: marts
        +materialized: incremental
        +snowflake_warehouse: DBT_LARGE_WH
        +tags: ['frequent']
        +on_schema_change: sync_all_columns
```

Config precedence summary:

- `config()` inside a model is the most specific override
- folder-level settings in `dbt_project.yml` are the standard project-wide default mechanism
- broader project settings apply unless a more specific config overrides them

## Task 3 — Route domains to different databases

Example folder-based config:

```yaml
models:
  analytics_platform:
    marts:
      crm:
        +database: CRM_MART_DB
        +schema: marts
      finance:
        +database: FINANCE_MART_DB
        +schema: marts
      sales:
        +database: SALES_MART_DB
        +schema: marts
```

Why this is easier than hardcoding databases in every model:

- routing stays centralized in one configuration layer
- domain moves become easier because the SQL itself does not change
- reviews are cleaner because business logic and deployment routing are separated

How `ref()` still works across databases:

- dbt resolves the target relation during compilation using config and graph metadata
- downstream models do not need hardcoded fully qualified names even when objects land in different databases

When a model-level `config(database='...')` override is justified:

- when a single special-purpose model must land in a different database for compliance, cost isolation, or temporary migration reasons

## Task 4 — Multiple virtual warehouses

Recommended workload strategy:

- staging: small warehouse
- intermediate: medium warehouse
- frequent facts: large warehouse
- backfill: dedicated backfill warehouse isolated from daily SLA workloads

Example `profiles.yml` default:

```yaml
warehouse: DBT_DEV_WH
```

Example folder-level routing:

```yaml
models:
  analytics_platform:
    staging:
      +snowflake_warehouse: DBT_SMALL_WH
    intermediate:
      +snowflake_warehouse: DBT_MEDIUM_WH
    marts:
      facts:
        +snowflake_warehouse: DBT_LARGE_WH
```

Example model-level backfill override:

```sql
{{ config(materialized='incremental', snowflake_warehouse='DBT_BACKFILL_WH') }}

select *
from {{ ref('int_orders_enriched') }}
```

Why one warehouse for everything is a bad idea:

- heavy backfills can starve frequent SLA-critical jobs
- cost tuning becomes impossible because all workloads share one size profile
- debugging resource contention becomes much harder

Note on tests:

- many teams run tests on a smaller warehouse because tests are often lighter than large transformation workloads
