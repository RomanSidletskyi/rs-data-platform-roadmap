#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="12-dbt-fill-learning-materials"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "12-dbt")"

log "Creating learning materials README..."


cat <<'EOF' > "$MODULE/learning-materials/01_dbt_introduction_and_concepts.md"
# DBT Introduction and Concepts

## What dbt is

dbt (Data Build Tool) is a transformation framework for analytics engineering and data platforms.

dbt is not an ingestion tool.
dbt is not a scheduler.
dbt is not a compute engine by itself.

dbt compiles SQL and Jinja into warehouse-native SQL and runs it inside the data warehouse.

In practice this means:

- data is ingested into a warehouse by another tool
- dbt transforms raw data into business-ready datasets
- dbt adds tests, lineage, documentation, modularity, and CI/CD workflow

--------------------------------------------------

## Why dbt exists

Before dbt, SQL transformation logic was often:

- scattered across BI tools, notebooks, stored procedures, and ETL jobs
- hard to version
- hard to test
- hard to document
- hard to understand as a full graph

dbt solves this by making transformations look like software projects.

--------------------------------------------------

## dbt in a data platform

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
    Power BI / Domo / APIs / reverse ETL

--------------------------------------------------

## ELT instead of ETL

dbt is built around ELT:

    Extract → Load → Transform

This means:

- extract and load happen first
- transformations happen inside the warehouse

This is why dbt is especially strong with Snowflake.

--------------------------------------------------

## dbt vs Spark

dbt is strongest when:

- transformations are SQL-friendly
- the warehouse is the main computation layer
- business logic should be visible and testable
- lineage and documentation matter

Spark / Databricks is stronger when:

- ingestion is complex
- processing volume is very large
- there is streaming
- there are nested payloads and heavy compute tasks
- PySpark is needed

Good rule:

- Databricks / Spark = ingestion, heavy processing, streaming
- dbt = warehouse transformation, modeling, data quality, lineage

--------------------------------------------------

## Core mental model

dbt should own:

- staging
- intermediate transformations
- marts
- tests
- docs
- lineage

dbt should not own:

- Kafka consumption
- long-running orchestration across systems
- external sensors
- full data movement platform logic

EOF

cat <<'EOF' > "$MODULE/learning-materials/02_dbt_architecture_and_core_components.md"
# DBT Architecture and Core Components

## Core building blocks

A dbt project typically contains:

- models
- macros
- tests
- sources
- snapshots
- seeds
- project configuration
- environment configuration

--------------------------------------------------

## Models

Models are SQL select statements that define transformed datasets.

A model becomes one of:

- view
- table
- incremental table
- ephemeral CTE

--------------------------------------------------

## Macros

Macros are reusable Jinja + SQL snippets.

They are used for:

- repeated SQL logic
- dynamic SQL generation
- schema naming
- custom reusable filters
- helper logic for Snowflake-specific patterns

--------------------------------------------------

## Tests

dbt supports:

- generic tests defined in YAML
- singular tests written as SQL files

Tests validate data quality, not just syntax.

--------------------------------------------------

## Sources

Sources represent raw input tables.

They are declared in YAML and referenced with:

    {{ source('raw', 'orders') }}

This gives dbt lineage from raw tables to final marts.

--------------------------------------------------

## Snapshots

Snapshots are used to preserve row history over time.

They are useful for:

- SCD Type 2
- keeping track of changing dimension values
- historical comparisons

--------------------------------------------------

## Seeds

Seeds are static CSV files loaded by dbt into the warehouse.

They are useful for:

- lookup tables
- reference mappings
- demo data
- small configuration data

--------------------------------------------------

## DAG

dbt builds a DAG from `ref()` and `source()` references.

Example:

    stg_orders
        ↓
    int_orders
        ↓
    fct_orders

dbt resolves execution order automatically. :contentReference[oaicite:1]{index=1}

--------------------------------------------------

## Compilation model

dbt workflow is:

1. parse project
2. resolve refs and sources
3. apply configs
4. compile Jinja + SQL
5. execute warehouse SQL

dbt does not invent a custom execution engine.
Snowflake executes the final SQL.

--------------------------------------------------

## Final relation

Every model becomes a relation:

    database.schema.identifier

Example:

    ANALYTICS_PROD.marts.fct_orders

The final relation is determined by:

- target values from `profiles.yml`
- folder and model configs from `dbt_project.yml`
- model-level `config()`
- naming macros such as `generate_schema_name`
- optional alias overrides

EOF

cat <<'EOF' > "$MODULE/learning-materials/03_dbt_project_structure.md"
# DBT Project Structure

