#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="12-dbt-fill-pet-projects"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "12-dbt")"


log "Creating detailed README for project 01..."

cat <<'EOF' > "$MODULE/pet-projects/README_01_snowflake_dbt_warehouse_foundation.md" 
# Project 01 — Snowflake dbt Warehouse Foundation

## Project Goal

Build a production-style warehouse foundation using Snowflake and dbt.

This project is focused on the most classic and most important dbt use case:

- raw data already exists in Snowflake
- dbt transforms it into staging, intermediate, and marts
- BI tools and downstream users consume curated warehouse datasets

--------------------------------------------------

## Why this project matters

This project teaches the most fundamental warehouse modeling pattern in dbt.

It simulates a real situation where a team needs to:

- define raw sources
- standardize source data
- add reusable transformation layers
- build dimensions and fact tables
- validate data quality
- document the warehouse
- provide lineage and explainability

This is the base pattern behind many real analytics engineering projects.

--------------------------------------------------

## Business Scenario

Assume a company receives raw operational data into Snowflake.

Source systems provide:

- orders
- customers
- products

The business needs:

- a clean customer dimension
- a clean product dimension
- a fact table with all orders
- trusted data for dashboards and reporting

Raw tables are not ready for this directly.

dbt will provide the transformation layer.

--------------------------------------------------

## Architecture

    source systems
        ↓
    Snowflake RAW tables
        ↓
    dbt staging
        ↓
    dbt intermediate
        ↓
    dbt marts
        ↓
    BI / analytics

--------------------------------------------------

## What the project should demonstrate

This project should clearly demonstrate:

- source YAML definitions
- model YAML documentation
- staging models
- intermediate models
- dimensions
- facts
- generic tests
- singular tests
- incremental fact loading
- local dbt docs generation

--------------------------------------------------

## Recommended Data Flow

Example flow:

    RAW.orders
        ↓
    stg_orders
        ↓
    int_orders_dedup
        ↓
    int_orders_enriched
        ↓
    fct_orders

Other example chains:

    RAW.customers
        ↓
    stg_customers
        ↓
    int_customers_latest
        ↓
    dim_customer

    RAW.products
        ↓
    stg_products
        ↓
    dim_product

--------------------------------------------------

## Recommended dbt structure inside the project

    models/
        sources/
            raw_sources.yml

        staging/
            stg_orders.sql
            stg_customers.sql
            stg_products.sql
            staging.yml

        intermediate/
            int_orders_dedup.sql
            int_orders_enriched.sql
            int_customers_latest.sql
            intermediate.yml

        marts/
            dimensions/
                dim_customer.sql
                dim_product.sql

            facts/
                fct_orders.sql

            marts.yml

    macros/
    tests/
    seeds/
    snapshots/

--------------------------------------------------

## Recommended responsibilities by layer

staging:
- rename fields
- cast types
- clean null/blank values
- keep technical metadata where useful
- no heavy business logic

intermediate:
- deduplication
- enrichment joins
- business-ready reusable transformations
- reusable model logic for multiple marts

marts:
- dimension tables
- fact tables
- BI-friendly reporting datasets

--------------------------------------------------

## Recommended materializations

staging:
- view

intermediate:
- view or table depending on complexity and reuse

dimensions:
- table

facts:
- incremental

Why:

- staging should stay lightweight
- dimensions are often reused and should be fast to join
- facts can be large and expensive to rebuild fully

--------------------------------------------------

## Recommended tests

At minimum, include:

for dimensions:
- `not_null`
- `unique`

for facts:
- `not_null`
- `relationships`
- `accepted_values`

singular tests:
- no negative order amounts
- no future order timestamps
- no duplicate active customer record if modeling current-state logic

--------------------------------------------------

## Recommended YAML coverage

This project should include both:

1. source YAML
2. model YAML

Source YAML should document:

- database
- schema
- raw tables
- freshness rules
- source column tests

Model YAML should document:

- model descriptions
- column descriptions
- tests
- business meaning

--------------------------------------------------

## Recommended incremental design

`fct_orders` should ideally be incremental.

Example logic to implement:

- first run creates the full table
- later runs process only new or changed data
- use a lookback window to protect against late-arriving rows

