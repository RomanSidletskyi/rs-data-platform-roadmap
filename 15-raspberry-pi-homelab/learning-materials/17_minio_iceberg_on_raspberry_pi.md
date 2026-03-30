# MinIO And Iceberg On Raspberry Pi

## Goal

Explain how to use a Raspberry Pi with MinIO as a real lab environment for Iceberg tables.

The key point is:

- MinIO can be your object storage layer
- but MinIO alone is not enough to make Iceberg tables exist

You still need:

- one compute engine
- one catalog model

## 1. The Minimal Iceberg Architecture

For Iceberg you need three layers:

1. object storage
2. catalog
3. compute engine

In a Raspberry Pi homelab, that can become:

1. `MinIO`
2. `HadoopCatalog` or `Nessie`
3. `Spark`

## 2. What MinIO Actually Does

MinIO stores:

- `metadata.json`
- manifest lists
- manifests
- parquet data files
- delete files

MinIO does not decide which snapshot is current.

That is the catalog and engine side of the system.

## 3. Best First Lab Option

If your goal is to learn fast with minimum moving parts, start with:

- `MinIO`
- `Spark`
- `HadoopCatalog`

Why this is a good first option:

- simplest mental model
- fewer services to debug
- enough to create real Iceberg metadata and data artifacts
- enough to inspect table internals in object storage

## 4. More Realistic Control-Plane Option

If your goal is to learn architecture closer to real multi-engine lakehouse design, use:

- `MinIO`
- `Spark`
- `Nessie`

Why this is stronger architecturally:

- explicit catalog service
- branch and tag concepts
- better separation between storage and metadata control plane

## 5. What Works Well On Raspberry Pi

Good homelab use cases:

- small Spark batch writes
- basic Iceberg table creation
- metadata inspection
- time travel demos
- small CDC and merge experiments

## 6. What Does Not Fit Well On Raspberry Pi

Weak fit:

- heavy compaction jobs
- large merge-heavy production-style tables
- many concurrent writers
- large-scale multi-user analytics

Raspberry Pi is a learning host, not a serious production lakehouse node.

## 7. Direct Quickstart: Spark Plus MinIO Plus HadoopCatalog

This is the shortest real setup.

Assumptions:

- MinIO endpoint: `http://raspberrypi.local:9000`
- bucket: `iceberg-warehouse`
- Spark is available on the machine where you run jobs

Representative Spark SQL launch:

```bash
spark-sql \
  --packages org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.10.1,org.apache.iceberg:iceberg-aws-bundle:1.10.1 \
  --conf spark.sql.catalog.lab=org.apache.iceberg.spark.SparkCatalog \
  --conf spark.sql.catalog.lab.type=hadoop \
  --conf spark.sql.catalog.lab.warehouse=s3://iceberg-warehouse/warehouse \
  --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
  --conf spark.hadoop.fs.s3a.endpoint=http://raspberrypi.local:9000 \
  --conf spark.hadoop.fs.s3a.access.key=minioadmin \
  --conf spark.hadoop.fs.s3a.secret.key=minioadmin \
  --conf spark.hadoop.fs.s3a.path.style.access=true \
  --conf spark.hadoop.fs.s3a.connection.ssl.enabled=false
```

Representative first table:

```sql
CREATE TABLE lab.db.orders (
  order_id BIGINT,
  customer_id BIGINT,
  order_ts TIMESTAMP,
  amount DECIMAL(18,2)
)
USING iceberg
PARTITIONED BY (days(order_ts));

INSERT INTO lab.db.orders VALUES
  (1, 101, TIMESTAMP '2026-03-27 10:00:00', 25.50),
  (2, 102, TIMESTAMP '2026-03-27 11:00:00', 40.00);
```

After that, MinIO should contain real Iceberg table artifacts.

## 8. What You Should See In MinIO

Inside the warehouse path you should see things like:

- `metadata/000001-....metadata.json`
- `metadata/snap-....avro`
- `metadata/manifest-....avro`
- `data/*.parquet`

If you only see parquet files and no metadata tree, you do not have a real Iceberg table yet.

## 9. Recommended Next Step For Homelab

After the HadoopCatalog path works, move to a cataloged stack with:

- `MinIO`
- `Nessie`
- `Spark`

That is the better path if you want to learn:

- control plane separation
- catalog refs
- branch and tag ideas
- multi-engine mindset

## 10. Practical Warning

Even if MinIO is S3-compatible, not every engine/runtime behaves identically in a small homelab.

So always validate:

- object-store endpoint config
- path-style access
- SSL settings
- engine compatibility with your chosen catalog mode

## 11. Architect Rule

MinIO can absolutely back real Iceberg tables in a homelab.

But the real Iceberg system is still storage plus catalog plus engine, not storage alone.