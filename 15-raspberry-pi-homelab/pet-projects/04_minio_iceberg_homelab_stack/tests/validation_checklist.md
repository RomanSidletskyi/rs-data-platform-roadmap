# Validation Checklist

## Minimum Success Conditions

- MinIO UI is reachable
- Nessie API port responds
- Spark container is reachable
- bucket exists in MinIO
- `spark-sql` starts without missing package class errors
- `CREATE TABLE` succeeds
- `INSERT` succeeds
- `SELECT` returns rows
- `LIST REFERENCES IN lab` succeeds
- MinIO contains Iceberg metadata files, not only parquet files

## Architecture Checks

- storage, catalog, and engine roles are all visible
- table resolution clearly goes through catalog, not direct file reads
- homelab limits are documented

## Failure Hints

If it fails, inspect first:

1. image architecture support on Raspberry Pi
2. MinIO endpoint and path-style configuration
3. Spark package compatibility with Spark and Scala version
4. Nessie endpoint resolution inside compose network

## Good Signs During Startup

- first `spark-sql` run downloads Maven dependencies and then becomes reusable
- `org.apache.iceberg.nessie.NessieCatalog` resolves without classpath errors
- `SHOW REFERENCE IN lab` returns `main`

## Escalation Rule

If this stack is too heavy or too noisy on your Raspberry Pi, switch to `05_minio_spark_hadoop_catalog` first.

That is the correct fallback path, not a downgrade in learning quality.