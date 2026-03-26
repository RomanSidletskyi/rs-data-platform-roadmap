# Databricks Integration

## Azure SQL -> Databricks

```python
df = spark.read \
    .format("jdbc") \
    .option("url", jdbc_url) \
    .option("dbtable", "orders") \
    .option("user", user) \
    .option("password", password) \
    .load()
```

## CosmosDB -> Databricks

```python
df = spark.read.format("cosmos.oltp").options(**cfg).load()
```

## Synapse / Lake Query Style

Databricks can also read lake data directly through Delta and Spark-native patterns.

## Main Architectural Question

Choose the source based on workload:

- Azure SQL for transactional source systems
- CosmosDB for operational NoSQL apps
- Synapse for warehouse SQL patterns
- Databricks for core lakehouse analytics and engineering
