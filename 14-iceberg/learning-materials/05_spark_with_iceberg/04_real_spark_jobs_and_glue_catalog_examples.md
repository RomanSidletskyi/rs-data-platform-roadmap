# Real Spark Jobs And Glue Catalog Examples

## 1. Why This Chapter Exists

A lot of Iceberg content stops at:

- `CREATE TABLE ... USING iceberg`

That is not enough.

Real platform work needs:

- repeatable `spark-submit` setup
- Glue catalog configuration patterns
- append and overwrite jobs
- maintenance jobs
- a sense of where job semantics become dangerous

## 2. Baseline Spark Submit For Glue Catalog On AWS

Representative `spark-submit` command:

```bash
spark-submit \
  --packages org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.10.1,org.apache.iceberg:iceberg-aws-bundle:1.10.1 \
  --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
  --conf spark.sql.catalog.glue_prod=org.apache.iceberg.spark.SparkCatalog \
  --conf spark.sql.catalog.glue_prod.type=glue \
  --conf spark.sql.catalog.glue_prod.warehouse=s3://company-lakehouse/warehouse \
  --conf spark.sql.catalog.glue_prod.io-impl=org.apache.iceberg.aws.s3.S3FileIO \
  --conf spark.sql.defaultCatalog=glue_prod \
  jobs/orders_batch_load.py
```

This gives you:

- Iceberg runtime
- AWS integration bundle
- SQL extensions for Iceberg procedures
- a named Glue catalog in Spark

## 3. Minimal SparkSession In PySpark

```python
from pyspark.sql import SparkSession


spark = (
    SparkSession.builder
    .appName("orders-batch-load")
    .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions")
    .config("spark.sql.catalog.glue_prod", "org.apache.iceberg.spark.SparkCatalog")
    .config("spark.sql.catalog.glue_prod.type", "glue")
    .config("spark.sql.catalog.glue_prod.warehouse", "s3://company-lakehouse/warehouse")
    .config("spark.sql.catalog.glue_prod.io-impl", "org.apache.iceberg.aws.s3.S3FileIO")
    .getOrCreate()
)
```

## 4. Create A Namespace And Table In Glue Catalog

Yes, Spark can create Iceberg tables through Glue catalog directly.

The important idea is:

- Spark is the engine issuing `CREATE TABLE`
- Glue is the catalog in which the table is registered
- S3 holds the actual data and metadata files

So when you run `CREATE TABLE glue_prod.analytics.orders ... USING iceberg`, Spark is not bypassing Glue.

Spark is using the configured Glue-backed Iceberg catalog as the metadata authority.

```python
spark.sql("CREATE NAMESPACE IF NOT EXISTS glue_prod.analytics")

spark.sql(
    """
    CREATE TABLE IF NOT EXISTS glue_prod.analytics.orders (
      order_id BIGINT,
      customer_id STRING,
      order_ts TIMESTAMP,
      order_date DATE,
      amount DECIMAL(18,2),
      status STRING
    )
    USING iceberg
    PARTITIONED BY (days(order_ts), status)
    TBLPROPERTIES (
      'format-version'='2',
      'write.format.default'='parquet',
      'write.target-file-size-bytes'='536870912'
    )
    """
)
```

This is already more production-shaped than a toy example because it makes explicit:

- namespace
- table properties
- partition transforms
- format version choice

## 4A. The Same Point In One Sentence

If `spark.sql.catalog.glue_prod.type=glue` is configured, then:

- `CREATE TABLE glue_prod.analytics.orders ... USING iceberg`

means Spark creates the Iceberg table through Glue catalog.

Representative SQL form:

```sql
CREATE NAMESPACE IF NOT EXISTS glue_prod.analytics;

CREATE TABLE glue_prod.analytics.orders (
  order_id BIGINT,
  order_ts TIMESTAMP,
  amount DECIMAL(18,2)
)
USING iceberg
PARTITIONED BY (days(order_ts));
```

After that:

- Glue stores the catalog entry
- S3 stores `metadata.json`, manifest list, manifests, and data files
- Spark and other supported engines can resolve the table through Glue

## 5. Batch Append Job

```python
source_df = spark.read.parquet("s3://raw-company/orders/dt=2026-03-27/")

clean_df = (
    source_df
    .select(
        "order_id",
        "customer_id",
        "order_ts",
        "order_date",
        "amount",
        "status",
    )
    .filter("order_id IS NOT NULL")
)

clean_df.writeTo("glue_prod.analytics.orders").append()
```

This is the safest standard write shape for append-heavy ingestion.

## 6. Daily Partition Refresh Job

If the pipeline re-computes a day, make the overwrite scope explicit.

```python
daily_df = (
    spark.read.parquet("s3://curated-staging/orders/dt=2026-03-27/")
    .filter("order_date = DATE '2026-03-27'")
)

spark.sql("DELETE FROM glue_prod.analytics.orders WHERE order_date = DATE '2026-03-27'")
daily_df.writeTo("glue_prod.analytics.orders").append()
```

Alternative overwrite pattern when the write model is partition-aligned:

```python
daily_df.writeTo("glue_prod.analytics.orders").overwritePartitions()
```

Architect warning:

- never hide overwrite scope
- never use broad overwrite semantics casually on a shared production table

## 7. Merge-Like Upsert With Spark SQL

Representative pattern:

```sql
MERGE INTO glue_prod.analytics.orders AS target
USING glue_prod.analytics.orders_stage AS source
ON target.order_id = source.order_id
WHEN MATCHED THEN UPDATE SET
  target.customer_id = source.customer_id,
  target.order_ts = source.order_ts,
  target.order_date = source.order_date,
  target.amount = source.amount,
  target.status = source.status
WHEN NOT MATCHED THEN INSERT *;
```

This is exactly where format version and engine support start to matter more.

Mutation-heavy platforms should not assume every engine will behave equally here.

## 8. Read With Time Travel

```python
old_snapshot_df = (
    spark.read
    .option("snapshot-id", 918273645546372819)
    .table("glue_prod.analytics.orders")
)
```

Or by timestamp:

```python
historical_df = (
    spark.read
    .option("as-of-timestamp", 1774579200000)
    .table("glue_prod.analytics.orders")
)
```

## 9. Maintenance Job: Rewrite Small Files

Representative SQL procedure:

```python
spark.sql(
    """
    CALL glue_prod.system.rewrite_data_files(
      table => 'analytics.orders'
    )
    """
)
```

Representative orchestrated maintenance job:

```python
def compact_table(table_name: str) -> None:
    spark.sql(
        f"""
        CALL glue_prod.system.rewrite_data_files(
          table => '{table_name}'
        )
        """
    )


def expire_old_snapshots(table_name: str) -> None:
    spark.sql(
        f"""
        CALL glue_prod.system.expire_snapshots(
          table => '{table_name}',
          older_than => TIMESTAMP '2026-03-20 00:00:00'
        )
        """
    )


compact_table("analytics.orders")
expire_old_snapshots("analytics.orders")
```

## 10. Glue Catalog With Cross-Account Access

Representative configuration pattern when the compute account is different from the catalog account:

```bash
spark-submit \
  --packages org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.10.1,org.apache.iceberg:iceberg-aws-bundle:1.10.1 \
  --conf spark.sql.catalog.glue_prod=org.apache.iceberg.spark.SparkCatalog \
  --conf spark.sql.catalog.glue_prod.type=glue \
  --conf spark.sql.catalog.glue_prod.warehouse=s3://central-lakehouse/warehouse \
  --conf spark.sql.catalog.glue_prod.io-impl=org.apache.iceberg.aws.s3.S3FileIO \
  --conf spark.sql.catalog.glue_prod.client.factory=org.apache.iceberg.aws.AssumeRoleAwsClientFactory \
  --conf spark.sql.catalog.glue_prod.client.assume-role.arn=arn:aws:iam::123456789012:role/lakehouse-shared-role \
  --conf spark.sql.catalog.glue_prod.client.assume-role.region=eu-central-1 \
  jobs/orders_batch_load.py
```

That is the real-world shape for centralized platform control.

## 11. Glue Catalog Operational Notes

Useful practical points:

- Glue namespace maps to Glue Database
- Iceberg table maps to Glue Table
- Glue optimistic locking matters for concurrent updates
- warehouse root and explicit table locations should be designed deliberately

Representative SQL with explicit table location:

```sql
CREATE TABLE glue_prod.analytics.orders_special (
  order_id BIGINT,
  order_ts TIMESTAMP,
  amount DECIMAL(18,2)
)
USING iceberg
LOCATION 's3://special-domain-bucket/iceberg/orders_special';
```

## 12. S3 Layout-Oriented Table Properties

Representative AWS-oriented table creation:

```sql
CREATE TABLE glue_prod.analytics.events (
  event_id STRING,
  event_ts TIMESTAMP,
  event_type STRING,
  payload STRING
)
USING iceberg
PARTITIONED BY (days(event_ts), event_type)
TBLPROPERTIES (
  'write.object-storage.enabled'='true',
  'write.data.path'='s3://lakehouse-data/analytics/events',
  'write.target-file-size-bytes'='536870912'
);
```

This is useful on S3 because object-store-friendly layout can matter for scale and maintenance.

## 13. Job Shapes A Platform Usually Needs

In a real AWS Iceberg platform, you usually want at least these Spark job types:

1. append ingestion job
2. scoped daily refresh job
3. dedup or merge job
4. compaction job
5. snapshot retention job

If the platform has only append jobs and no maintenance jobs, it is incomplete.

## 14. The Main Mistakes To Avoid

Common mistakes:

- using Glue as if it were only a checkbox and not a control-plane decision
- letting each team invent its own `spark.sql.catalog.*` naming scheme
- overusing wide overwrites
- ignoring compaction and snapshot expiration
- assuming Athena and Spark write capabilities are interchangeable

## 15. Architect Rule

The correct standard is not just:

- can Spark write to Iceberg on AWS

The correct standard is:

- do we have one repeatable writer contract for Spark, one clear Glue catalog contract, and one maintenance contract for keeping the tables healthy