Example design idea:

- unique key: `order_id`
- incremental filter: `ingested_at`
- lookback window: 10 minutes

--------------------------------------------------

## Recommended deliverables

The completed project should contain:

- complete source definitions
- clean layered dbt models
- reusable intermediate logic
- 2 dimensions
- 1 fact table
- YAML documentation
- tests
- dbt docs output instructions

--------------------------------------------------

## What this project teaches

By completing this project, the learner should understand:

- how dbt structures warehouse logic
- why layered architecture matters
- how to model dimensions and facts
- how tests are used in production
- how lineage is built
- how dbt converts raw data into trusted analytical datasets

--------------------------------------------------

## Suggested extensions

After the base version works, extend it with:

- snapshots for customer history
- seed-based mapping tables
- additional marts for reporting
- multiple warehouses for different model groups
- GitHub Actions CI validation

--------------------------------------------------

## Success Criteria

The project is successful if:

- raw sources are clearly documented
- the DAG is understandable
- marts are business-ready
- tests protect critical columns
- fact loading is incremental
- local docs show lineage from source to marts

EOF

log "Project 01 README created successfully."



cat <<'EOF' > "$MODULE/pet-projects/README_02_kafka_snowflake_dbt_incremental_platform.md" 
# Project 02 — Kafka → Snowflake → dbt Incremental Platform

## Project Goal

Build a realistic event-driven analytics pipeline where Kafka events land in Snowflake and dbt transforms them using incremental logic.

This project is designed to teach how dbt fits into near-real-time analytics architectures without pretending that dbt itself is a streaming engine.

--------------------------------------------------

## Why this project matters

This is one of the most important production dbt patterns.

In many real systems:

- Kafka carries business events
- ingestion jobs land those events in Snowflake raw tables
- dbt processes them in micro-batches
- marts are updated every few minutes

This project teaches how to design that pattern correctly.

--------------------------------------------------

## Core Architecture

    Kafka
        ↓
    ingestion job
        ↓
    Snowflake raw table
        ↓
    dbt staging
        ↓
    dbt intermediate
        ↓
    incremental marts
        ↓
    BI / analytics / downstream consumers

--------------------------------------------------

## Optional advanced architecture

More advanced production variant:

    Kafka
        ↓
    ingestion job
        ↓
    Snowflake raw table
        ↓
    Snowflake stream
        ↓
    landing / staging table
        ↓
    dbt incremental transformations
        ↓
    marts

This project may include both designs and compare them.

--------------------------------------------------

## Business Scenario

Imagine an e-commerce system that publishes order events into Kafka.

Events may include:

- order created
- order paid
- order shipped
- order cancelled

A warehouse analytics team needs:

- near-real-time order analytics
- current order state reporting
- reliable event processing
- no duplicate facts
- late-arriving events handled safely

--------------------------------------------------

## Recommended raw table schema

Snowflake raw event table should include:

technical metadata:
- ingested_at
- topic
- partition
- offset

raw payload:
- payload VARIANT

Example payload fields:
- event_id
- order_id
- customer_id
- status
- amount
- event_time

--------------------------------------------------

## Recommended modeling flow

    raw.kafka_orders
        ↓
    stg_kafka_orders
        ↓
    int_orders_dedup
        ↓
    int_orders_latest_state
        ↓
    fct_orders_events
        or
    fct_orders_current

--------------------------------------------------

## What the project should demonstrate

This project should clearly demonstrate:

- source YAML for Kafka raw table
- parsing JSON from VARIANT
- preserving technical metadata
- deduplication logic
- incremental processing
- use of `{{ this }}`
- late-arriving data protection with lookback windows
- tests for keys and valid status values
- realistic micro-batch design

--------------------------------------------------

## Recommended incremental design

The key fact table should be incremental.

Recommended pattern:

- `materialized='incremental'`
- stable `unique_key`
- timestamp filter on `ingested_at`
- lookback window for safe reprocessing

Example design ideas:

- unique key for current-state fact: `order_id`
- unique key for event fact: `event_id`
- lookback window: 10 minutes

--------------------------------------------------

## Why lookback matters