## Recommended structure

    12-dbt/
        README.md
        learning-materials/
        simple-tasks/
        pet-projects/

Example real dbt project structure:

    dbt_project/
        dbt_project.yml
        packages.yml
        models/
            sources/
            staging/
            intermediate/
            marts/
        macros/
        tests/
        seeds/
        snapshots/
        analyses/

--------------------------------------------------

## Why layered models matter

Recommended warehouse transformation flow:

    raw
        ↓
    staging
        ↓
    intermediate
        ↓
    marts

Responsibilities:

staging:
- parse
- cast
- rename
- minimal cleanup

intermediate:
- joins
- dedup
- enrichment
- business rules
- reusable transformation steps

marts:
- dimensions
- facts
- reporting datasets
- BI-facing tables

--------------------------------------------------

## Example folder structure for domains

    models/
        staging/
            sales/
            crm/
            finance/
        intermediate/
            sales/
            crm/
            finance/
        marts/
            dimensions/
                crm/
                product/
                finance/
            facts/
                sales/
                finance/

This works well when models belong to different business domains and may target different databases and schemas.

--------------------------------------------------

## Where logic should live

Good separation:

- source parsing and standardization → staging
- cross-source business transformations → intermediate
- end-user datasets → marts

Bad separation:

- giant SQL directly from raw to marts
- hidden business logic in macros everywhere
- orchestration logic inside models

EOF

cat <<'EOF' > "$MODULE/learning-materials/04_dbt_models_and_materializations.md"
# DBT Models and Materializations

## Materialization overview

dbt supports multiple model materializations.

The most important are:

- view
- table
- incremental
- ephemeral

--------------------------------------------------

## view

Use when:

- data is lightweight
- logic is simple
- storage persistence is not required
- staging models are mostly pass-through

Pros:
- no duplicated storage
- easy to rebuild
- good for lightweight staging

Cons:
- query logic is recalculated at read time
- complex downstream chains can become expensive

--------------------------------------------------

## table

Use when:

- model is reused often
- logic is expensive
- stable persisted data is needed
- a dimension should be fast to join

Pros:
- faster downstream access
- stable performance
- good for dimensions and curated datasets

Cons:
- consumes storage
- full rebuild may be expensive

--------------------------------------------------

## incremental

Use when:

- table is large
- data arrives incrementally
- processing everything every run is too expensive
- fact tables are frequently updated

Incremental means:

- first run: full create
- next runs: process only new or changed data

If the target table does not exist, dbt falls back to creating it as a full load.

--------------------------------------------------

## ephemeral

Use when:

- logic is small and reusable
- you do not want a warehouse object
- you want a helper transformation inserted as a CTE

Ephemeral models are not created as warehouse tables or views.
They are inlined into downstream SQL as CTEs.

Pros:
- keeps warehouse cleaner
- good for helper logic

Cons:
- harder to debug
- compiled SQL becomes larger
- not ideal for heavy or frequently reused logic

--------------------------------------------------

## Practical defaults

staging:
- view

intermediate:
- view or table
- ephemeral only for small helpers

dimensions:
- table

facts:
- incremental or table depending on volume

--------------------------------------------------

## Example model-level config

    {{ config(
        materialized='incremental',
        unique_key='order_id'
    ) }}

--------------------------------------------------

## What materialization changes in practice

If model `stg_orders` is a view, then:

    {{ ref('stg_orders') }}

resolves to a warehouse view.

If `stg_orders` is a table, `ref()` resolves to a physical table.

If `stg_orders` is ephemeral, dbt inlines it as a CTE into downstream SQL.

EOF

cat <<'EOF' > "$MODULE/learning-materials/05_dbt_jinja_and_macros.md"
# DBT Jinja and Macros

## Jinja in dbt

dbt uses Jinja as a templating layer on top of SQL.

Jinja lets you use:

- variables
- conditionals
- loops
- macros
- helper functions

Example:

    {% if is_incremental() %}
        where updated_at > ...
    {% endif %}

--------------------------------------------------

## What a macro is

A macro is reusable Jinja + SQL logic.

It is not executed by Snowflake directly.
dbt expands the macro into SQL before execution.

Example:

    {% macro safe_cast(expression, data_type) %}
        try_cast({{ expression }} as {{ data_type }})
    {% endmacro %}

Used in a model:

    select
        {{ safe_cast("payload:amount", "number(18,2)") }} as amount
    from {{ source('raw', 'orders') }}

--------------------------------------------------

## Why macros matter

Macros are useful when:

