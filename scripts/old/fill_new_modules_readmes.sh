#!/bin/bash

set -e

cat << 'EOF' > 11-airflow/README.md
# Airflow

This module introduces workflow orchestration for data platforms.

The goal is to understand how pipelines are scheduled, monitored, retried, and connected into multi-step workflows.

## Why It Matters

Writing a pipeline is not enough in production.

You also need to control:

- when it runs
- what runs before and after it
- how failures are handled
- how reruns are managed
- how teams observe workflow health

Airflow is one of the most common orchestration tools in data engineering.

## What You Will Learn

- DAG basics
- task dependencies
- scheduling
- retries
- operators
- orchestration vs execution
- Airflow with Spark and external jobs
- production workflow patterns

## Learning Structure

### Learning Materials

- airflow basics
- DAG design
- scheduling and retries
- operators and hooks
- Airflow with Spark
- production patterns

### Simple Tasks

- first DAG
- task dependencies
- scheduling and retries
- Python operator pipeline
- Airflow with external jobs
- basic monitoring

### Pet Projects

- batch pipeline orchestration
- API to lakehouse orchestration
- multi-step data workflow
- production-style Airflow project

## Related Modules

- 01-python
- 06-spark-pyspark
- 07-databricks
- 12-dbt
- 16-observability

## Completion Criteria

By the end of this module, you should be able to:

- explain what orchestration is
- build a simple DAG
- define task dependencies
- configure retries and schedules
- explain the difference between orchestration and compute
EOF

cat << 'EOF' > 12-dbt/README.md
# dbt

This module introduces dbt as a transformation and analytics engineering layer.

The goal is to understand how to turn raw or cleaned data into trusted business models using SQL, tests, documentation, and lineage.

## Why It Matters

Modern data platforms often separate:

- data ingestion
- storage
- transformation
- serving

dbt is commonly used for the transformation layer, especially when teams want:

- maintainable SQL
- reusable models
- testing
- documentation
- lineage

## What You Will Learn

- dbt basics
- models and materializations
- staging layer design
- marts layer design
- tests and sources
- macros and Jinja
- docs and lineage
- dbt on lakehouse data

## Learning Structure

### Learning Materials

- dbt basics
- models and materializations
- tests and quality
- macros and Jinja
- documentation and lineage
- dbt with lakehouse

### Simple Tasks

- first model
- staging models
- incremental model
- tests and sources
- marts layer
- docs and lineage

### Pet Projects

- analytics engineering project
- sales marts with dbt
- dbt on lakehouse data
- end-to-end dbt project

## Related Modules

- 02-sql
- 07-databricks
- 08-delta-lake
- 10-powerbi-fabric
- 11-airflow

## Completion Criteria

By the end of this module, you should be able to:

- explain the role of dbt in a data platform
- build staging and mart models
- add tests and documentation
- understand incremental models conceptually
- explain lineage from sources to marts
EOF

cat << 'EOF' > 13-flink/README.md
# Flink

This module introduces Flink as a streaming compute engine for real-time data platforms.

The goal is to understand how stateful stream processing works and when Flink is a better fit than batch-oriented tools.

## Why It Matters

Kafka can transport events, but it does not replace a streaming compute engine.

Flink is used when systems need:

- low-latency processing
- stateful computations
- windowing
- event-time handling
- reliable recovery

## What You Will Learn

- Flink basics
- streams and transformations
- event time and watermarks
- stateful processing
- windowing
- Flink with Kafka
- checkpointing
- production streaming patterns

## Learning Structure

### Learning Materials

- Flink basics
- streams and transformations
- event time and watermarks
- stateful processing
- windowing
- Flink with Kafka
- production patterns

### Simple Tasks

- first stream job
- Kafka to Flink
- windows and aggregations
- event time intro
- stateful processing
- checkpointing basics

### Pet Projects

- real-time metrics pipeline
- clickstream sessionization
- fraud detection simulator
- Flink end-to-end project

## Related Modules

- 05-confluent-kafka
- 06-spark-pyspark
- 14-iceberg
- 16-observability

## Completion Criteria

By the end of this module, you should be able to:

- explain what Flink is used for
- describe stateful stream processing
- explain event time and windows
- explain checkpointing conceptually
- identify when Flink is useful and when it is overkill
EOF

cat << 'EOF' > 14-iceberg/README.md
# Iceberg

This module introduces Apache Iceberg as an open lakehouse table format.

The goal is to understand how modern table formats improve reliability, schema evolution, partition management, and multi-engine interoperability.

## Why It Matters

Plain files are not enough for many production analytics systems.

Modern table formats help with:

- schema evolution
- partition evolution
- historical table versions
- reliable reads and writes
- interoperability between engines

Iceberg is especially important for open lakehouse architectures.

## What You Will Learn

- Iceberg basics
- table format concepts
- schema evolution
- partition evolution
- time travel concepts
- Iceberg with Spark
- Iceberg with Flink
- trade-offs of open lakehouse design

## Learning Structure

### Learning Materials

- Iceberg basics
- table format concepts
- partitioning and evolution
- Iceberg with Spark
- Iceberg with Flink
- lakehouse trade-offs

### Simple Tasks

- first Iceberg table
- partition evolution
- schema evolution
- time travel intro
- Spark with Iceberg
- streaming to Iceberg concepts

### Pet Projects

- Iceberg lakehouse lab
- Spark Iceberg pipeline
- Flink Iceberg streaming case
- open lakehouse project

## Related Modules

- 06-spark-pyspark
- 07-databricks
- 08-delta-lake
- 09-azure-data-lake-storage
- 13-flink

## Completion Criteria

By the end of this module, you should be able to:

- explain what Iceberg solves
- compare Iceberg with plain files at a high level
- explain schema and partition evolution
- describe why table formats matter in lakehouse systems
- explain why multi-engine support is important
EOF

echo "New module README files created successfully."