Strict incremental logic based only on:

    max(ingested_at)

can lose late-arriving events.

A safer pattern is:

- take max processed timestamp
- subtract a safety window
- deduplicate again downstream

This project should explicitly implement and explain that.

--------------------------------------------------

## Optional stream design

If you include Snowflake Streams in the project, explain:

- stream tracks changes on a raw table
- dbt usually should not own the whole CDC mechanism
- stream-to-staging is often safer than direct stream consumption in complex pipelines
- dbt is still doing micro-batch transformation, not true streaming

--------------------------------------------------

## Recommended tests

At minimum:

- `not_null` on event_id / order_id
- `unique` on chosen primary key
- `accepted_values` on status
- relationships if dimensions are included

Useful singular tests:

- no negative amount
- no impossible event timestamps
- no duplicate latest state after dedup logic

--------------------------------------------------

## Recommended project structure

    models/
        sources/
            raw_sources.yml

        staging/
            stg_kafka_orders.sql
            staging.yml

        intermediate/
            int_orders_dedup.sql
            int_orders_latest_state.sql
            intermediate.yml

        marts/
            facts/
                fct_orders_events.sql
                fct_orders_current.sql
            marts.yml

    macros/
    tests/
    seeds/

--------------------------------------------------

## Recommended extensions

After the base version works, extend the project with:

- separate dimension models
- order status transition validation
- CI/CD workflow
- selector-based frequent jobs
- warehouse routing for heavy vs light models
- comparison between direct raw incremental and stream-assisted landing

--------------------------------------------------

## What this project teaches

This project should make the learner comfortable with:

- dbt incremental architecture
- Kafka-to-Snowflake landing patterns
- JSON staging models
- CDC-aware warehouse design
- micro-batch analytics
- safe event deduplication patterns

--------------------------------------------------

## Success Criteria

The project is successful if:

- raw events are documented
- staging cleanly parses payloads
- duplicates are handled explicitly
- incremental models process only new data safely
- marts are usable for analytics
- documentation clearly explains why dbt here is micro-batch, not streaming

EOF

log "Project 02 README created successfully."



log "Creating detailed README for project 03..."

cat <<'EOF' > "$MODULE/pet-projects/README_03_dbt_ci_cd_multi_env_platform.md"
# Project 03 — dbt CI/CD Multi-Environment Platform

## Project Goal

Build a production-style operational dbt platform with:

- dev / qa / prod environments
- separate Snowflake databases and schemas
- multiple virtual warehouses
- GitHub Actions CI
- production deployment
- tag-based job execution
- local lineage and docs
- operational visibility

--------------------------------------------------

## Why this project matters

Many teams learn dbt syntax but do not learn how dbt is actually operated in production.

This project focuses on the platform and deployment side of dbt:

- environment isolation
- config hierarchy
- deployment flow
- CI safety checks
- cost-aware Snowflake compute routing
- runtime observability

This is one of the most valuable advanced dbt skills.

--------------------------------------------------

## Core Architecture

    developer branch
        ↓
    GitHub Actions CI
        ↓
    QA validation
        ↓
    merge to main
        ↓
    production deploy
        ↓
    scheduled dbt jobs

Snowflake environments:

- ANALYTICS_DEV
- ANALYTICS_QA
- ANALYTICS_PROD

--------------------------------------------------

## Business Scenario

A team has a shared dbt repository and wants to deploy safely.

Requirements:

- developers must not overwrite each other
- QA should validate changes before production
- production should stay clean
- not every run should rebuild the whole project
- heavy facts and lightweight staging should not always share the same warehouse

--------------------------------------------------

## What the project should demonstrate

This project should include and explain:

- complete `profiles.yml` for dev / qa / prod
- complete `dbt_project.yml`
- custom `generate_schema_name`
- `selectors.yml`
- folder-based config routing
- multiple Snowflake virtual warehouses
- PR validation in GitHub Actions
- production deploy workflow
- scheduled jobs by tag
- local docs generation
- where to inspect artifacts and logs

--------------------------------------------------

## Recommended environment pattern

dev:
- personal schema base, for example `dbt_ivan`
- used for local development
- final schema examples:
  - `dbt_ivan_staging`
  - `dbt_ivan_marts`