- logic repeats
- SQL should be standardized
- dynamic generation is needed
- environment-aware behavior is needed

Typical macro use cases:

- safe casts
- audit columns
- incremental lookback filters
- deduplication helpers
- schema naming
- surrogate keys

--------------------------------------------------

## generate_schema_name

This is one of the most important dbt macros in real projects.

dbt generates custom schema names by combining the target schema and the custom schema.
Default behavior appends custom schema to the target schema. :contentReference[oaicite:2]{index=2}

Example custom macro:

    {% macro generate_schema_name(custom_schema_name, node) -%}
        {%- set default_schema = target.schema -%}

        {%- if target.name == 'prod' -%}
            {{ custom_schema_name if custom_schema_name is not none else default_schema }}
        {%- else -%}
            {{ default_schema }}{% if custom_schema_name is not none %}_{{ custom_schema_name }}{% endif %}
        {%- endif -%}
    {%- endmacro %}

What it does:

in dev:
- target.schema = `dbt_ivan`
- model custom schema = `staging`
- final schema = `dbt_ivan_staging`

in prod:
- target.name = `prod`
- custom schema = `staging`
- final schema = `staging`

Why this is useful:

- developers do not overwrite each other
- production schemas stay clean
- the same code works across environments

--------------------------------------------------

## Important note about `generate_schema_name`

You never manually call it in models.

dbt calls it automatically when building the final schema for a model. :contentReference[oaicite:3]{index=3}

Example mental flow:

- `profiles.yml` gives target.schema = `dbt_ivan`
- `dbt_project.yml` sets `+schema: marts`
- dbt calls `generate_schema_name('marts', current_model)`
- result = `dbt_ivan_marts`

--------------------------------------------------

## Production-ready macro practices

Good macros should have:

- clear names
- limited responsibility
- optional argument validation
- logging if needed
- simple generated SQL

Example:

    {% macro deduplicate_latest(relation, key, order_by) %}

        {% if relation is none %}
            {{ exceptions.raise_compiler_error("relation is required") }}
        {% endif %}

        select *
        from (
            select
                *,
                row_number() over (
                    partition by {{ key }}
                    order by {{ order_by }}
                ) as rn
            from {{ relation }}
        )
        where rn = 1

    {% endmacro %}

--------------------------------------------------

## Useful built-in macros and variables

Common built-ins:

- `ref()`
- `source()`
- `this`
- `var()`
- `target`
- `is_incremental()`

These are foundational to how dbt behaves.

EOF

cat <<'EOF' > "$MODULE/learning-materials/06_dbt_incremental_models.md"
# DBT Incremental Models

## Core idea

Incremental models process only new or changed data instead of recomputing everything.

This is critical for:

- large fact tables
- frequent micro-batch jobs
- Snowflake cost control
- lower runtime

--------------------------------------------------

## Basic pattern

    {{ config(
        materialized='incremental'
    ) }}

    select *
    from {{ ref('stg_orders') }}

    {% if is_incremental() %}
    where ingested_at > (
        select coalesce(max(ingested_at), '1900-01-01'::timestamp_ntz)
        from {{ this }}
    )
    {% endif %}

How it works:

first run:
- target does not exist
- `is_incremental()` is false
- dbt creates the table from full source data

next runs:
- target exists
- `is_incremental()` is true
- only new rows are processed

--------------------------------------------------

## Why `{{ this }}` matters

`{{ this }}` refers to the current target relation being built by dbt.

Example:

    from {{ this }}

means:

- query the target table of this model
- read already processed max timestamp
- compare incoming data against that state

This is the basis of state-aware pipelines.

--------------------------------------------------

## Lookback window

A strict max-timestamp filter can lose late-arriving records.

Better pattern:

    {% if is_incremental() %}
    where ingested_at >= (
        select coalesce(
            dateadd(minute, -10, max(ingested_at)),
            '1900-01-01'::timestamp_ntz
        )
        from {{ this }}
    )
    {% endif %}

Why:

- handles delayed ingestion
- handles retry scenarios
- protects against clock and scheduling skew

--------------------------------------------------

## Incremental strategies

Common strategies include:

- merge
- append
- delete+insert

dbt Snowflake supports these incremental strategies through model configs. :contentReference[oaicite:4]{index=4}

--------------------------------------------------

## merge

Best when:

- upsert behavior is needed
- rows can be updated
- `unique_key` is stable

Example:

    {{ config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='order_id'
    ) }}

--------------------------------------------------

## append

Best when:

- source is append-only
- duplicates are handled elsewhere
- no updates are needed

