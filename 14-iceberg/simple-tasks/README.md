# Iceberg Simple Tasks

These tasks convert the theory module into short, architecture-aware practice.

The goal is not only to write valid Spark SQL or Iceberg DDL.

The goal is also to learn how to:

- inspect a table as metadata state
- reason about `v1` versus `v2`
- configure Spark with Glue catalog correctly
- choose between append, overwrite, `MERGE`, and delete-aware patterns
- separate fact upserts from dimension history modeling

## Recommended Order

1. `01_iceberg_metadata_and_table_state`
2. `02_spark_glue_and_first_writes`
3. `03_merge_cdc_and_modeling_patterns`
4. `04_schema_partition_and_compatibility`
5. `05_branching_retention_and_governance`
6. `06_troubleshooting_and_failure_modes`
7. `07_maintenance_cost_and_cleanup`

## Study Rule

Do not treat these as syntax drills.

For every answer, make the table contract explicit:

- what is the grain
- what is the current-state rule
- what is the history rule
- what engine and catalog assumptions are being made