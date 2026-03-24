# Practical Usage Patterns

## Pattern 1: Azure SQL as Source for Databricks

- operational app writes to Azure SQL
- Databricks ingests via JDBC
- Delta tables become analytics layer

## Pattern 2: CosmosDB for Operational API + Databricks for Analytics

- application writes JSON documents to CosmosDB
- analytics pipeline exports or ingests operational data
- curated Delta tables power BI and ML

## Pattern 3: Synapse for SQL Warehouse Workloads

- structured reporting in Synapse
- Databricks handles broader engineering / lakehouse workloads

## Rule

Do not force one Azure database to serve every workload.