Example:

    {{ config(
        materialized='incremental',
        incremental_strategy='append'
    ) }}

--------------------------------------------------

## delete+insert

Best when:

- full row replacement is acceptable
- merge is not preferred
- target row sets are manageable

Example:

    {{ config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='order_id'
    ) }}

--------------------------------------------------

## Kafka landing pattern without streams

Typical flow:

    Kafka topic
        ↓
    raw table in Snowflake
        ↓
    dbt incremental by ingested_at
        ↓
    parsed staging
        ↓
    intermediate
        ↓
    marts

This is a standard micro-batch near-real-time pattern.

--------------------------------------------------

## Snowflake stream pattern

Another pattern:

    raw table
        ↓
    Snowflake stream
        ↓
    staging table fed by stream
        ↓
    dbt incremental models

Why usually better than reading the stream directly in a complex production pipeline:

- easier to debug
- easier to replay
- easier to restart
- lower risk of consuming change tracking incorrectly

dbt docs describe CDC with Snowflake Streams as one of the important near-real-time incremental patterns. :contentReference[oaicite:5]{index=5}

--------------------------------------------------

## Initial run problem in dev

If Ivan runs an incremental model for the first time in a personal dev schema and the target table does not exist, dbt performs a full create.

That means:

- runtime can be high
- cost can be high
- large source scans may happen

Common mitigations:

- clone prod objects into dev/qa
- create shared dev tables
- add limited initial-load filters for dev

EOF

cat <<'EOF' > "$MODULE/learning-materials/07_dbt_sources_and_staging_layer.md"
# DBT Sources and Staging Layer

## What sources are

Sources represent raw tables already existing in the warehouse.

They are declared in YAML and referenced via `source()`.

Example:

    {{ source('raw', 'kafka_orders') }}

This is better than hardcoding:

    RAW_DB.RAW.kafka_orders

because it gives:

- lineage
- documentation
- centralized metadata
- source freshness checks
- reusable naming

--------------------------------------------------

## Detailed source YAML example

    version: 2

    sources:
      - name: raw
        description: Raw ingestion layer for Kafka and source systems
        database: RAW_DB
        schema: RAW
        loader: databricks
        freshness:
          warn_after: {count: 30, period: minute}
          error_after: {count: 60, period: minute}
        loaded_at_field: ingested_at

        tables:
          - name: kafka_orders
            description: Raw Kafka order events
            identifier: kafka_orders
            tags: ['kafka', 'raw']
            meta:
              owner: data-platform
              domain: sales
            columns:
              - name: ingested_at
                description: Timestamp when event landed in Snowflake
                tests:
                  - not_null

              - name: payload
                description: Raw JSON payload

              - name: topic
                description: Kafka topic name

              - name: partition
                description: Kafka partition number

              - name: offset
                description: Kafka offset

--------------------------------------------------

## Source YAML fields explained

`version`
- schema version for dbt YAML files

`sources`
- list of source groups

`name`
- logical source name used in `source()`

`description`
- docs text for dbt docs

`database`
- source database

`schema`
- source schema

`loader`
- optional metadata to indicate the ingesting system

`freshness`
- optional freshness SLA rules

`loaded_at_field`
- column used for freshness checking

`tables`
- list of actual source tables

`identifier`
- physical object name if different from YAML name

`tags`
- grouping and selection labels

`meta`
- arbitrary metadata

`columns`
- column-level docs and tests

--------------------------------------------------

## Staging layer purpose

Staging should do:

- JSON parsing
- field renaming
- type casting
- light normalization
- technical cleanup

Staging should avoid:

- heavy business joins
- broad aggregations
- final KPI logic

--------------------------------------------------

## Staging example

    select
        payload:order_id::string           as order_id,
        payload:customer_id::string        as customer_id,
        payload:amount::number(18,2)       as amount,
        payload:status::string             as order_status,
        payload:event_time::timestamp_ntz  as event_time,
        ingested_at,
        topic,
        partition,
        offset
    from {{ source('raw', 'kafka_orders') }}
    where payload is not null

--------------------------------------------------

## Why staging should stay simple

Because staging is:

- the bridge from raw to modeled data
- easier to debug if it is close to source structure
- easier to test
- easier to reuse across downstream models

EOF

cat <<'EOF' > "$MODULE/learning-materials/08_dbt_tests_and_data_quality.md"
# DBT Tests and Data Quality

## Why tests matter

dbt tests are one of the biggest reasons dbt is valuable in production.

They allow you to validate:

- uniqueness
- completeness
- referential integrity
- business rules

