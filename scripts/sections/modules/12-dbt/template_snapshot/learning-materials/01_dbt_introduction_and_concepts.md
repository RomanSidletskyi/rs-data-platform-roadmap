# DBT Introduction and Concepts

## What dbt is

dbt (Data Build Tool) is a transformation framework for analytics engineering and data platforms.

dbt is not an ingestion tool.
dbt is not a scheduler.
dbt is not a compute engine by itself.

dbt compiles SQL and Jinja into warehouse-native SQL and runs it inside the data warehouse.

In practice this means:

- data is ingested into a warehouse by another tool
- dbt transforms raw data into business-ready datasets
- dbt adds tests, lineage, documentation, modularity, and CI/CD workflow

--------------------------------------------------

## Why dbt exists

Before dbt, SQL transformation logic was often:

- scattered across BI tools, notebooks, stored procedures, and ETL jobs
- hard to version
- hard to test
- hard to document
- hard to understand as a full graph

dbt solves this by making transformations look like software projects.

--------------------------------------------------

## dbt in a data platform

    Kafka / APIs / OLTP DBs / files
            ↓
    Databricks / Spark / Python ingestion
            ↓
    Snowflake raw layer
            ↓
    dbt staging
            ↓
    dbt intermediate
            ↓
    dbt marts
            ↓
    Power BI / Domo / APIs / reverse ETL

--------------------------------------------------

## ELT instead of ETL

dbt is built around ELT:

    Extract → Load → Transform

This means:

- extract and load happen first
- transformations happen inside the warehouse

This is why dbt is especially strong with Snowflake.

--------------------------------------------------

## dbt vs Spark

dbt is strongest when:

- transformations are SQL-friendly
- the warehouse is the main computation layer
- business logic should be visible and testable
- lineage and documentation matter

Spark / Databricks is stronger when:

- ingestion is complex
- processing volume is very large
- there is streaming
- there are nested payloads and heavy compute tasks
- PySpark is needed

Good rule:

- Databricks / Spark = ingestion, heavy processing, streaming
- dbt = warehouse transformation, modeling, data quality, lineage

--------------------------------------------------

## Core mental model

dbt should own:

- staging
- intermediate transformations
- marts
- tests
- docs
- lineage

dbt should not own:

- Kafka consumption
- long-running orchestration across systems
- external sensors
- full data movement platform logic

