#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="12-dbt-fill-simple-tasks"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "12-dbt")"

log "Creating simple tasks ..."


cat <<'EOF' > "$MODULE/simple-tasks/01_dbt_basics_and_project_structure/README.md"
# DBT Basics and Project Structure

## Task 1 — Explain Where dbt Fits in a Data Platform

### Goal

Understand the exact role of dbt inside a modern data platform.

### Input

You have the following architecture:

    Kafka / APIs / OLTP DBs
            ↓
    Databricks / Python ingestion
            ↓
    Snowflake raw layer
            ↓
    dbt
            ↓
    BI / API / analytics

### Requirements

Write a short explanation that answers:

- what dbt is responsible for
- what dbt should not be responsible for
- why dbt is usually placed after ingestion
- how dbt differs from Spark / Databricks
- why dbt is strong in Snowflake-centered architectures

### Expected Output

A markdown note with a clear architecture explanation.

### Extra Challenge

Add a short paragraph explaining why dbt is better for warehouse business logic than putting everything into notebooks.

--------------------------------------------------

## Task 2 — Create a Standard dbt Project Skeleton

### Goal

Learn the standard project structure of a dbt project.

### Input

Create a structure that includes:

- models
- macros
- tests
- seeds
- snapshots
- analyses

### Requirements

Write the expected folder tree of a dbt project and explain what each folder is used for.

### Expected Output

A markdown document with a project tree and explanations.

### Extra Challenge

Add a second version of the tree that also separates `staging`, `intermediate`, and `marts`.

--------------------------------------------------

## Task 3 — Describe Layered Modeling

### Goal

Understand why staging, intermediate, and marts should be separate.

### Input

You have raw orders data coming from Kafka in Snowflake.

### Requirements

Describe:

- what should happen in staging
- what should happen in intermediate
- what should happen in marts
- what should not happen in staging
- why this separation helps debugging and maintenance

### Expected Output

A markdown explanation with concrete examples.

### Extra Challenge

Add a simple end-to-end chain:

    raw → stg_orders → int_orders → fct_orders

and explain what each model does.

EOF

cat <<'EOF' > "$MODULE/simple-tasks/02_sources_yaml_and_staging/README.md"
# Sources YAML and Staging

## Task 1 — Create a Detailed Source YAML

### Goal

Learn how to define raw source tables in dbt.

### Input

Assume you have a Snowflake table:

    RAW_DB.RAW.kafka_orders

with columns:

- ingested_at
- payload
- topic
- partition
- offset

### Requirements

Write a complete `sources.yml` entry that includes:

- source name
- database
- schema
- table name
- description
- loaded_at_field
- freshness
- column descriptions
- at least one test

### Expected Output

A valid dbt source YAML definition.

### Extra Challenge

Add tags and `meta` fields for owner and domain.

--------------------------------------------------

## Task 2 — Build a Staging Model for Kafka JSON

### Goal

Practice writing a clean staging model.

### Input

Assume `payload` is JSON with:

- order_id
- customer_id
- amount
- status
- event_time

### Requirements

Write a `stg_kafka_orders.sql` model that:

- reads from `source('raw', 'kafka_orders')`
- parses JSON fields
- casts types correctly
- renames fields into business-friendly names
- keeps technical metadata columns

### Expected Output

A realistic staging model in SQL.

### Extra Challenge

Add a `where payload is not null` filter and explain why it belongs in staging.

--------------------------------------------------

## Task 3 — Write Model YAML for the Staging Model

### Goal

Learn how model YAML differs from source YAML.

### Input

Use the staging model from Task 2.

### Requirements

Write a model YAML file that includes:

- model description
- column descriptions
- `not_null` tests for order_id and ingested_at
- an `accepted_values` test for status

### Expected Output

A valid YAML block for `stg_kafka_orders`.

### Extra Challenge

Explain in notes why model YAML does not decide the target schema or database.

EOF

cat <<'EOF' > "$MODULE/simple-tasks/03_materializations_and_models/README.md"
# Materializations and Models

## Task 1 — Compare view, table, incremental, and ephemeral

### Goal

Build strong intuition about materializations.

### Input

You have four model types to compare:

- staging model
- small dimension
- large fact table
- helper transformation used only once

### Requirements

For each of the four cases, choose a materialization and explain:

- why it fits
- what the trade-offs are
- what happens physically in Snowflake
- how this choice affects performance and debugging

### Expected Output

A comparison table or structured markdown explanation.

### Extra Challenge

Add a section describing when `ephemeral` becomes a bad idea.

--------------------------------------------------

## Task 2 — Create a Dimension as a Table

### Goal

Practice a simple persisted dimension model.

### Input

Use `int_customers_latest` as an upstream model.

### Requirements

Write a `dim_customer.sql` model with:

- `materialized='table'`
- selected customer columns
- a short comment explaining why a table is better than a view in this case

### Expected Output

A dbt model for a dimension table.

### Extra Challenge

Add a YAML file with `unique` and `not_null` tests on `customer_id`.

