# 02-sql

This module is designed for a learner who already has a strong relational SQL background and wants to extend that knowledge into:

- analytics query patterns
- lakehouse SQL
- SQL vs NoSQL architecture
- document database modeling
- MongoDB
- DynamoDB
- Azure SQL Database
- Azure CosmosDB
- Synapse SQL
- Databricks-oriented data platform design

This module does **not** focus on basic SQL syntax.  
Instead, it focuses on:

- practical query patterns
- distributed database thinking
- storage architecture
- NoSQL modeling
- cloud data platform integration

---

# Why This Module Matters

A strong SQL engineer usually knows:

- SELECT
- JOIN
- GROUP BY
- CTE
- window functions
- indexing basics
- transactional databases

But modern data platform work also requires understanding:

- analytical SQL patterns at scale
- how SQL changes in lakehouse systems
- how document and key-value systems differ from relational design
- how query patterns drive schema design in NoSQL
- how Azure SQL, CosmosDB, Synapse, and Databricks fit together in a real platform

This module helps bridge the gap between:

- strong relational SQL developer
- modern data engineer
- future data platform architect

---

# Main Learning Goals

By the end of this module, the learner should be able to:

- use reusable SQL analytics patterns for real business questions
- understand Delta / lakehouse SQL concepts
- compare SQL and NoSQL architectures
- design document-based models for MongoDB and CosmosDB
- design access-pattern-driven models for DynamoDB
- understand partitioning, indexing, and scaling trade-offs across databases
- understand which Azure database fits which workload
- connect database selection to Databricks and lakehouse architecture

---

# Module Structure

    02-sql/
      README.md

      learning-materials/
      simple-tasks/
      pet-projects/

---

# Learning Materials

The learning materials are divided into focused sections.

## 01_sql_analytics_patterns

This section contains reusable SQL patterns commonly used in analytics and data engineering.

Topics include:

- top N queries
- deduplication
- sessionization
- funnel analysis
- retention analysis
- running totals
- cohort analysis
- SCD Type 2
- practice query patterns

This section is highly practical and query-oriented.

---

## 02_sql_for_lakehouse

This section explains how SQL changes in modern lakehouse systems.

Topics include:

- Delta tables
- merge operations
- partitioning
- time travel
- schema evolution
- optimization patterns
- practice queries for lakehouse workflows

This is important because SQL in a data lake or lakehouse is not the same as SQL in OLTP systems.

---

## 03_sql_vs_nosql_architecture

This section compares relational and NoSQL systems from an engineering perspective.

Topics include:

- architecture differences
- consistency and scaling
- modeling differences
- query differences
- trade-offs
- side-by-side practical comparisons

This section helps the learner understand when relational design is the best fit and when it is not.

---

## 04_document_database_modeling

This section focuses on document-oriented schema design.

Topics include:

- embedding vs referencing
- access patterns
- denormalization
- schema design
- anti-patterns
- modeling exercises

This section is especially useful for SQL engineers moving into document databases.

---

## 05_mongodb

This section covers MongoDB as a practical document database.

Topics include:

- architecture
- Python setup
- queries through Python
- aggregation
- indexing
- data modeling
- MongoDB vs SQL

The MongoDB section is intentionally query-heavy and practice-oriented.

---

## 06_dynamodb

This section covers DynamoDB as a distributed access-pattern-driven database.

Topics include:

- architecture
- partition keys
- secondary indexes
- query patterns
- data modeling
- scaling and throttling
- hot partition problem
- DynamoDB vs MongoDB
- practice patterns

This section is practical, but the practice is centered around:

- access pattern design
- PK/SK design
- GSI usage
- scaling correctness

not around broad ad hoc querying.

---

## 07_azure_databases_for_databricks

This section focuses on Azure databases in the context of data platforms and Databricks.

Topics include:

- Azure SQL Database
- Azure SQL indexes
- Azure SQL stored procedures
- Azure CosmosDB
- Cosmos queries
- Cosmos partitioning
- Synapse SQL
- Synapse queries
- Databricks integration
- database selection guidance
- practical usage patterns
- Synapse vs Databricks SQL

This section helps place databases into real cloud platform architecture.

---

## Cross-Cutting Learning Files

The module also contains cross-cutting reference files:

- `query_pattern_cheatsheet.md`
- `data_modeling_comparison.md`
- `indexing_strategy_across_databases.md`

These files compare concepts across:

- SQL
- MongoDB
- DynamoDB
- CosmosDB
- Delta / lakehouse systems

They are intended to build architectural intuition, not only syntax familiarity.

---

# Simple Tasks

