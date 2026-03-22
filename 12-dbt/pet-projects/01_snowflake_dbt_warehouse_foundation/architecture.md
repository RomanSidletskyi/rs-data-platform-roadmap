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

