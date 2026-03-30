# Requirements

## Functional Requirements

- MinIO must expose an S3-compatible bucket for the warehouse
- Spark must create at least one Iceberg table
- the user must complete one `CREATE TABLE`, `INSERT`, and `SELECT`
- the user must see both metadata and data files in MinIO

## Package Baseline

This project pins the Spark package line to:

- `org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.10.1`
- `org.apache.iceberg:iceberg-aws-bundle:1.10.1`

No Nessie extensions are required here.

## Operational Guidance

- prefer one active writer while learning
- do not treat this as a production-safe multi-user control plane
- expect the first package download to be slow on Raspberry Pi

## Compatibility Warning

Verify your chosen images support `arm64`.

If not, replace the image choice while keeping the same Spark 3.5 line and the same package coordinates.