--------------------------------------------------

## Generic tests in YAML

Example:

    version: 2

    models:
      - name: fct_orders
        columns:
          - name: order_id
            tests:
              - not_null
              - unique

          - name: customer_id
            tests:
              - not_null
              - relationships:
                  to: ref('dim_customer')
                  field: customer_id

          - name: order_status
            tests:
              - accepted_values:
                  values: ['NEW', 'PAID', 'SHIPPED', 'CANCELLED']

--------------------------------------------------

## Important generic tests

`not_null`
- no null values allowed

`unique`
- no duplicates allowed

`relationships`
- foreign-key-like validation against another model

`accepted_values`
- only allowed values are accepted

--------------------------------------------------

## Singular tests

Singular tests are SQL files.

Example:

    select *
    from {{ ref('fct_orders') }}
    where amount < 0

If this query returns rows, the test fails.

--------------------------------------------------

## What happens when tests fail

In dbt, a test failure means:

- the SQL query ran successfully
- but it returned failing rows

This is different from a model execution error.

Result:

- `dbt test` exits with a failure code
- CI job may fail
- deployment may stop
- logs show which test failed

--------------------------------------------------

## Model run failure vs test failure

Model run failure:
- SQL itself failed
- missing column, syntax error, permission issue, etc.

Test failure:
- SQL ran, but data quality condition was violated

--------------------------------------------------

## Test configs and hierarchy

dbt supports data test configs with hierarchical precedence. Generic test instances in YAML can override generic SQL defaults, and both are more specific than `dbt_project.yml` settings. :contentReference[oaicite:6]{index=6}

--------------------------------------------------

## Where to run tests

Typical production approach:

- tests for staging and marts run in CI
- critical business tests run in deploy jobs
- lightweight tests may use a smaller Snowflake warehouse than heavy build models

Snowflake-specific config supports `snowflake_warehouse` for tests too. :contentReference[oaicite:7]{index=7}

--------------------------------------------------

## Reporting failed tests

Common approaches:

- CI pipeline fails and notifies team
- Airflow task fails and alerts
- test results are exported or stored
- dbt artifacts are parsed into monitoring tables
- Slack / Teams notifications on failed jobs

EOF

cat <<'EOF' > "$MODULE/learning-materials/09_dbt_ref_source_and_dag.md"
# DBT ref, source, selection, DAG, and selectors

## ref()

`ref()` references another dbt model.

Example:

    select *
    from {{ ref('stg_orders') }}

What it gives:

- dependency in the DAG
- correct object name resolution
- safe refactoring
- lineage

--------------------------------------------------

## source()

`source()` references an external source declared in YAML.

Example:

    select *
    from {{ source('raw', 'kafka_orders') }}

--------------------------------------------------

## DAG behavior

dbt uses `ref()` and `source()` to construct the graph.

Example:

    stg_orders
        ↓
    int_orders
        ↓
    fct_orders

`dbt build` executes this in order automatically.

--------------------------------------------------

## The `+` graph operator

The `+` operator expands selection to include ancestors or descendants of a resource. :contentReference[oaicite:8]{index=8}

Practical meaning:

`+model_name`
- include upstream dependencies

`model_name+`
- include downstream dependents

`+model_name+`
- include both upstream and downstream

Example:

    dbt build --select +fct_orders

This selects:

- all models required to build `fct_orders`
- and `fct_orders` itself

Example:

    dbt build --select fct_orders+

This selects:

- `fct_orders`
- all downstream models depending on it

Example:

    dbt build --select +fct_orders+

This selects the full neighborhood of `fct_orders` in both directions.

--------------------------------------------------

## Tags

Tags are labels attached to models, tests, sources, snapshots, and other resources. They can be configured in YAML or project config, and are selectable with node selection syntax. :contentReference[oaicite:9]{index=9}

Example in model config:

    {{ config(tags=['hourly', 'sales']) }}

Example in YAML:

    version: 2

    models:
      - name: fct_orders
        config:
          tags: ['hourly', 'sales']

Example in `dbt_project.yml`:

    models:
      my_project:
        marts:
          facts:
            +tags: ['frequent_fact']

--------------------------------------------------

## Why tags matter

Tags are used for:

- selecting subsets of models
- separating daily vs hourly jobs
- domain-based jobs
- different deployment cadences
- targeted testing

Example:

    dbt build --select tag:daily_dimension

With graph operator:

    dbt build --select tag:daily_dimension+

--------------------------------------------------

## Selectors

