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