qa:
- shared CI schema base, for example `dbt_ci`
- final schema examples:
  - `dbt_ci_staging`
  - `dbt_ci_marts`

prod:
- clean schemas
- final schema examples:
  - `staging`
  - `marts`

--------------------------------------------------

## Recommended warehouse pattern

Suggested Snowflake warehouses:

- `DBT_SMALL_WH` for staging and lightweight tests
- `DBT_MEDIUM_WH` for intermediate models
- `DBT_LARGE_WH` for heavy facts
- `DBT_XL_WH` for backfill / exceptional runs

This project should show:

- default warehouse in `profiles.yml`
- folder-level warehouse routing in `dbt_project.yml`
- model-level override with `config()`

--------------------------------------------------

## CI/CD pattern to implement

PR validation flow:

- checkout code
- install dbt
- generate runtime profile
- run `dbt deps`
- run `dbt debug`
- run build and tests

Production deploy flow:

- trigger on merge to main
- use prod profile
- run `dbt build --target prod`

Optional advanced extension:

- Slim CI with:
  - `state:modified+`
  - `--defer`
  - production artifacts

--------------------------------------------------

## Recommended tagging and selectors

The project should include tags such as:

- `daily_dimension`
- `frequent_fact`
- `staging`

It should also include selectors such as:

- `daily_dims`
- `frequent_facts`

This allows separate scheduled runs for different workloads.

--------------------------------------------------

## Recommended artifact visibility

The project should explicitly document where to inspect:

- `logs/dbt.log`
- `target/compiled/`
- `target/run/`
- `run_results.json`
- `manifest.json`

It should also explain how to view lineage locally:

    dbt docs generate
    dbt docs serve

--------------------------------------------------

## Recommended project structure

    config/
        profiles.example.yml
        dbt_project.example.yml
        selectors.example.yml
        github-actions-ci.example.yml
        github-actions-prod.example.yml

    src/
        helper scripts if needed

    tests/
        critical singular tests

    docker/
        optional local runner support

--------------------------------------------------

## What this project teaches

This project should teach the learner how to think like a production dbt platform engineer:

- how dbt config layers interact
- how schemas are generated across environments
- how CI blocks unsafe changes
- how production deploy is automated
- how to route workloads to different Snowflake warehouses
- how to monitor and debug dbt operationally

--------------------------------------------------

## Suggested advanced extensions

After the base version works, extend it with:

- Airflow-triggered dbt jobs
- Databricks-triggered dbt runs after ingestion
- artifact parsing for internal run reporting
- QA database cloning from prod
- additional environment-specific selectors

--------------------------------------------------

## Success Criteria

The project is successful if:

- environment separation is clear
- config hierarchy is easy to explain
- warehouses are assigned intentionally
- CI and deploy workflows are understandable
- tag-based job scheduling is possible
- the project documents where to see logs, artifacts, and lineage

EOF

log "Project 03 README created successfully."


log "Filling dbt pet projects..."
# ==========================================================
# PROJECT 1
# ==========================================================
PROJECT_1="$MODULE/pet-projects/01_snowflake_dbt_warehouse_foundation"


cat <<'EOF' > "$PROJECT_1/README.md" 
# Project 01 — Snowflake dbt Warehouse Foundation

## Project Goal

Build a production-style dbt warehouse foundation on top of Snowflake raw data.

This project focuses on:

- raw → staging → intermediate → marts
- source YAML
- model YAML
- tests
- dimensions and facts
- incremental fact loading
- docs and lineage

--------------------------------------------------

## Why this project matters

This project simulates the most common real-world dbt use case:

- data already lands in Snowflake
- dbt transforms it into trusted warehouse datasets
- BI tools consume marts

It is the cleanest first production project for learning dbt properly.

--------------------------------------------------

## Architecture

    source systems
        ↓
    Snowflake RAW tables
        ↓
    dbt staging
        ↓
    dbt intermediate
        ↓
    dbt marts
        ↓
    BI / analytics

--------------------------------------------------

## What should be implemented

