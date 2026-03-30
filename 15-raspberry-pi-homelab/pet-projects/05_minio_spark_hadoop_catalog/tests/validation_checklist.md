# Validation Checklist

## Minimum Success Conditions

- MinIO UI is reachable
- Spark container is reachable
- bucket exists in MinIO
- `spark-sql` starts without missing class errors
- `CREATE TABLE` succeeds
- `INSERT` succeeds
- `SELECT` returns rows
- MinIO contains both metadata files and parquet files

## Architecture Checks

- table resolution works through Spark catalog config
- no Nessie or separate catalog service is involved
- the user understands this is a file-based catalog pattern

## Failure Hints

If it fails, inspect first:

1. image architecture support on Raspberry Pi
2. MinIO endpoint and path-style configuration
3. Spark package compatibility with Spark and Scala version
4. whether the bucket was created by `minio-init`