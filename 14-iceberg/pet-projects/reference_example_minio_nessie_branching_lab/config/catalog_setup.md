# Catalog Setup

Representative Spark configuration:

```properties
spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions,org.projectnessie.spark.extensions.NessieSparkSessionExtensions
spark.sql.catalog.lab=org.apache.iceberg.spark.SparkCatalog
spark.sql.catalog.lab.catalog-impl=org.apache.iceberg.nessie.NessieCatalog
spark.sql.catalog.lab.uri=http://nessie:19120/api/v2
spark.sql.catalog.lab.ref=main
spark.sql.catalog.lab.authentication.type=NONE
spark.sql.catalog.lab.warehouse=s3://iceberg-warehouse/warehouse
spark.sql.catalog.lab.io-impl=org.apache.iceberg.aws.s3.S3FileIO
```