# Spark Catalog Configuration And APIs

## 1. Catalog Configuration Is The First Real Setup Step

Spark needs to know how to resolve Iceberg tables.

That means configuring:

- the catalog name
- the catalog type or implementation
- the warehouse or metadata location details
- the underlying storage and optional cloud auth

Representative shape:

```python
spark = (
    SparkSession.builder
    .appName("iceberg-demo")
    .config("spark.sql.catalog.demo", "org.apache.iceberg.spark.SparkCatalog")
    .config("spark.sql.catalog.demo.type", "glue")
    .config("spark.sql.catalog.demo.warehouse", "s3://company-lakehouse/")
    .config("spark.sql.catalog.demo.io-impl", "org.apache.iceberg.aws.s3.S3FileIO")
    .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions")
    .getOrCreate()
)
```

Representative `spark-submit` shape for AWS Glue catalog:

```bash
spark-submit \
  --packages org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.10.1,org.apache.iceberg:iceberg-aws-bundle:1.10.1 \
  --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
  --conf spark.sql.catalog.demo=org.apache.iceberg.spark.SparkCatalog \
  --conf spark.sql.catalog.demo.type=glue \
  --conf spark.sql.catalog.demo.warehouse=s3://company-lakehouse/warehouse \
  --conf spark.sql.catalog.demo.io-impl=org.apache.iceberg.aws.s3.S3FileIO \
  jobs/iceberg_batch_upsert.py
```

This is the point many teams miss:

- the catalog is not only a lookup string
- the catalog configuration defines the writer control plane
- the wrong catalog setup means the table may be technically reachable but operationally weak

## 2. SQL And DataFrame API

Spark can work with Iceberg through SQL and DataFrame flows.

Representative SQL:

```sql
CREATE TABLE demo.sales.orders (
  order_id BIGINT,
  customer_id STRING,
  order_ts TIMESTAMP,
  amount DECIMAL(18,2)
)
USING iceberg
PARTITIONED BY (days(order_ts));
```

Representative DataFrame write:

```python
df.writeTo("demo.sales.orders").append()
```

Representative DataFrame overwrite by filter-aligned partition scope:

```python
daily_df.writeTo("demo.sales.orders").overwritePartitions()
```

Representative read with time travel:

```python
historical_df = (
    spark.read
    .option("snapshot-id", 918273645546372819)
    .table("demo.sales.orders")
)
```

Representative SQL maintenance call:

```sql
CALL demo.system.rewrite_data_files(
  table => 'sales.orders'
);
```

Representative session-catalog replacement pattern:

```properties
spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog
spark.sql.catalog.spark_catalog.type=hive
```

## 3. Why API Choice Matters

API choice matters because teams often hide table semantics inside framework wrappers.

That can become dangerous if engineers stop understanding:

- overwrite boundaries
- evolution behavior
- commit consequences
- isolation semantics on overwrite jobs
- whether they are using DSv2 operations or weaker compatibility paths

## 4. Real Catalog Patterns You Should Recognize

### Glue Catalog

Typical when:

- storage is in S3
- Glue is already the metadata authority on AWS
- Athena, EMR, Glue jobs, or Redshift need the same catalog surface

Representative configuration:

```properties
spark.sql.catalog.glue_prod=org.apache.iceberg.spark.SparkCatalog
spark.sql.catalog.glue_prod.type=glue
spark.sql.catalog.glue_prod.warehouse=s3://company-lakehouse/warehouse
spark.sql.catalog.glue_prod.io-impl=org.apache.iceberg.aws.s3.S3FileIO
spark.sql.catalog.glue_prod.cache-enabled=true
spark.sql.catalog.glue_prod.default-namespace=analytics
```

### REST Catalog

Typical when:

- platform wants control plane decoupled from one engine vendor
- auth, governance, and catalog policy should live behind a service boundary

Representative configuration:

```properties
spark.sql.catalog.rest_prod=org.apache.iceberg.spark.SparkCatalog
spark.sql.catalog.rest_prod.type=rest
spark.sql.catalog.rest_prod.uri=http://catalog-service.internal:8181
spark.sql.catalog.rest_prod.warehouse=s3://company-lakehouse/warehouse
```

### Hadoop Catalog

Typical when:

- environment is simpler
- direct directory-based cataloging is acceptable
- multi-engine governance requirements are weak

Representative configuration:

```properties
spark.sql.catalog.hadoop_prod=org.apache.iceberg.spark.SparkCatalog
spark.sql.catalog.hadoop_prod.type=hadoop
spark.sql.catalog.hadoop_prod.warehouse=s3://company-lakehouse/warehouse
```

## 5. Practical API Rules

Prefer these patterns:

- `DataFrameWriterV2` via `writeTo(...)`
- explicit catalog-qualified table names
- explicit maintenance procedures through Iceberg SQL extensions

Be careful with these patterns:

- generic `save()` flows that hide table semantics
- wide unscoped overwrites
- platform wrappers that remove all visibility into table and snapshot behavior

## 6. Architect Rule

If Spark is the primary writer, catalog and write API conventions should be standardized across the platform.

Otherwise every team creates a slightly different control plane by accident.