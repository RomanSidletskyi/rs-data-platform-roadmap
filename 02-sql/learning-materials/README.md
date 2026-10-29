# 02-sql Learning Materials

This module is designed for a strong SQL engineer who already knows relational systems well and wants to expand into:

- analytics query patterns
- lakehouse SQL
- SQL vs NoSQL architecture
- document database modeling
- MongoDB
- DynamoDB
- Azure databases for Databricks
- cross-database design thinking

This module intentionally avoids repeating SQL basics and instead focuses on architecture, modeling, query practice, and production-oriented patterns.

## Main Goals

By the end of this module, the learner should be able to:

- use advanced SQL patterns for analytics
- understand how SQL changes in lakehouse systems
- compare relational and NoSQL systems
- model documents for MongoDB and CosmosDB
- design access-pattern-driven schemas for DynamoDB
- understand Azure SQL, CosmosDB, and Synapse in Databricks-oriented architecture
- find Snowflake and future cloud database platform deep dives through the grouped database-module index
- compare query patterns across systems
- choose the right storage model for the right workload

## Learning Philosophy

This module focuses on:

- real engineering patterns
- architectural trade-offs
- production-oriented data modeling
- practical query references
- platform integration

## Reading Path

Suggested path through the module:

1. `01_sql_analytics_patterns`
2. `02_sql_for_lakehouse`
3. `03_sql_vs_nosql_architecture`
4. `04_document_database_modeling`
5. `05_mongodb`
6. `06_dynamodb`
7. `07_azure_databases_for_databricks`
8. [Cloud database modules](cloud_databases.md)

## Cloud Database Modules

Vendor-specific platform capabilities are maintained in nested modules under `16-cloud-databases/`. The [module catalog](cloud_databases.md) links to the available databases and provides the location to add future entries.

The Snowflake module continues the SQL learning path with topics such as:

- native Snowflake tables versus external tables and Iceberg
- ingestion, refresh, and dynamic-table choices
- platform ownership, performance, cost, and governance trade-offs

Open [Cloud Database Modules](cloud_databases.md) to continue with Snowflake or another database module as it is added.