The `simple-tasks` folder contains practical exercises.

Each topic also includes a `solution.md` file for later self-checking after an independent attempt.

## 01_analytics_queries

Focus:

- revenue per customer
- top products
- daily revenue
- lifetime value
- category contribution

## 02_window_queries

Focus:

- row numbering
- ranking
- running totals
- moving averages
- lag / lead
- sessionization flags

## 03_document_queries

Focus:

- MongoDB-style document querying
- filtering
- projection
- sorting
- array queries
- aggregation basics

## 04_nosql_modeling

Focus:

- translating relational models into document or access-pattern-driven models
- MongoDB design
- DynamoDB design
- CosmosDB design
- modeling trade-offs

All simple tasks are designed to be:

- short
- practical
- engineering-oriented
- directly useful for building intuition

---

# Pet Projects

The `pet-projects` folder contains larger project-style learning units.

The main project folders are guided build exercises.

Where a separate ready implementation is useful later for comparison, it should live in a sibling folder named `reference_example_<project-name>`.

## 01_sql_analytics_engine

Goal:

Build a mini analytics layer on top of an e-commerce dataset.

Main topics:

- KPI design
- customer analytics
- product analytics
- funnel analysis
- retention
- layered SQL logic

## 02_mongodb_event_store

Goal:

Design and query an event storage system using MongoDB.

Main topics:

- event document modeling
- event query patterns
- MongoDB aggregation
- indexing for operational workloads
- retention and lifecycle thinking

## 03_relational_to_document_migration

Goal:

Convert a relational schema into a document-oriented model and explain the trade-offs.

Main topics:

- source relational model
- target document model
- migration strategy
- SQL vs Mongo query comparison
- modeling trade-offs

These projects are intended to move the learner from isolated examples into production-style thinking.

That learning path should stay consistent:

- guided project first
- reference example second
- reference examples only where they add real comparison value

---

# Key Themes of This Module

This module is built around several core themes.

## 1. SQL as an Engineering Tool

The learner is assumed to already know SQL basics well.

So this module focuses on SQL as:

- analytics language
- transformation language
- modeling tool
- system design building block

## 2. Query Patterns Matter

A major goal is to build reusable patterns such as:

- top N
- deduplication
- running totals
- cohorts
- funnels
- retention
- SCD Type 2

## 3. Modeling Depends on the Database Type

A normalized relational model is not the universal answer.

Different systems require different thinking:

- SQL -> relational entities and joins
- MongoDB -> document boundaries and embedded structures
- DynamoDB -> access-pattern-first schema
- CosmosDB -> document model plus partition-aware design
- Delta Lake -> analytics-oriented table and storage layout

## 4. Partitioning and Indexing Are Architecture Decisions

The module emphasizes that:

- indexes are query-driven
- partitioning is workload-driven
- database choice is architecture-driven

## 5. Databricks Context Matters

The module is designed to prepare the learner for later work in:

- Spark
- Databricks
- Delta Lake
- ADLS
- BI / lakehouse architectures

---

# What This Module Does Not Focus On

This module intentionally does **not** spend much time on:

- basic SELECT syntax
- beginner JOIN examples
- introductory WHERE / GROUP BY theory
- beginner normalization explanations

That knowledge is assumed.

The goal here is to push into:

- advanced query usage
- system comparison
- NoSQL modeling
- distributed data platform thinking

---

# Recommended Learning Order

A good order for this module is:

1. `01_sql_analytics_patterns`
2. `02_sql_for_lakehouse`
3. `03_sql_vs_nosql_architecture`
4. `04_document_database_modeling`
5. `05_mongodb`
6. `06_dynamodb`
7. `07_azure_databases_for_databricks`

Then continue into:

- `05-confluent-kafka`
- `06-spark-pyspark`
- `07-databricks`
- `08-delta-lake`

This sequence creates a strong bridge from SQL into modern data platform engineering.

---

# Expected Outcome

After completing this module, the learner should be able to:

- write analytical SQL with much stronger structure
- reason about storage choices, not only query syntax
- design document schemas more intentionally
- understand why DynamoDB must be modeled around access patterns
- understand how CosmosDB partitioning changes query cost
- distinguish OLTP SQL, warehouse SQL, and lakehouse SQL
- make more informed architecture decisions in cloud data platforms

---

# Final Note

This module is intended to be one of the most important transition points in the roadmap.

It connects:

- classic SQL knowledge
- modern NoSQL thinking
- cloud database architecture
- lakehouse platform design

A learner who completes this module well should be much better prepared for:

- Spark
- Databricks
- Delta Lake
- orchestration
- streaming systems
- real data platform design
