# Validation Checklist

## Minimum Success Conditions

- MinIO UI is reachable
- Spark container is reachable
- `iceberg-warehouse` bucket exists
- `spark-sql` starts without Iceberg classpath errors
- `CREATE NAMESPACE` succeeds
- `CREATE TABLE` succeeds
- `INSERT` succeeds
- `SELECT` returns rows from `lab.analytics.raw_order_events`
- MinIO contains metadata and data files for the table

## Architecture Checks

- local lab clearly approximates S3 + Glue rather than pretending to replace them
- raw event table remains append-only in the local walkthrough
- table path and namespace layout are visible and explainable
- the learner can explain what would change when moving from HadoopCatalog to Glue

## Failure Hints

If the lab fails, inspect first:

1. Spark and Iceberg package compatibility
2. MinIO endpoint and path-style access settings
3. whether the bucket was created by `minio-init`
4. whether the Spark config file was mounted correctly