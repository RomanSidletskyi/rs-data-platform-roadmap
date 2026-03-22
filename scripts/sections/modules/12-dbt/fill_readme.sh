#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="12-dbt-fill-readme"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "12-dbt")"

log "Creating 12-dbt README..."

cat <<'EOF' > "$MODULE/README.md"
# 12-dbt

## What this module is about

This module is a deep practical and architectural guide to dbt in modern data platforms.

It is designed not only to teach dbt syntax, but to explain:

- why dbt exists
- where dbt fits in a data platform
- how dbt works with Snowflake
- how dbt is used in real engineering teams
- how dbt is deployed, tested, debugged, and monitored in production

This module should help move from simple understanding of dbt to production-level thinking.

--------------------------------------------------

## What dbt is

dbt (Data Build Tool) is a transformation framework used to build warehouse-native transformation layers.

dbt does not ingest raw data from source systems.
dbt works on top of data already loaded into a warehouse such as Snowflake.

dbt is used to build:

- staging layers
- intermediate transformation layers
- marts
- dimensions
- fact tables
- data quality tests
- documentation
- lineage

In practical terms:

- another system loads data into Snowflake
- dbt transforms that data into trusted business datasets

--------------------------------------------------

## Why dbt matters in data platforms

dbt matters because raw data is not enough.

Real data platforms need:

- standardization
- reusable SQL logic
- clean layered architecture
- tests
- version control
- reproducibility
- lineage
- controlled deployments

Before dbt, SQL logic was often spread across:

- BI tools
- ETL tools
- notebooks
- stored procedures
- ad hoc scripts

This made systems difficult to understand and maintain.

dbt turns transformations into an engineering project.

--------------------------------------------------

## Where dbt fits in a real architecture

A typical architecture looks like this:

    Kafka / APIs / OLTP DBs / files
            ↓
    Databricks / Spark / Python ingestion
            ↓
    Snowflake raw layer
            ↓
    dbt staging
            ↓
    dbt intermediate
            ↓
    dbt marts
            ↓
    Power BI / Domo / APIs / ClickHouse / reverse ETL

In this architecture:

- ingestion is done by Databricks, Spark, Python, Airflow, or another tool
- dbt owns the warehouse transformation layer
- BI and downstream systems consume dbt-built marts

--------------------------------------------------

## What dbt should own

dbt should usually own:

- SQL-based transformations
- warehouse modeling
- dimensions and facts
- marts
- data quality tests
- documentation
- lineage
- incremental warehouse processing logic

dbt is especially strong for:

- ELT patterns
- warehouse-centered platforms
- analytics engineering
- business logic expressed in SQL

--------------------------------------------------

## What dbt should not own

dbt should usually not own:

- raw data ingestion
- complex streaming consumption
- cross-system scheduling and orchestration
- long-running sensors and retries across services
- external API orchestration
- heavy Spark compute workloads

Good architectural split:

- Airflow or GitHub Actions or Databricks Workflows = orchestration / CI/CD
- Databricks / Spark / Python = ingestion and heavy processing
- dbt = warehouse transformation and modeling
- Snowflake = compute and storage for warehouse transformations

--------------------------------------------------

## What this module covers

This module covers dbt from foundations to production usage.

Main topics:

- dbt concepts and architecture
- dbt project structure
- models and materializations
- Jinja and macros
- incremental models
- sources and staging layer
- tests and data quality
- `ref()`, `source()`, DAG, tags, selectors
- Snowflake integration
- multiple virtual warehouses
- dev / qa / prod environments
- `profiles.yml`
- `dbt_project.yml`
- YAML model and source files
- GitHub Actions CI/CD
- Airflow orchestration
- Databricks integration
- performance and cost optimization
- deployment patterns
- `--defer` and Slim CI
- debugging and observability
- lineage and docs without dbt Cloud

--------------------------------------------------

## Learning philosophy of this module

This module is designed around a real learning progression:

    learning-materials → simple-tasks → pet-projects

Meaning:

learning-materials:
- explain architecture
- explain design choices
- explain why patterns exist
- explain trade-offs

simple-tasks:
- focused hands-on practice
- one concept at a time
- realistic data engineering patterns

pet-projects:
- end-to-end system simulations
- realistic engineering structure
- integration of multiple concepts

The objective is not only to learn commands, but to understand how dbt behaves inside a data platform.

--------------------------------------------------

## Module navigation

### 1. learning-materials

This folder contains the theory and architecture part of the module.

It explains:

- how dbt works
- how dbt compiles SQL
- how dbt builds a DAG
- how dbt uses schemas, databases, and environments
- how dbt integrates with Snowflake
- how CI/CD and orchestration work in production

Files included:

- `01_dbt_introduction_and_concepts.md`
- `02_dbt_architecture_and_core_components.md`
- `03_dbt_project_structure.md`
- `04_dbt_models_and_materializations.md`
- `05_dbt_jinja_and_macros.md`
- `06_dbt_incremental_models.md`
- `07_dbt_sources_and_staging_layer.md`
- `08_dbt_tests_and_data_quality.md`
- `09_dbt_ref_source_and_dag.md`
- `10_dbt_with_snowflake_architecture.md`
- `11_dbt_orchestration_ci_cd.md`
- `12_dbt_performance_and_cost_optimization.md`

--------------------------------------------------

### 2. simple-tasks

This folder should contain hands-on topic-based tasks.

Good task topics for this module include:

- writing first models
- defining sources in YAML
- creating staging models
- adding tests
- building incremental models
- using tags and selectors
- working with `dbt_project.yml`
- configuring Snowflake warehouses
- creating dev / prod environment configs
- running jobs through CI/CD