1. Define source tables in YAML
2. Create staging models
3. Create intermediate models
4. Create:
   - dim_customer
   - dim_product
   - fct_orders
5. Add tests:
   - not_null
   - unique
   - relationships
   - accepted_values
6. Add incremental logic to the fact model
7. Generate docs and lineage

--------------------------------------------------

## Suggested model structure

    models/
        sources/
            raw_sources.yml
        staging/
            stg_orders.sql
            stg_customers.sql
            stg_products.sql
            staging.yml
        intermediate/
            int_orders_dedup.sql
            int_orders_enriched.sql
            intermediate.yml
        marts/
            dimensions/
                dim_customer.sql
                dim_product.sql
            facts/
                fct_orders.sql
            marts.yml

--------------------------------------------------

## Technical focus

This project should teach:

- how dbt organizes warehouse modeling
- why layering matters
- how tests are attached
- how `ref()` and `source()` build lineage
- how incremental facts reduce runtime and cost

--------------------------------------------------

## Expected outcome

By the end of this project, the learner should be able to build a clean warehouse transformation layer in dbt and explain how it works in a real Snowflake environment.

EOF

cat <<'EOF' > "$PROJECT_1/architecture.md"
# Architecture — Snowflake dbt Warehouse Foundation

## Overview

This project assumes raw data is already available in Snowflake.

dbt is responsible for transforming raw data into curated warehouse objects.

--------------------------------------------------

## Data Flow

    RAW tables
        ↓
    staging models
        ↓
    intermediate reusable logic
        ↓
    dimensions / facts
        ↓
    reporting datasets

--------------------------------------------------

## Key design decisions

staging:
- parse and standardize raw fields
- no heavy business logic

intermediate:
- deduplication
- enrichment
- reusable joins

marts:
- business-facing facts and dimensions

--------------------------------------------------

## Materialization recommendations

staging:
- view

intermediate:
- view or table depending on complexity

dimensions:
- table

facts:
- incremental

--------------------------------------------------

## Data quality

This project should include tests for:

- primary keys
- foreign keys
- status fields
- null checks

EOF

cat <<'EOF' > "$PROJECT_1/config/README.md"
# Config

This directory can contain:

- example `dbt_project.yml`
- example `profiles.yml` templates
- selectors.yml
- sample environment variables documentation

EOF

cat <<'EOF' > "$PROJECT_1/src/README.md"
# Source Code

This directory can be used for helper scripts around the dbt project, for example:

- artifact parsers
- helper bootstrap scripts
- local execution scripts

The core transformation logic should remain inside dbt models, not here.

EOF

cat <<'EOF' > "$PROJECT_1/tests/README.md"
# Tests

Add singular SQL tests here.

Example ideas:

- no negative order amounts
- no future event timestamps
- only one active customer record per customer_id

EOF

cat <<'EOF' > "$PROJECT_1/docker/README.md"
# Docker

This folder may contain a local runner setup for dbt, for example:

- Dockerfile
- docker-compose for local dbt execution
- environment templates

EOF

cat <<'EOF' > "$PROJECT_1/data/README.md"
# Data

This directory can contain:

- sample CSV reference data
- mock raw datasets
- small test payloads

Large datasets should not be stored directly in the repo.

EOF

# ==========================================================
# PROJECT 2
# ==========================================================
PROJECT_2="$MODULE/pet-projects/02_kafka_snowflake_dbt_incremental_platform"


cat <<'EOF' > "$PROJECT_2/README.md"
# Project 02 — Kafka → Snowflake → dbt Incremental Platform

## Project Goal

Build a realistic near-real-time analytics pipeline where event data from Kafka lands in Snowflake and is processed by dbt using incremental logic.

--------------------------------------------------

## Why this project matters

This project simulates a very realistic data engineering pattern:

- Kafka produces events
- ingestion lands them into a Snowflake raw table
- dbt processes only new records
- marts are refreshed in micro-batches

This is one of the most important practical dbt patterns in modern data platforms.

--------------------------------------------------

## Architecture

    Kafka
        ↓
    ingestion job
        ↓
    Snowflake raw table
        ↓
    dbt staging
        ↓
    dbt intermediate
        ↓
    incremental marts
        ↓
    BI / analytics

