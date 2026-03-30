# 02 Spark Glue And First Writes Solution

## Task 1 - Configure Spark For Glue Catalog

```python
spark = (
    SparkSession.builder
    .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions")
    .config("spark.sql.catalog.glue_prod", "org.apache.iceberg.spark.SparkCatalog")
    .config("spark.sql.catalog.glue_prod.type", "glue")
    .config("spark.sql.catalog.glue_prod.warehouse", "s3://company-lakehouse/warehouse")
    .config("spark.sql.catalog.glue_prod.io-impl", "org.apache.iceberg.aws.s3.S3FileIO")
    .getOrCreate()
)
```

Key point: after `CREATE TABLE`, Glue stores the catalog entry while S3 stores data and metadata files.

## Task 2 - Create A First Iceberg Table Through Glue

```sql
CREATE NAMESPACE IF NOT EXISTS glue_prod.analytics;

CREATE TABLE IF NOT EXISTS glue_prod.analytics.orders (
  order_id BIGINT,
  customer_id BIGINT,
  order_ts TIMESTAMP,
  amount DECIMAL(18,2)
)
USING iceberg
PARTITIONED BY (days(order_ts))
TBLPROPERTIES (
  'format-version'='2'
);
```

Key point: Spark is issuing the SQL, but because the configured catalog is `glue_prod`, the table is registered through Glue.

## Task 3 - Choose Append Versus Overwrite Partitions

Scenario A: append.

- new day means new fact slice

Scenario B: partition-scoped overwrite or explicit delete-and-reload for that day.

- corrected day should not risk touching unrelated partitions

Warning: broad overwrite can accidentally rewrite or remove unrelated table state, especially on shared production tables.

## Task 4 - Write A Batch Append Job

```python
source_df = spark.read.parquet("s3://raw-company/orders/dt=2026-03-27/")

clean_df = (
    source_df
    .select("order_id", "customer_id", "order_ts", "amount")
    .filter("order_id IS NOT NULL")
)

clean_df.writeTo("glue_prod.analytics.orders").append()
```

Key point: this is the standard safe shape for append-heavy ingestion.

## Task 5 - Read A Table By Snapshot

```python
historical_df = (
    spark.read
    .option("snapshot-id", 918273645546372819)
    .table("glue_prod.analytics.orders")
)
```

Useful reason: compare current output versus an earlier technical table state during debugging after an unexpected mutation.

## Task 6 - Run A Small-File Maintenance Action

```sql
CALL glue_prod.system.rewrite_data_files(
  table => 'analytics.orders'
);
```

Key point: compaction changes physical layout and scan efficiency, not business meaning.