--------------------------------------------------

## Task 3 — Create a Fact Model as Incremental

### Goal

Practice selecting the right materialization for large fact tables.

### Input

Use `int_orders_enriched` as the upstream model.

### Requirements

Write `fct_orders.sql` with:

- `materialized='incremental'`
- `unique_key='order_id'`
- incremental logic using `{{ this }}`
- a lookback window of 10 minutes

### Expected Output

A realistic incremental fact model.

### Extra Challenge

Explain why a full refresh on every run would be a bad idea for this fact table.

EOF

cat <<'EOF' > "$MODULE/simple-tasks/04_jinja_macros_and_generate_schema/README.md"
# Jinja, Macros, and generate_schema_name

## Task 1 — Write a Reusable safe_cast Macro

### Goal

Learn how macros generate reusable SQL.

### Input

You often need:

    try_cast(payload:amount as number(18,2))

in many models.

### Requirements

Create a macro:

- name: `safe_cast`
- parameters: expression, data_type
- return SQL using `try_cast`

Then show how it would be used inside a staging model.

### Expected Output

One macro definition and one example usage.

### Extra Challenge

Add a second example for timestamps.

--------------------------------------------------

## Task 2 — Write a deduplicate_latest Macro

### Goal

Practice writing a production-style macro.

### Input

You want to keep only the latest record per `order_id`.

### Requirements

Create a macro that accepts:

- relation
- key
- order_by

The macro should return SQL using `row_number()` and `rn = 1`.

### Expected Output

A macro definition plus an example usage against `ref('stg_orders')`.

### Extra Challenge

Add simple argument validation with `exceptions.raise_compiler_error`.

--------------------------------------------------

## Task 3 — Implement generate_schema_name

### Goal

Understand how dbt builds final schemas across environments.

### Input

You have:

- dev target schema = `dbt_ivan`
- qa target schema = `dbt_ci`
- prod target schema = `analytics`

You want:

- dev staging → `dbt_ivan_staging`
- qa marts → `dbt_ci_marts`
- prod staging → `staging`
- prod marts → `marts`

### Requirements

Write a custom `generate_schema_name` macro implementing this behavior.

Explain:

- why developers should not write into a shared `staging` schema
- why production should remain clean
- why dbt calls this macro automatically

### Expected Output

A complete macro and a short explanation.

### Extra Challenge

Add a short note explaining where `custom_schema_name` comes from.

EOF

cat <<'EOF' > "$MODULE/simple-tasks/05_incremental_models_and_cdc_patterns/README.md"
# Incremental Models and CDC Patterns

## Task 1 — Build a Timestamp-Based Incremental Model

### Goal

Learn the classic dbt incremental pattern.

### Input

Use a staging table with columns:

- order_id
- customer_id
- amount
- ingested_at

### Requirements

Write an incremental model that:

- uses `materialized='incremental'`
- reads from the staging model
- loads full data on first run
- loads only new data on later runs
- uses `{{ this }}`

### Expected Output

A working incremental model.

### Extra Challenge

Add a 10-minute lookback window and explain why it is safer than strict max timestamp logic.

--------------------------------------------------

## Task 2 — Compare merge vs append vs delete+insert

### Goal

Understand different incremental strategies.

### Input

Compare these strategies for a fact table with late updates:

- merge
- append
- delete+insert

### Requirements

For each strategy explain:

- how it behaves
- when it is safe
- when it is dangerous
- what kind of source pattern it fits

### Expected Output

A detailed comparison.

### Extra Challenge

Write a config block for each strategy.

--------------------------------------------------

## Task 3 — Design Two CDC Patterns

### Goal

Understand how dbt participates in CDC but does not necessarily own it.

### Input

Design two architectures:

1. Kafka → raw table → dbt incremental by ingested_at
2. raw table → Snowflake stream → staging table → dbt

### Requirements

Explain for each architecture:

- where changes are captured
- what dbt reads
- why one pattern may be simpler
- why stream-to-staging is often safer in production than direct stream consumption

### Expected Output

Two architecture explanations with flow diagrams in markdown.

### Extra Challenge

Add a note about what happens if a developer runs the incremental model for the first time in a new dev schema.

EOF

cat <<'EOF' > "$MODULE/simple-tasks/06_tests_tags_selectors_and_dag/README.md"
# Tests, Tags, Selectors, and DAG

## Task 1 — Add Generic Tests to a Fact Model

### Goal

Learn how to protect data quality using YAML tests.

### Input

Use a `fct_orders` model with:

- order_id
- customer_id
- order_status
- amount

### Requirements

Write a YAML file that adds:

- `not_null` and `unique` to order_id
- `not_null` and `relationships` to customer_id
- `accepted_values` to order_status

### Expected Output

A model YAML block.

### Extra Challenge

Explain what happens operationally when these tests fail in CI.

--------------------------------------------------

## Task 2 — Write a Singular Test

### Goal

Learn how singular tests work.

### Input

Business rule:
no order amount may be negative.

### Requirements

