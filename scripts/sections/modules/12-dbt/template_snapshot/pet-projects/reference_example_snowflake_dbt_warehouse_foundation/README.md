# Reference Example - Snowflake dbt Warehouse Foundation

This folder contains a ready reference implementation for the guided project:

- `12-dbt/pet-projects/01_snowflake_dbt_warehouse_foundation`

Use it only after attempting the guided version yourself.

## What This Reference Example Demonstrates

- source YAML and model YAML with realistic descriptions
- a clean staged warehouse graph: staging → intermediate → marts
- one custom schema-generation macro
- one incremental fact model with a small lookback window
- one singular business-rule test

## Folder Overview

- `config/README.md` points to shared dbt config templates under `shared/configs/templates/dbt/`
- `data/raw_contract_notes.md` documents the raw warehouse contract
- `src/models/` contains source, staging, intermediate, and mart examples
- `src/macros/README.md` points to the shared macro under `shared/templates/dbt/macros/`
- `tests/assert_no_negative_order_amounts.sql` demonstrates a singular quality gate

## Reference Flow

The example follows this shape:

    raw.orders -> stg_orders -> int_orders_enriched -> fct_orders
                                     |
                                     -> dim_customer

## Why This Is A Good Reference Shape

- the layering is easy to read
- marts stay business-facing
- incremental logic is explicit but still simple
- configuration and modeling concerns stay separate

## How To Compare With Your Own Solution

When comparing your implementation with this reference example, focus on:

- whether your staging layer is clean and thin
- whether shared business logic is isolated from marts
- whether your fact incremental logic is defensible
- whether docs and tests explain the project, not just satisfy syntax
