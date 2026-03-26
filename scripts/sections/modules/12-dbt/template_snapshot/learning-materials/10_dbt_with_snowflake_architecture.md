# DBT with Snowflake Architecture

## Why dbt and Snowflake work well together

Snowflake is a strong fit for dbt because:

- compute and storage are separated
- SQL is the primary transformation language
- warehouses can be scaled independently
- schemas and databases are easy to organize per environment

--------------------------------------------------

## Different warehouses for different workloads

In Snowflake, a virtual warehouse is a compute resource.
It is independent from database and schema namespaces.

Good production pattern:

- `DBT_SMALL_WH` for lightweight staging
- `DBT_MEDIUM_WH` for intermediate transforms
- `DBT_LARGE_WH` for heavy facts
- `DBT_XL_WH` for backfills / full refresh
- separate BI warehouse if you want to isolate user queries

--------------------------------------------------

## Base warehouse in profiles.yml

Example:

    analytics_dbt:
      target: prod
      outputs:
        prod:
          type: snowflake
          account: your_account
          user: svc_dbt_prod
          password: your_password
          role: ANALYTICS_PROD_ROLE
          database: ANALYTICS_PROD
          warehouse: DBT_MEDIUM_WH
          schema: analytics
          threads: 8

This is the default warehouse for the target.

--------------------------------------------------

## Override warehouse in dbt_project.yml

dbt Snowflake supports `snowflake_warehouse` at model group and test levels. :contentReference[oaicite:11]{index=11}

Example:

    models:
      analytics_dbt:
        staging:
          +materialized: view
          +snowflake_warehouse: DBT_SMALL_WH

        intermediate:
          +materialized: view
          +snowflake_warehouse: DBT_MEDIUM_WH

        marts:
          dimensions:
            +materialized: table
            +snowflake_warehouse: DBT_SMALL_WH

          facts:
            +materialized: incremental
            +snowflake_warehouse: DBT_LARGE_WH

    data_tests:
      +snowflake_warehouse: DBT_SMALL_WH

--------------------------------------------------

## Override warehouse on a single model

    {{ config(
        materialized='incremental',
        snowflake_warehouse='DBT_XL_WH'
    ) }}

Use this only for exceptions.

--------------------------------------------------

## Different databases and schemas across environments

Good enterprise pattern:

dev:
- database: `ANALYTICS_DEV`
- schema base: `dbt_ivan`

qa:
- database: `ANALYTICS_QA`
- schema base: `dbt_ci`

prod:
- database: `ANALYTICS_PROD`
- schema base: `analytics`

Example `profiles.yml`:

    analytics_dbt:
      target: dev
      outputs:
        dev:
          type: snowflake
          account: your_account
          user: dev_user
          password: your_password
          role: DEV_ROLE
          database: ANALYTICS_DEV
          warehouse: DBT_DEV_WH
          schema: dbt_ivan
          threads: 4

        qa:
          type: snowflake
          account: your_account
          user: qa_user
          password: your_password
          role: QA_ROLE
          database: ANALYTICS_QA
          warehouse: DBT_QA_WH
          schema: dbt_ci
          threads: 6

        prod:
          type: snowflake
          account: your_account
          user: svc_dbt_prod
          password: your_password
          role: PROD_ROLE
          database: ANALYTICS_PROD
          warehouse: DBT_PROD_WH
          schema: analytics
          threads: 8

--------------------------------------------------

## Detailed dbt_project.yml

`dbt_project.yml` controls project-wide defaults. Model configs are applied hierarchically, and deeper nesting is more specific. `config()` inside the model has higher precedence; YAML `config` properties also participate in the hierarchy. :contentReference[oaicite:12]{index=12}

Example:

    name: 'analytics_dbt'
    version: '1.0.0'
    config-version: 2

    profile: 'analytics_dbt'

    model-paths: ["models"]
    analysis-paths: ["analyses"]
    test-paths: ["tests"]
    seed-paths: ["seeds"]
    macro-paths: ["macros"]
    snapshot-paths: ["snapshots"]

    target-path: "target"
    clean-targets:
      - "target"
      - "dbt_packages"

    models:
      analytics_dbt:
        +persist_docs:
          relation: true
          columns: true

        staging:
          +materialized: view
          +schema: staging
          +snowflake_warehouse: DBT_SMALL_WH
          +tags: ['staging']

        intermediate:
          +materialized: view
          +schema: intermediate
          +snowflake_warehouse: DBT_MEDIUM_WH
          +tags: ['intermediate']

        marts:
          +schema: marts

          dimensions:
            +materialized: table
            +snowflake_warehouse: DBT_SMALL_WH
            +tags: ['daily_dimension']

          facts:
            +materialized: incremental
            +snowflake_warehouse: DBT_LARGE_WH
            +tags: ['frequent_fact']
            +on_schema_change: sync_all_columns

--------------------------------------------------

## What dbt_project.yml fields mean

`name`
- project name

`version`
- project version

`config-version`
- dbt config format version

`profile`
- profile name to look up in `profiles.yml`

`model-paths`, `test-paths`, etc.
- where dbt finds resources

`target-path`
- where artifacts and compiled SQL are written

`clean-targets`
- directories removed by `dbt clean`

`models`
- default configs for groups of models

`+materialized`
- default materialization for that folder subtree

`+schema`
- custom schema name passed into schema naming logic

`+database`
- database override if needed

`+snowflake_warehouse`
- compute warehouse override for Snowflake

`+tags`
- labels used for selectors and grouping

`+on_schema_change`
- behavior for schema drift in incremental models

--------------------------------------------------

## Detailed profiles.yml explanation

Example:

    analytics_dbt:
      target: dev
      outputs:
        dev:
          type: snowflake
          account: your_account_region
          user: dev_user
          password: your_password
          role: DEV_ROLE
          database: ANALYTICS_DEV
          warehouse: DBT_DEV_WH
          schema: dbt_ivan
          threads: 4
          client_session_keep_alive: false
          query_tag: dbt_dev

Field meanings:

`target`
- default active output

`outputs`
- environment definitions

`type`
- adapter type, here `snowflake`

`account`
- Snowflake account identifier

`user`, `password`
- credentials

`role`
- Snowflake role used by dbt

`database`
- default database for created relations

`warehouse`
- default Snowflake compute warehouse

`schema`
- base schema used by target

`threads`
- parallelism for execution

`query_tag`
- helpful for Snowflake query tracking

--------------------------------------------------

## Source and model YAML are different

Important distinction:

model YAML:
- documentation
- tests
- metadata

source YAML:
- external raw table metadata
- source docs
- freshness
- source tests

model YAML does not decide the target database/schema.
That comes from `profiles.yml`, `dbt_project.yml`, macros, and model config.

--------------------------------------------------

## Multi-database setup by folder

Yes, you can route different subfolders to different databases.

Example:

    models:
      analytics_dbt:
        marts:
          dimensions:
            crm:
              +database: CRM_MART_DB
              +schema: dims

            finance:
              +database: FINANCE_MART_DB
              +schema: dims

          facts:
            sales:
              +database: SALES_MART_DB
              +schema: facts

`ref()` still works across databases as long as permissions exist.

