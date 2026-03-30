# Requirements

## Functional Requirements

- MinIO must expose an S3-compatible bucket for warehouse storage
- Spark must be able to create Iceberg tables
- Nessie must be reachable as catalog service from Spark
- the user must be able to run at least one `CREATE TABLE`, `INSERT`, and `SELECT`

## Non-Functional Requirements

- keep secrets out of committed files
- keep the stack simple enough for Raspberry Pi homelab use
- prefer explicit configuration over hidden defaults
- document the limits of the stack clearly

## Compatibility Warning

On Raspberry Pi, verify that your chosen images are available for `arm64` before relying on them.

If a specific image does not support your Pi architecture, keep the architecture pattern and replace only the image choice.

## Package Compatibility Baseline

This project uses the following Spark package line:

- `org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.10.1`
- `org.apache.iceberg:iceberg-aws-bundle:1.10.1`
- `org.projectnessie.nessie-integrations:nessie-spark-extensions-3.5_2.12:0.104.5`

Reasoning:

- Iceberg documentation shows `1.10.1` as the current Spark 3.5 runtime line
- Nessie documentation shows `0.104.5` as the matching Spark 3.5 extension line for Iceberg `1.10.1`
- Spark 3.5 on the common container distributions is typically Scala `2.12`

## Operational Constraints

- treat this as a single-node learning stack
- prefer one active writer while learning
- expect slower startup because Spark resolves Maven packages on first use
- keep warehouse data on persistent MinIO storage if you want state to survive container restarts

## When To Use This Variant

Use this project when you explicitly want to learn:

- catalog versus storage separation
- Nessie branches and references
- git-like table governance ideas
- a more realistic control-plane pattern than pure file-based catalogs

If you want the smallest possible first lab, use the separate HadoopCatalog project in `05_minio_spark_hadoop_catalog`.