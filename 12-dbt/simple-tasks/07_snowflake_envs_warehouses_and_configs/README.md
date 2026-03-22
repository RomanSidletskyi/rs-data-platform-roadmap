# Snowflake Environments, Warehouses, and Configs

## Task 1 — Write a Full profiles.yml for dev, qa, and prod

### Goal

Understand environment separation in Snowflake.

### Input

You need three environments:

- dev
- qa
- prod

Use different databases and different base schemas.

### Requirements

Write a `profiles.yml` with:

- dev → `ANALYTICS_DEV`, `dbt_ivan`, `DBT_DEV_WH`
- qa → `ANALYTICS_QA`, `dbt_ci`, `DBT_QA_WH`
- prod → `ANALYTICS_PROD`, `analytics`, `DBT_PROD_WH`

Include:

- account
- user
- password
- role
- database
- warehouse
- schema
- threads
- query_tag

### Expected Output

A complete profile configuration.

### Extra Challenge

Explain why prod should ideally use a service account instead of a personal user.

--------------------------------------------------

## Task 2 — Write a Detailed dbt_project.yml

### Goal

Understand project-wide config inheritance.

### Input

You want:

- staging on small warehouse
- intermediate on medium warehouse
- dimensions on small warehouse
- facts on large warehouse
- dimensions tagged as daily
- facts tagged as frequent

### Requirements

Write a `dbt_project.yml` that sets:

- project name and version
- paths
- clean targets
- model configs for staging / intermediate / marts
- `snowflake_warehouse`
- `+schema`
- tags
- `+on_schema_change` for facts

### Expected Output

A complete example `dbt_project.yml`.

### Extra Challenge

Add a short explanation of config precedence versus `config()` in a single model.

--------------------------------------------------

## Task 3 — Route Different Domains to Different Databases

### Goal

Learn how to use folder-based routing for multiple Snowflake databases.

### Input

You need:

- CRM dimensions in `CRM_MART_DB`
- Finance dimensions in `FINANCE_MART_DB`
- Sales facts in `SALES_MART_DB`

### Requirements

Show a `dbt_project.yml` folder config that routes these subfolders into different databases and schemas.

Explain:

- why this is easier to maintain than hardcoding database names in every model
- how `ref()` still works across databases

### Expected Output

Folder-based config example and explanation.

### Extra Challenge

Add one example of when a model-level `config(database='...')` override is justified.

--------------------------------------------------

## Task 4 — Configure Multiple Virtual Warehouses

### Goal

Understand workload isolation in Snowflake.

### Input

You have four workload types:

- staging
- intermediate
- frequent facts
- backfill

### Requirements

Design a warehouse strategy and show:

- default warehouse in `profiles.yml`
- folder-level `snowflake_warehouse` in `dbt_project.yml`
- model-level override for a backfill model

Explain why using one warehouse for everything is a bad idea.

### Expected Output

A Snowflake warehouse routing design with code examples.

### Extra Challenge

Add a note about using a smaller warehouse for tests.

