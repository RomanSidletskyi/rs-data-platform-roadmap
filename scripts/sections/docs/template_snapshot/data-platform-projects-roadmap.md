# Data Platform Projects Roadmap

This document lists the recommended cross-technology projects for the repository.

The goal is to make `real-projects/` a coherent portfolio path rather than a loose set of ideas.

## Current Real Project Slots

The repository currently has these real-project directories:

1. `01_python_sql_etl`
2. `02_python_docker_github_actions`
3. `03_python_kafka`
4. `04_python_kafka_databricks`
5. `05_python_spark_delta`
6. `06_databricks_adls_powerbi`
7. `07_kafka_databricks_powerbi`
8. `08_end_to_end_data_platform`

These should be implemented in roughly this order.

Projects `06_databricks_adls_powerbi` and `07_kafka_databricks_powerbi` already reserve a BI-serving target, but that serving layer still depends on the planned placeholder module `10-powerbi-fabric`.

---

# Project 1 - Python SQL ETL

Directory:

- `real-projects/01_python_sql_etl`

Modules used:

- `01-python`
- `02-sql`

Architecture:

- API or file source
- Python ingestion and normalization
- SQL validation or downstream analytical shaping

Goal:

- build a first end-to-end batch pipeline with clear structure and reproducible outputs

---

# Project 2 - Python Docker GitHub Actions

Directory:

- `real-projects/02_python_docker_github_actions`

Modules used:

- `01-python`
- `03-docker`
- `04-github-actions`

Architecture:

- Python application
- Dockerized runtime
- CI checks and image or artifact validation in GitHub Actions

Goal:

- learn how implementation, packaging, and CI fit together

---

# Project 3 - Python Kafka

Directory:

- `real-projects/03_python_kafka`

Modules used:

- `01-python`
- `05-confluent-kafka`

Architecture:

- Python producer
- Kafka topic backbone
- Python consumer or event sink

Goal:

- understand event-driven ingestion and consumer design

---

# Project 4 - Python Kafka Databricks

Directory:

- `real-projects/04_python_kafka_databricks`

Modules used:

- `01-python`
- `05-confluent-kafka`
- `07-databricks`

Architecture:

- event producer
- Kafka ingestion layer
- Databricks processing and lakehouse loading

Goal:

- connect event ingress with managed distributed compute

---

# Project 5 - Python Spark Delta

Directory:

- `real-projects/05_python_spark_delta`

Modules used:

- `01-python`
- `06-spark-pyspark`
- `08-delta-lake`

Architecture:

- Python-controlled pipeline entrypoint
- Spark transformation layer
- Delta tables for reliable storage and repair

Goal:

- practice batch processing with stronger table semantics and recovery thinking

---

# Project 6 - Databricks ADLS Power BI

Directory:

- `real-projects/06_databricks_adls_powerbi`

Modules used:

- `07-databricks`
- `09-azure-data-lake-storage`
- `10-powerbi-fabric` planned placeholder

Architecture:

- Databricks compute layer
- ADLS namespace and storage boundaries
- Power BI consumer-facing delivery

Goal:

- practice a full analytics-serving path from lakehouse to BI consumption

---

# Project 7 - Kafka Databricks Power BI

Directory:

- `real-projects/07_kafka_databricks_powerbi`

Modules used:

- `05-confluent-kafka`
- `07-databricks`
- `10-powerbi-fabric` planned placeholder

Architecture:

- event ingestion backbone
- Databricks processing or aggregation
- BI-facing outputs for near-real-time consumption

Goal:

- connect event streams to business-facing analytics

---

# Project 8 - End-To-End Data Platform

Directory:

- `real-projects/08_end_to_end_data_platform`

Modules used:

- selected layers from across the repository

Suggested platform shape:

- source systems
- Python or Kafka ingestion
- Spark, Databricks, or Flink processing
- Delta Lake or Iceberg table layer
- dbt transformation where useful
- Power BI serving
- Airflow orchestration

Goal:

- design one production-style learning platform that forces trade-off thinking across several layers at once

---

# Working Rule

`real-projects/` should stay selective.

The goal is not to create one real project per module.

The goal is to create a small set of multi-technology projects that clearly show growth from tool literacy to platform architecture.