dbt supports named selectors in `selectors.yml`. Node selection syntax applies across commands such as `run`, `build`, `test`, and `ls`. :contentReference[oaicite:10]{index=10}

Example:

    selectors:
      - name: daily_dims
        definition:
          method: tag
          value: daily_dimension

      - name: frequent_facts
        definition:
          method: tag
          value: frequent_fact

Run:

    dbt build --selector daily_dims
    dbt build --selector frequent_facts

--------------------------------------------------

## Run by name, path, tag

By model name:

    dbt build --select fct_orders

By folder path:

    dbt build --select marts.facts

By tag:

    dbt build --select tag:hourly

By state:

    dbt build --select state:modified+

--------------------------------------------------

## Re-run patterns

Re-run one model:

    dbt build --select fct_orders

Re-run model and its children:

    dbt build --select fct_orders+

Re-run model and required upstreams:

    dbt build --select +fct_orders

Re-run everything around it:

    dbt build --select +fct_orders+

EOF

cat <<'EOF' > "$MODULE/learning-materials/10_dbt_with_snowflake_architecture.md"
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

EOF

cat <<'EOF' > "$MODULE/learning-materials/11_dbt_orchestration_ci_cd.md"
# DBT Orchestration, Deployment, CI/CD, and Monitoring

## Who should do what

Good responsibility split:

dbt:
- transformations
- tests
- docs
- lineage

Airflow:
- orchestration
- retries
- cross-system dependencies

Databricks:
- ingestion
- heavy processing
- streaming
- Spark jobs

GitHub Actions:
- CI/CD
- PR checks
- production deploy jobs

--------------------------------------------------

## dbt commands you should know

Install dependencies:

    dbt deps

Checks package installation from `packages.yml` and downloads packages into `dbt_packages`.

Check profile and connection:

    dbt debug

This validates profile resolution and warehouse connectivity.

Build everything selected:

    dbt build --select tag:hourly

`dbt build` includes run + test + seed + snapshot where relevant.

--------------------------------------------------

## How to run by tags, names, paths

By name:

    dbt build --select fct_orders

By path:

    dbt build --select marts.facts

By tag:

    dbt build --select tag:daily_dimension

By state:

    dbt build --select state:modified+

--------------------------------------------------

## What `state:modified+` means

dbt can compare current code to artifacts from a previous environment state.
Together with `--defer`, this enables Slim CI. :contentReference[oaicite:13]{index=13}

`state:modified`
- resources changed compared to prior state

`state:modified+`
- changed resources plus their downstream dependents

--------------------------------------------------

## What `--defer` means

`--defer` tells dbt to resolve unselected upstream references against an existing state, typically production, instead of rebuilding everything upstream. It requires prior artifacts such as `manifest.json`, usually passed through `--state`. :contentReference[oaicite:14]{index=14}

Typical Slim CI command:

    dbt build \
      --select state:modified+ \
      --defer \
      --state path/to/prod_artifacts

What this does:

- build only modified models and their downstreams
- use production-built upstream models for the rest
- reduce runtime and cost

When useful:
- PR validation
- large dbt projects
- expensive Snowflake environments

When to be careful:
- when changing base staging/source logic
- when major upstream contract changes are involved

--------------------------------------------------

## Real GitHub Actions example for PR validation

    name: dbt CI

    on:
      pull_request:
        branches:
          - main

    jobs:
      dbt-ci:
        runs-on: ubuntu-latest

        env:
          SNOWFLAKE_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}
          SNOWFLAKE_USER: ${{ secrets.SNOWFLAKE_USER }}
          SNOWFLAKE_PASSWORD: ${{ secrets.SNOWFLAKE_PASSWORD }}
          SNOWFLAKE_ROLE: ${{ secrets.SNOWFLAKE_ROLE }}
          SNOWFLAKE_DATABASE: ${{ secrets.SNOWFLAKE_QA_DATABASE }}
          SNOWFLAKE_WAREHOUSE: ${{ secrets.SNOWFLAKE_QA_WAREHOUSE }}
          SNOWFLAKE_SCHEMA: dbt_ci

        steps:
          - name: Checkout repository
            uses: actions/checkout@v4

          - name: Set up Python
            uses: actions/setup-python@v5
            with:
              python-version: "3.11"

          - name: Install dbt
            run: |
              pip install dbt-snowflake

          - name: Create dbt profile
            run: |
              mkdir -p ~/.dbt
              cat > ~/.dbt/profiles.yml <<EOF2
              analytics_dbt:
                target: qa
                outputs:
                  qa:
                    type: snowflake
                    account: "${SNOWFLAKE_ACCOUNT}"
                    user: "${SNOWFLAKE_USER}"
                    password: "${SNOWFLAKE_PASSWORD}"
                    role: "${SNOWFLAKE_ROLE}"
                    database: "${SNOWFLAKE_DATABASE}"
                    warehouse: "${SNOWFLAKE_WAREHOUSE}"
                    schema: "${SNOWFLAKE_SCHEMA}"
                    threads: 4
              EOF2

          - name: Install packages
            run: dbt deps

          - name: Check connection
            run: dbt debug

          - name: Build modified resources with defer
            run: |
              dbt build \
                --select state:modified+ \
                --defer \
                --state artifacts/prod

