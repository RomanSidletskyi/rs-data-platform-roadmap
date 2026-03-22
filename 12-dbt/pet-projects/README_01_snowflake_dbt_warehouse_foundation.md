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

