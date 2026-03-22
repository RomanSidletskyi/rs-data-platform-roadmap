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