These tasks should be realistic and related to data engineering workflows.

--------------------------------------------------

### 3. pet-projects

This folder should contain realistic production-style projects.

Recommended project themes:

- Kafka raw events landed in Snowflake and transformed by dbt
- API ingestion into raw layer and dbt marts on top
- warehouse project with dimensions, facts, incremental jobs, tests, docs, CI/CD
- multi-environment Snowflake project with GitHub Actions deploy
- Airflow-orchestrated dbt pipeline

The pet projects should simulate real platform work, not only isolated SQL examples.

--------------------------------------------------

## How dbt is usually used with Snowflake

dbt and Snowflake are a very strong combination because:

- Snowflake is SQL-first
- compute and storage are separated
- warehouses are easy to scale
- environments can be isolated cleanly
- dbt fits ELT extremely well

A good production architecture is often:

    raw source tables in Snowflake
            ↓
    dbt staging models
            ↓
    dbt intermediate models
            ↓
    dbt marts
            ↓
    BI / APIs / analytics

--------------------------------------------------

## Multiple virtual warehouses

A very important production topic is warehouse separation.

Different workloads should often use different Snowflake virtual warehouses.

Example pattern:

- `DBT_SMALL_WH` for lightweight staging
- `DBT_MEDIUM_WH` for intermediate models
- `DBT_LARGE_WH` for heavy fact builds
- `DBT_XL_WH` for backfills and full refresh jobs
- optional separate BI warehouse for user-facing queries

Why this matters:

- cost control
- workload isolation
- better performance tuning
- reduced interference between jobs

In this module, this topic is covered in detail, including:

- warehouse config in `profiles.yml`
- warehouse overrides in `dbt_project.yml`
- per-model overrides through `config()`

--------------------------------------------------

## Environments: dev, qa, prod

This module also covers one of the most important production topics:
environment separation.

Common pattern:

dev:
- one developer-specific schema per person
- personal testing
- isolated work

qa:
- shared test environment
- release validation
- CI runs
- often clone-based

prod:
- clean stable schemas
- deployment target
- service account access

Example pattern:

- `ANALYTICS_DEV`
- `ANALYTICS_QA`
- `ANALYTICS_PROD`

with schema naming such as:

- `dbt_ivan_staging`
- `dbt_ci_marts`
- `staging`
- `marts`

This is explained through:

- `profiles.yml`
- `dbt_project.yml`
- `generate_schema_name`

--------------------------------------------------

## YAML and configuration depth

A large part of real dbt work is understanding YAML and config layers.

This module explains:

- source YAML
- model YAML
- tests in YAML
- project-level configs
- model-level `config()`
- config priority
- tags
- selectors
- folders and inheritance
- multi-database and multi-schema setups

This is critical because many production issues in dbt are configuration issues, not SQL issues.

--------------------------------------------------

## Deployment and orchestration focus

This module puts strong emphasis on real deployment patterns.

Covered in detail:

- GitHub Actions for CI and prod deploy
- Airflow triggering dbt jobs
- Databricks invoking dbt after ingestion
- `dbt deps`
- `dbt debug`
- `dbt build`
- `state:modified+`
- `--defer`
- Slim CI
- failure handling
- where to see logs and results
- how to view lineage locally using `dbt docs`

--------------------------------------------------

## What level this module targets

This module is designed to support a progression across several levels.

Beginner:
- understand what dbt is
- run models
- define sources
- write basic tests

Intermediate:
- use layered architecture
- work with YAML confidently
- build incremental models
- understand `ref()` and DAG behavior
- organize model configs by folders

Senior:
- design dbt architecture inside a data platform
- separate responsibilities across dbt, Airflow, Databricks, Snowflake
- manage environments and deployment
- optimize cost and performance
- implement CI/CD
- use tags, selectors, defer, Slim CI
- reason about maintainability and NFRs

--------------------------------------------------

## Recommended study order

Recommended reading order inside `learning-materials`:

1. introduction and concepts
2. architecture and core components
3. project structure
4. models and materializations
5. Jinja and macros
6. incremental models
7. sources and staging
8. tests and data quality
9. refs, source, DAG, selectors
10. Snowflake architecture
11. orchestration and CI/CD
12. performance and cost optimization

This order is intentional:

- first understand what dbt is
- then how dbt is structured
- then how dbt behaves in production
- then how dbt is deployed and operated

--------------------------------------------------

## Shared resource philosophy

If some resource becomes reusable across multiple modules, it should be moved into the repository `shared/` structure.

In the context of dbt, this may include:

- shared datasets
- shared schemas
- shared configs
- shared Docker assets
- shared architecture diagrams
- shared CI/CD templates

The goal is to avoid duplication and reinforce repository consistency.

--------------------------------------------------

## What strong understanding looks like after this module

After this module, a learner should be able to:

- explain where dbt fits in a modern data platform
- build a layered dbt project
- define and document sources
- write tested models
- implement incremental patterns
- separate dev / qa / prod cleanly
- route models to different Snowflake warehouses
- deploy dbt through GitHub Actions
- orchestrate dbt with Airflow or Databricks
- debug dbt runs using compiled SQL and artifacts
- expose lineage through dbt docs
- reason about performance, cost, and maintainability

--------------------------------------------------

## Summary

This module is not only about learning dbt syntax.

It is about understanding dbt as:

- a modeling framework
- a warehouse transformation layer
- a CI/CD-enabled analytics engineering workflow
- a core component of modern Snowflake-centered data platforms

EOF

log "Detailed README for 12-dbt created successfully."
