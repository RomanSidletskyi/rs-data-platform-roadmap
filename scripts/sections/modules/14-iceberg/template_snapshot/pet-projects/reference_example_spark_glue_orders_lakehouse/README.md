# Reference Example - Spark Glue Orders Lakehouse

This folder contains a ready reference example for the guided project:

- `01_spark_glue_orders_lakehouse`

Its purpose is:

- self-checking after attempting the guided project
- showing a concrete AWS-oriented Iceberg design with explicit table roles
- preserving a reusable pattern for raw history, current state, and Type 2 history

## What This Reference Example Demonstrates

- Glue as the metadata control plane
- Spark as the main writer
- separate raw, curated fact, and historical dimension tables
- explicit merge boundaries
- maintenance and retention as part of platform design

## Folder Overview

- `.env.example` for runtime assumptions
- `architecture.md` for the target table and responsibility model
- `contract.md` for serving contracts by table
- `config/runtime_config.json` for a runnable local configuration example
- `src/ddl.md` for table definitions and example procedures
- `src/pipeline_flow.md` for raw-to-curated flow notes
- `src/reference_job_shapes.py` for concrete Spark job-shape helpers
- `src/merge_statements.sql` for representative merge SQL
- `data/sample_orders_cdc.jsonl` for example CDC input
- `tests/contract_checks.md` for contract and operational review points
- `tests/test_runtime_config.py` for lightweight config validation
- `docker/requirements.txt` for local Python validation dependency note
- `config/catalog_setup.md` for Spark plus Glue catalog setup

## Reference Flow

The platform follows this shape:

    source files -> raw append-only events -> curated current-state orders -> customer Type 2 history -> read engines

## How To Compare With Your Own Solution

When comparing this reference example with your own implementation, focus on:

- whether raw, serving, and history roles are separated clearly
- whether Glue is treated as a real control plane dependency
- whether merge-heavy tables have explicit maintenance expectations
- whether the design reads like a platform review instead of a feature list