--------------------------------------------------

## Real GitHub Actions example for deploy to prod after merge

    name: dbt Production Deploy

    on:
      push:
        branches:
          - main

    jobs:
      dbt-prod:
        runs-on: ubuntu-latest

        env:
          SNOWFLAKE_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}
          SNOWFLAKE_USER: ${{ secrets.SNOWFLAKE_PROD_USER }}
          SNOWFLAKE_PASSWORD: ${{ secrets.SNOWFLAKE_PROD_PASSWORD }}
          SNOWFLAKE_ROLE: ${{ secrets.SNOWFLAKE_PROD_ROLE }}
          SNOWFLAKE_DATABASE: ${{ secrets.SNOWFLAKE_PROD_DATABASE }}
          SNOWFLAKE_WAREHOUSE: ${{ secrets.SNOWFLAKE_PROD_WAREHOUSE }}
          SNOWFLAKE_SCHEMA: analytics

        steps:
          - uses: actions/checkout@v4

          - uses: actions/setup-python@v5
            with:
              python-version: "3.11"

          - run: pip install dbt-snowflake

          - name: Create dbt profile
            run: |
              mkdir -p ~/.dbt
              cat > ~/.dbt/profiles.yml <<EOF2
              analytics_dbt:
                target: prod
                outputs:
                  prod:
                    type: snowflake
                    account: "${SNOWFLAKE_ACCOUNT}"
                    user: "${SNOWFLAKE_USER}"
                    password: "${SNOWFLAKE_PASSWORD}"
                    role: "${SNOWFLAKE_ROLE}"
                    database: "${SNOWFLAKE_DATABASE}"
                    warehouse: "${SNOWFLAKE_WAREHOUSE}"
                    schema: "${SNOWFLAKE_SCHEMA}"
                    threads: 8
              EOF2

          - run: dbt deps
          - run: dbt debug
          - run: dbt build --target prod

--------------------------------------------------

## Simple scheduled GitHub job

    name: dbt Frequent Facts

    on:
      schedule:
        - cron: "*/15 * * * *"
      workflow_dispatch:

    jobs:
      run-frequent-facts:
        runs-on: ubuntu-latest

        steps:
          - uses: actions/checkout@v4
          - uses: actions/setup-python@v5
            with:
              python-version: "3.11"
          - run: pip install dbt-snowflake
          - run: dbt deps
          - run: dbt build --select tag:frequent_fact --target prod

--------------------------------------------------

## Airflow example

    from airflow import DAG
    from airflow.operators.bash import BashOperator
    from datetime import datetime

    with DAG(
        dag_id="dbt_sales_pipeline",
        start_date=datetime(2025, 1, 1),
        schedule_interval="*/15 * * * *",
        catchup=False,
    ) as dag:

        dbt_deps = BashOperator(
            task_id="dbt_deps",
            bash_command="cd /opt/pipelines/dbt && dbt deps"
        )

        dbt_build_staging = BashOperator(
            task_id="dbt_build_staging",
            bash_command="cd /opt/pipelines/dbt && dbt build --select tag:staging --target prod"
        )

        dbt_build_facts = BashOperator(
            task_id="dbt_build_facts",
            bash_command="cd /opt/pipelines/dbt && dbt build --select tag:frequent_fact --target prod"
        )

        dbt_deps >> dbt_build_staging >> dbt_build_facts

Good use case:
- ingestion completed
- Airflow then triggers dbt
- Airflow handles retries and alerts

--------------------------------------------------

## Databricks job example

In Databricks Workflows, a Python task can invoke dbt CLI if the environment has dbt installed.

    import subprocess

    commands = [
        "dbt deps",
        "dbt debug --target prod",
        "dbt build --select tag:frequent_fact --target prod"
    ]

    for cmd in commands:
        result = subprocess.run(
            cmd,
            shell=True,
            check=False,
            capture_output=True,
            text=True
        )
        print(result.stdout)
        print(result.stderr)

        if result.returncode != 0:
            raise RuntimeError(f"Command failed: {cmd}")

