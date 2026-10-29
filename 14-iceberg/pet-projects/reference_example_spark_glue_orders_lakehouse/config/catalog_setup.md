# Catalog Setup

Representative Spark configuration:

```properties
spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions
spark.sql.catalog.prod=org.apache.iceberg.spark.SparkCatalog
spark.sql.catalog.prod.type=glue
spark.sql.catalog.prod.warehouse=s3://platform-warehouse/iceberg
spark.sql.catalog.prod.io-impl=org.apache.iceberg.aws.s3.S3FileIO
```

Representative namespace creation:

```sql
CREATE NAMESPACE IF NOT EXISTS prod.analytics;
```