Write a singular SQL test that fails when amount is negative.

Explain:

- why the test fails if rows are returned
- how this differs from a SQL syntax error

### Expected Output

A singular test SQL file and short explanation.

### Extra Challenge

Add a second singular test for future event dates.

--------------------------------------------------

## Task 3 — Use Tags and Selectors for Daily and Frequent Jobs

### Goal

Learn how to split dbt runs by cadence.

### Input

You have:

- dimensions refreshed once a day
- frequent facts refreshed every 15 minutes

### Requirements

Do the following:

- show how to assign tags using `dbt_project.yml`
- create a `selectors.yml` with:
  - `daily_dims`
  - `frequent_facts`
- show commands to run both selectors

### Expected Output

Example `dbt_project.yml`, `selectors.yml`, and run commands.

### Extra Challenge

Explain why a fact model can still `ref()` a dimension that is not rebuilt every 15 minutes.

--------------------------------------------------

## Task 4 — Practice Graph Selection with +

### Goal

Learn how `+` changes dbt selection.

### Input

Assume graph:

    stg_orders
        ↓
    int_orders
        ↓
    fct_orders
        ↓
    rpt_sales

### Requirements

Explain what each command selects:

    dbt build --select fct_orders
    dbt build --select +fct_orders
    dbt build --select fct_orders+
    dbt build --select +fct_orders+

### Expected Output

A clear explanation of the selected graph in each case.

### Extra Challenge

Add a practical note on when `+model` is safer than `model+`.

EOF

cat <<'EOF' > "$MODULE/simple-tasks/07_snowflake_envs_warehouses_and_configs/README.md"
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

EOF

cat <<'EOF' > "$MODULE/simple-tasks/08_ci_cd_github_actions_airflow_databricks/README.md"
# CI/CD with GitHub Actions, Airflow, and Databricks

## Task 1 — Create a PR Validation Workflow in GitHub Actions

### Goal

Learn how dbt is validated before merge.

### Input

You need a PR workflow that:

- checks out code
- installs dbt-snowflake
- creates a runtime `profiles.yml`
- runs `dbt deps`
- runs `dbt debug`
- runs `dbt build`

### Requirements

Write a GitHub Actions workflow YAML using repository secrets for Snowflake credentials.

### Expected Output

A complete `dbt-ci.yml` example.

### Extra Challenge

Modify the workflow to use:

    dbt build --select state:modified+ --defer --state artifacts/prod

and explain why that is useful.

--------------------------------------------------

## Task 2 — Create a Production Deploy Workflow in GitHub Actions

### Goal

Learn how merge-to-main deploy works.

### Input

You need a workflow that runs on:

    push to main

and deploys dbt to production.

### Requirements

Write a GitHub Actions workflow that:

- uses prod secrets
- creates a prod profile
- runs:
  - `dbt deps`
  - `dbt debug`
  - `dbt build --target prod`

### Expected Output

A complete `dbt-prod.yml` example.

### Extra Challenge

Add a second scheduled workflow for:

    dbt build --select tag:frequent_fact --target prod

running every 15 minutes.

--------------------------------------------------

## Task 3 — Create a Simple Airflow DAG for dbt

### Goal

Understand how Airflow orchestrates dbt.

### Input

You need a DAG that:

- runs `dbt deps`
- runs staging models
- runs facts
- keeps dependency order

### Requirements

Write a minimal Airflow DAG using `BashOperator`.

Explain:

- why Airflow should orchestrate rather than hold business SQL
- where retries and alerts belong

### Expected Output

A runnable DAG example.

### Extra Challenge

Add a note about where to inspect task logs and task status in Airflow.

--------------------------------------------------

## Task 4 — Trigger dbt from a Databricks Job

### Goal

Understand how dbt can be invoked after ingestion.

### Input

Assume Databricks performs ingestion and must then trigger dbt.

### Requirements

Write a small Python script that uses `subprocess.run()` to execute:

- `dbt deps`
- `dbt debug --target prod`
- `dbt build --select tag:frequent_fact --target prod`

Explain:

- why Databricks is not replacing dbt here
- why this pattern is useful after ingestion jobs

### Expected Output

A Python job example and explanation.

### Extra Challenge

Add a short note on where run logs and results would be visible in Databricks Workflows.

--------------------------------------------------

## Task 5 — Explain Observability and Reporting for dbt Runs

### Goal

Learn how teams monitor dbt runs.

### Input

Consider three runtime environments:

- GitHub Actions
- Airflow
- Databricks Jobs

### Requirements

Explain where to look for:

- success/failure status
- logs
- compiled SQL
- run results
- lineage graph without dbt Cloud

Mention:

- `logs/dbt.log`
- `target/compiled/`
- `target/run/`
- `run_results.json`
- `manifest.json`
- `dbt docs generate`
- `dbt docs serve`

### Expected Output

A practical monitoring guide.

### Extra Challenge

Add a short section describing how a team could push dbt artifacts into an internal reporting table for operational visibility.

EOF

log "DBT simple tasks created successfully."