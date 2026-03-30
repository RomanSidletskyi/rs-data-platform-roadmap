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
- understand Snowflake as both a warehouse and a lakehouse-facing platform component
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
8. `08_snowflake`

## Why `08_snowflake` Matters

The Snowflake section is where classic SQL knowledge starts to meet warehouse operations, storage layout, lakehouse interoperability, and production refresh design.

It is intentionally built to answer questions such as:

- when should data stay in native Snowflake tables?
- when should data remain in object storage and be queried externally?
- when is Snowflake-managed Iceberg better than plain external tables?
- when are dynamic tables a better fit than tasks, dbt jobs, or materialized views?

The goal is not only to know Snowflake syntax.

The goal is to understand how Snowflake fits into a modern data platform where:

- storage and compute are separated
- multiple engines may need the same data
- freshness and cost need explicit trade-offs
- architectural decisions matter more than isolated SQL commands