Optional advanced variant:

    raw table
        ↓
    Snowflake stream
        ↓
    staging landing table
        ↓
    dbt incremental marts

--------------------------------------------------

## What should be implemented

1. Define raw Kafka event source table in YAML
2. Create a staging model that parses JSON payloads
3. Add dedup logic in intermediate layer
4. Build an incremental fact model
5. Add lookback window handling
6. Add tests for keys and business status values
7. Document the micro-batch design

--------------------------------------------------

## Suggested source columns

Raw table should simulate fields such as:

- ingested_at
- payload
- topic
- partition
- offset

Payload may include:

- event_id
- order_id
- customer_id
- status
- amount
- event_time

--------------------------------------------------

## What this project teaches

- timestamp-based incremental loading
- late-arriving data handling
- why `{{ this }}` matters
- why lookback windows matter
- why dbt is micro-batch, not true streaming
- how dbt integrates with Kafka-based architectures without directly consuming Kafka

--------------------------------------------------

## Expected outcome

The learner should finish this project able to explain and implement a realistic event-driven dbt pipeline with Snowflake as the warehouse and incremental models as the transformation layer.

EOF

cat <<'EOF' > "$PROJECT_2/architecture.md" << 'EOF'
# Architecture — Kafka → Snowflake → dbt Incremental Platform

## Overview

This project is designed around event ingestion.

Kafka is the transport layer.
Snowflake is the analytical warehouse.
dbt is the transformation layer.

--------------------------------------------------

## Core flow

    Kafka events
        ↓
    ingestion into Snowflake raw table
        ↓
    dbt staging
        ↓
    dbt intermediate dedup
        ↓
    dbt incremental marts

--------------------------------------------------

## Why dbt fits here

dbt should not consume Kafka directly.
dbt should consume landed raw data in Snowflake.

This keeps responsibilities clear:

- ingestion layer handles delivery
- dbt handles warehouse modeling

--------------------------------------------------

## Incremental pattern

Recommended pattern:

    {% if is_incremental() %}
    where ingested_at >= (
        select coalesce(
            dateadd(minute, -10, max(ingested_at)),
            '1900-01-01'::timestamp_ntz
        )
        from {{ this }}
    )
    {% endif %}

This protects against late-arriving events.

--------------------------------------------------

## Optional advanced extension

Add a design note comparing:

1. direct incremental from raw
2. raw → Snowflake stream → landing table → dbt

EOF

cat <<'EOF' > "$PROJECT_2/config/README.md"
# Config

Suggested files for this project:

- example `dbt_project.yml`
- example `sources.yml`
- example `selectors.yml`
- sample environment notes for dev / qa / prod

Suggested selectors:

- `frequent_facts`
- `daily_dims`

EOF

cat <<'EOF' > "$PROJECT_2/src/README.md"
# Source Code

This directory can hold helper code that simulates ingestion or supports local execution.

Example ideas:

- a Python script that writes sample Kafka-like payloads
- a helper to generate mock JSON events
- a script to trigger `dbt build --select tag:frequent_fact`

EOF

cat <<'EOF' > "$PROJECT_2/tests/README.md"
# Tests

Recommended singular tests:

- no duplicate event_id in final mart
- no negative amount
- event_time must not be far in the future
- status must follow valid lifecycle rules if you choose to model them

EOF

cat <<'EOF' > "$PROJECT_2/docker/README.md"
# Docker

Optional local setup ideas:

- dbt runner image
- mock local services for development
- shell runner for repeated `dbt build` testing

EOF

cat <<'EOF' > "$PROJECT_2/data/README.md"
# Data

This directory can contain:

- sample Kafka payloads in JSON
- small mock event files
- seed CSV files for status mappings

EOF

# ==========================================================
# PROJECT 3
# ==========================================================
PROJECT_3="$MODULE/pet-projects/03_dbt_ci_cd_multi_env_platform"


cat <<'EOF' > "$PROJECT_3/README.md"
# Project 03 — dbt CI/CD Multi-Environment Platform

## Project Goal

Build a production-style dbt platform setup focused on:

- dev / qa / prod environments
- Snowflake database and schema separation
- multiple virtual warehouses
- GitHub Actions CI
- deploy to production
- selectors and tagged jobs
- local docs and lineage

--------------------------------------------------

## Why this project matters

A lot of real dbt complexity is not in the SQL itself.
It is in:

- environment isolation
- deployment
- orchestration
- cost control
- CI/CD

This project simulates the operational side of dbt.

--------------------------------------------------

## Architecture

    developer branch
        ↓
    GitHub Actions CI
        ↓
    qa build / validation
        ↓
    merge to main
        ↓
    production deploy
        ↓
    scheduled jobs by tag

Snowflake environments:

- ANALYTICS_DEV
- ANALYTICS_QA
- ANALYTICS_PROD

--------------------------------------------------

## What should be implemented

1. Create a realistic `profiles.yml` example for:
   - dev
   - qa
   - prod

2. Create a `dbt_project.yml` that includes:
   - layered configs
   - warehouse routing
   - tags

3. Create a custom `generate_schema_name` macro

4. Add `selectors.yml` for:
   - daily dimensions
   - frequent facts

5. Add a GitHub Actions PR validation workflow

6. Add a GitHub Actions production deploy workflow

7. Document how to view dbt lineage locally using:
   - `dbt docs generate`
   - `dbt docs serve`

--------------------------------------------------

## What this project teaches

- how dbt is operated in teams
- why config hierarchy matters
- why environments need isolation
- how CI/CD can block bad changes
- how `--defer` and Slim CI reduce cost
- how virtual warehouses are assigned to workloads

--------------------------------------------------

## Expected outcome

The learner should finish this project able to design a production-ready dbt platform with multiple environments and deployment automation.

EOF

cat <<'EOF' > "$PROJECT_3/architecture.md"
# Architecture — dbt CI/CD Multi-Environment Platform

## Overview

This project focuses on operational architecture rather than only transformation logic.

It models how a team safely changes and deploys dbt in Snowflake.

--------------------------------------------------

## Environment design

Recommended environment split:

dev:
- developer-specific schemas
- isolated experiments
- fast feedback

qa:
- shared validation environment
- CI execution
- release confidence

prod:
- stable deployment target
- clean schemas
- service account access

--------------------------------------------------

## Warehouse design

Recommended warehouse split:

- `DBT_SMALL_WH` for staging and tests
- `DBT_MEDIUM_WH` for intermediate
- `DBT_LARGE_WH` for heavy facts
- `DBT_XL_WH` for backfills

--------------------------------------------------

## CI/CD flow

    feature branch
        ↓
    PR validation
        ↓
    dbt deps
        ↓
    dbt debug
        ↓
    dbt build --select state:modified+ --defer
        ↓
    tests
        ↓
    merge
        ↓
    dbt build --target prod

--------------------------------------------------

## Reporting and visibility

Results should be observable through:

- GitHub Actions run history
- dbt logs
- `run_results.json`
- `manifest.json`
- local `dbt docs`

EOF

cat <<'EOF' > "$PROJECT_3/config/README.md"
# Config

This directory should contain the most important operational examples for the project.

Recommended files:

- `profiles.example.yml`
- `dbt_project.example.yml`
- `selectors.example.yml`
- `github-actions-ci.example.yml`
- `github-actions-prod.example.yml`

EOF

cat <<'EOF' > "$PROJECT_3/src/README.md"
# Source Code

This directory may contain helper scripts such as:

- local bootstrap helpers
- artifact parsing scripts
- environment variable loaders
- local docs generation wrappers

EOF

cat <<'EOF' > "$PROJECT_3/tests/README.md"
# Tests

Focus here on operational and quality validation examples.

Ideas:

- critical mart tests
- high-value business rule tests
- tests that should block production deploy

EOF

cat <<'EOF' > "$PROJECT_3/docker/README.md"
# Docker

Optional local execution support:

- dbt execution image
- local docs serving
- local environment bootstrap runner

EOF

cat <<'EOF' > "$PROJECT_3/data/README.md"
# Data

This project is primarily operational, so data may be limited to:

- small sample seeds
- test fixtures
- mock source snapshots for local experiments

EOF

log "DBT pet projects created successfully."