# Iceberg Pet Projects

These projects move beyond isolated tasks into guided platform design work.

The goal is not only to write a few Iceberg statements.

The goal is to build end-to-end designs that make the learner choose:

- catalog model
- storage layout
- ingestion pattern
- consumer contract
- maintenance and governance boundaries

## Project Pattern

This folder follows the same learning pattern used in mature modules like `11-airflow`.

There are two project types:

- guided projects with numbered prefixes like `01_`, `02_`, `03_`
- sibling solved references with `reference_example_` prefixes

Guided projects are the default study path.

Reference examples exist for self-checking after you attempt the guided version.

## Recommended Order

1. `01_spark_glue_orders_lakehouse`
2. `02_minio_nessie_branching_lab`
3. `03_cdc_merge_and_history_platform`
4. `04_multi_engine_open_table_design`

## Reference Examples

Attempt the guided project first, then compare with the reference example.

Current reference examples:

1. `reference_example_spark_glue_orders_lakehouse`
2. `reference_example_minio_nessie_branching_lab`

## Study Rule

Treat each project like a platform design review.

The final output should make clear:

- what the business contract is
- what the compute and catalog responsibilities are
- what can evolve safely and what requires versioned publish change

## Expected Output Standard

Each finished project should answer at least these questions:

- why this catalog model fits the platform
- why raw, curated, and serving boundaries are drawn this way
- where append-only is enough and where row-level mutation is required
- how another engine reads the same tables safely
- what maintenance and retention work is mandatory