Better use case:
- Databricks does ingestion / PySpark work
- then invokes dbt as the warehouse transformation layer

--------------------------------------------------

## Where to see execution results

Local / CI:

- terminal output
- `logs/dbt.log`
- `target/run_results.json`
- `target/manifest.json`

Compiled SQL:

- `target/compiled/`
- `target/run/`

These are essential for debugging.

--------------------------------------------------

## How to see lineage graph without dbt Cloud

Use dbt docs:

    dbt docs generate
    dbt docs serve

dbt docs commands generate documentation artifacts and a local browsable site. Even when compilation is skipped in some cases, special macros such as `generate_schema_name` are still part of parsing behavior. :contentReference[oaicite:15]{index=15}

What you get:
- model descriptions
- column docs
- lineage graph
- test info
- source-to-model dependencies

This is the standard local alternative to dbt Cloud graph browsing.

--------------------------------------------------

## Reporting and monitoring job success/failure

Common real-world patterns:

1. CI/CD status
- GitHub Actions shows passed / failed jobs
- PR checks block merge if failing

2. Airflow UI
- task success / fail history
- retries
- execution duration
- logs

3. Databricks Jobs / Workflows UI
- run history
- task logs
- alerting

4. dbt artifacts
- parse `run_results.json`
- parse `manifest.json`
- store in monitoring tables

5. Notifications
- Slack / Teams alerts on failed jobs
- email alerts on DAG failures

--------------------------------------------------

## Recommended reporting setup

Good production setup:

- GitHub Actions for CI status and deploy status
- Airflow or Databricks Workflows for orchestration status
- dbt docs for lineage and docs
- artifacts loaded into a small ops mart for historical reporting

EOF

cat <<'EOF' > "$MODULE/learning-materials/12_dbt_performance_and_cost_optimization.md"
# DBT Performance and Cost Optimization

## Why this matters

In Snowflake-based platforms, poor dbt design can become expensive very quickly.

Main cost drivers:

- full refresh on large tables
- oversized warehouses
- rebuilding too much of the DAG
- poor incremental strategy
- unnecessary wide scans

--------------------------------------------------

## Performance topics that matter most

1. model materialization choice
2. incremental design
3. warehouse sizing
4. DAG selection strategy
5. upstream/downstream rebuild scope
6. test execution footprint

--------------------------------------------------

## Use incremental where it makes sense

Especially for:

- event facts
- time-series data
- append-heavy raw landing patterns

Prefer:

- `merge` for upserts
- lookback windows for late-arriving rows
- narrower source reads

--------------------------------------------------

## Avoid rebuilding the whole graph unnecessarily

For dev and CI:

    dbt build --select state:modified+ --defer --state path/to/prod_artifacts

This is one of the biggest cost savers in larger projects. :contentReference[oaicite:16]{index=16}

--------------------------------------------------

## Warehouse sizing strategy

Recommended pattern:

- small warehouse for staging and tests
- medium for intermediate
- large for heavy facts
- XL only for backfill and exceptional workloads

Trade-off:

small warehouse:
- cheaper
- slower

large warehouse:
- faster
- more expensive

NFR should be defined as SLA, not "everything must be fast."

Example:
- hourly fact refresh SLA = 10 minutes
- daily full build SLA = 90 minutes

--------------------------------------------------

## Different jobs can have different expected runtimes

This is normal.

Examples:

fast jobs:
- staging refresh
- 1 to 10 minutes

medium jobs:
- dimensions
- 10 to 30 minutes

heavy jobs:
- full facts / backfills
- 30 to 120 minutes or more

The key question is:
does the job meet its SLA?

--------------------------------------------------

## How to debug performance problems

In dbt:
- inspect compiled SQL
- inspect model materialization
- inspect graph selection
- inspect incremental filter logic

In Snowflake:
- check query history
- inspect execution profile
- evaluate scan volume
- review warehouse size and concurrency

--------------------------------------------------

## Common optimization patterns

- use incremental instead of table rebuild
- use lookback window instead of full refresh
- avoid giant all-in-one models
- keep staging simple
- persist heavy reused logic as tables
- isolate heavy jobs into separate warehouses
- use tags and selectors to avoid unnecessary runs

--------------------------------------------------

## Final rule

Good dbt optimization is not about "always faster."
It is about:

- correct runtime for the SLA
- acceptable cost
- reliable data quality
- maintainable architecture

EOF

log "Detailed DBT learning materials created successfully."
