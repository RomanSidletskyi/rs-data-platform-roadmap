#!/bin/bash

set -e

########################################
# 11-airflow
########################################

ROOT="11-airflow/simple-tasks"

cat << 'EOF' > "$ROOT/01_first_dag/README.md"
# First DAG

## Goal

Create your first Airflow DAG and understand the structure of a workflow.

## Input

A simple pipeline with three logical steps:

- start
- process_data
- finish

## Requirements

- create a DAG
- define three tasks
- connect them in the correct order
- use a simple schedule

## Expected Output

A working DAG visible in the Airflow UI.

## Extra Challenge

- add task descriptions
- add tags to the DAG
EOF

cat << 'EOF' > "$ROOT/02_task_dependencies/README.md"
# Task Dependencies

## Goal

Understand how tasks depend on each other in Airflow.

## Input

Pipeline steps:

- extract
- validate
- transform
- load

## Requirements

- define four tasks
- set dependencies correctly
- ensure `transform` starts only after `validate`

## Expected Output

A DAG graph showing correct task order.

## Extra Challenge

- add one parallel task branch
- add a final summary task
EOF

cat << 'EOF' > "$ROOT/03_scheduling_and_retries/README.md"
# Scheduling and Retries

## Goal

Learn how Airflow handles scheduling and retry behavior.

## Input

A DAG that runs daily.

## Requirements

- set a daily schedule
- configure retries
- set retry delay
- configure start date

## Expected Output

A DAG configured with scheduling and retry settings.

## Extra Challenge

- compare manual trigger vs scheduled run
- explain catchup behavior
EOF

cat << 'EOF' > "$ROOT/04_python_operator_pipeline/README.md"
# Python Operator Pipeline

## Goal

Run Python functions as Airflow tasks.

## Input

Three Python functions:

- fetch_data()
- clean_data()
- save_data()

## Requirements

- use PythonOperator or TaskFlow API
- run functions in sequence
- pass data conceptually between steps

## Expected Output

A simple Python-based DAG.

## Extra Challenge

- separate task logic into another file
- add logging in each task
EOF

cat << 'EOF' > "$ROOT/05_airflow_with_external_jobs/README.md"
# Airflow with External Jobs

## Goal

Understand how Airflow orchestrates jobs outside Airflow itself.

## Input

A workflow with steps:

- trigger_spark_job
- wait_for_completion
- publish_result

## Requirements

- model the workflow as a DAG
- treat Spark as an external compute engine
- document what Airflow controls vs what Spark executes

## Expected Output

A DAG that represents orchestration of an external job.

## Extra Challenge

- add failure handling logic
- add task groups or logical grouping
EOF

cat << 'EOF' > "$ROOT/06_basic_monitoring/README.md"
# Basic Monitoring

## Goal

Understand how to monitor DAG runs and task failures.

## Input

A DAG with at least three tasks.

## Requirements

- inspect task states
- identify failed and successful runs
- document where logs can be found
- describe how retries appear in the UI

## Expected Output

A short operational note about DAG monitoring.

## Extra Challenge

- add email or alerting concepts
- add SLA or execution timeout conceptually
EOF

########################################
# 12-dbt
########################################

ROOT="12-dbt/simple-tasks"

cat << 'EOF' > "$ROOT/01_first_model/README.md"
# First dbt Model

## Goal

Create your first dbt model from a raw source table.

## Input

Raw table:

- raw_customers

Fields:

- customer_id
- full_name
- email
- created_at

## Requirements

- create a dbt model
- select and rename columns
- keep SQL clean and readable

## Expected Output

A dbt model producing a cleaned customer table.

## Extra Challenge

- add consistent column naming
- add a short model description
EOF

cat << 'EOF' > "$ROOT/02_staging_models/README.md"
# Staging Models

## Goal

Learn how to build a staging layer in dbt.

## Input

Raw source tables:

- raw_orders
- raw_customers

## Requirements

- create staging models
- standardize column names
- cast data types where needed
- keep business logic out of staging

## Expected Output

Two staging models ready for downstream use.

## Extra Challenge

- add one source freshness note
- document why staging should stay simple
EOF

cat << 'EOF' > "$ROOT/03_incremental_model/README.md"
# Incremental Model

## Goal

Understand when and how to build incremental models.

## Input

Orders table with:

- order_id
- customer_id
- order_date
- amount
- updated_at

## Requirements

- define an incremental model
- explain unique key concept
- explain when incremental logic is useful

## Expected Output

A documented incremental model pattern.

## Extra Challenge

- compare full refresh vs incremental
- describe rerun implications
EOF

cat << 'EOF' > "$ROOT/04_tests_and_sources/README.md"
# Tests and Sources

## Goal

Use dbt tests and source definitions to improve trust in data.

## Input

A model with fields:

- order_id
- customer_id
- order_date

## Requirements

- define a source
- add basic tests
- include not_null and unique where appropriate

## Expected Output

A dbt project with source metadata and tests.

## Extra Challenge

- add relationship test
- explain what test failures mean operationally
EOF

cat << 'EOF' > "$ROOT/05_marts_layer/README.md"
# Marts Layer

## Goal

Build a business-facing mart on top of staging models.

## Input

Staging models:

- stg_orders
- stg_customers

## Requirements

- create a mart model
- join data from staging
- expose business-friendly fields
- keep mart readable for BI usage

## Expected Output

A simple mart model for analytics consumption.

## Extra Challenge

- design a fact-like model
- design a dimension-like model
EOF

cat << 'EOF' > "$ROOT/06_docs_and_lineage/README.md"
# Docs and Lineage

## Goal

Understand dbt documentation and lineage.

## Input

A dbt project with sources, staging models, and marts.

## Requirements

- add descriptions to models
- document key columns
- inspect lineage graph

## Expected Output

A documented dbt project with visible lineage.

## Extra Challenge

- explain lineage from raw source to mart
- identify one weak point in the transformation flow
EOF

########################################
# 13-flink
########################################

ROOT="13-flink/simple-tasks"

cat << 'EOF' > "$ROOT/01_first_stream_job/README.md"
# First Stream Job

## Goal

Understand the structure of a Flink streaming job.

## Input

A stream of simple events:

- user_id
- event_type
- event_time

## Requirements

- define a basic stream pipeline
- read events conceptually
- apply one simple transformation
- write or print output

## Expected Output

A minimal Flink stream job structure.

## Extra Challenge

- explain source -> transformation -> sink
- compare it with a Spark job at a high level
EOF

cat << 'EOF' > "$ROOT/02_kafka_to_flink/README.md"
# Kafka to Flink

## Goal

Understand how Flink consumes data from Kafka.

## Input

Kafka topic:

- user_events

Event schema:

- user_id
- event_type
- timestamp

## Requirements

- describe Kafka as source
- define a Flink pipeline that reads the topic
- transform events
- send output to a sink

## Expected Output

A conceptual Kafka -> Flink pipeline.

## Extra Challenge

- add invalid-event handling conceptually
- explain offset/checkpoint relationship
EOF

cat << 'EOF' > "$ROOT/03_windows_and_aggregations/README.md"
# Windows and Aggregations

## Goal

Learn why windowing exists in streaming systems.

## Input

Events with timestamps and event types.

## Requirements

- group events into windows
- count events per window
- explain tumbling vs sliding windows

## Expected Output

A small windowed aggregation example.

## Extra Challenge

- count distinct users per window
- compare business meaning of different window sizes
EOF

cat << 'EOF' > "$ROOT/04_event_time_intro/README.md"
# Event Time Intro

## Goal

Understand the difference between processing time and event time.

## Input

Events arriving out of order.

Example fields:

- event_id
- event_time
- arrival_time

## Requirements

- explain event time
- explain late events
- explain why ordering can be difficult

## Expected Output

A short explanation with one small example.

## Extra Challenge

- explain watermark conceptually
- describe one business case where event time matters
EOF

cat << 'EOF' > "$ROOT/05_stateful_processing/README.md"
# Stateful Processing

## Goal

Understand what state means in streaming systems.

## Input

A use case such as:

- count events per user
- detect repeated failures
- track session activity

## Requirements

- explain stateful processing
- describe why state is needed
- describe one use case

## Expected Output

A documented stateful stream-processing example.

## Extra Challenge

- compare stateless vs stateful operations
- explain why state increases complexity
EOF

cat << 'EOF' > "$ROOT/06_checkpointing_basics/README.md"
# Checkpointing Basics

## Goal

Understand how Flink supports recovery.

## Input

A streaming pipeline with Kafka source and sink.

## Requirements

- explain checkpointing
- explain failure recovery at a high level
- explain why checkpoints matter for reliability

## Expected Output

A short reliability note for a Flink pipeline.

## Extra Challenge

- relate checkpoints to exactly-once ideas
- compare checkpointing with simple batch reruns
EOF

########################################
# 14-iceberg
########################################

ROOT="14-iceberg/simple-tasks"

cat << 'EOF' > "$ROOT/01_first_iceberg_table/README.md"
# First Iceberg Table

## Goal

Understand what an Iceberg table is and why it differs from plain files.

## Input

A dataset such as:

- orders
- customers
- events

## Requirements

- describe an Iceberg table
- explain metadata-driven table management
- explain why this matters in analytics systems

## Expected Output

A short note describing the first Iceberg table use case.

## Extra Challenge

- compare Iceberg vs plain Parquet
- compare Iceberg vs Delta at a high level
EOF

cat << 'EOF' > "$ROOT/02_partition_evolution/README.md"
# Partition Evolution

## Goal

Understand why Iceberg partitioning is more flexible than static file layouts.

## Input

A table initially partitioned by:

- event_date

Later requirement:

- add region-based partitioning

## Requirements

- explain partition evolution
- explain why repartitioning is painful in plain file layouts
- explain business benefit of flexibility

## Expected Output

A documented partition evolution example.

## Extra Challenge

- describe one bad partitioning strategy
- explain how query patterns affect partition design
EOF

cat << 'EOF' > "$ROOT/03_schema_evolution/README.md"
# Schema Evolution

## Goal

Understand how Iceberg handles schema changes safely.

## Input

A table with fields:

- order_id
- customer_id
- amount

New requirement:

- add currency
- rename amount to order_amount

## Requirements

- explain schema evolution
- explain why schema changes are risky in raw file-based systems
- describe how table formats help

## Expected Output

A short schema evolution explanation.

## Extra Challenge

- describe one backward compatibility risk
- compare schema evolution in warehouse vs lakehouse thinking
EOF

cat << 'EOF' > "$ROOT/04_time_travel_intro/README.md"
# Time Travel Intro

## Goal

Understand the purpose of historical table versions.

## Input

A table updated daily.

Need:

- inspect previous version
- validate change impact
- recover from bad update

## Requirements

- explain time travel conceptually
- explain why it is useful
- describe one debugging use case

## Expected Output

A short note about historical table versions.

## Extra Challenge

- connect time travel to auditability
- describe one cost trade-off of keeping history
EOF

cat << 'EOF' > "$ROOT/05_spark_with_iceberg/README.md"
# Spark with Iceberg

## Goal

Understand how Spark can work with Iceberg tables.

## Input

A Spark batch pipeline reading and writing analytics tables.

## Requirements

- explain Spark as compute engine
- explain Iceberg as table format
- explain why separating compute and table format matters

## Expected Output

A documented Spark + Iceberg architecture note.

## Extra Challenge

- compare Spark + Iceberg vs Databricks + Delta conceptually
- explain one interoperability advantage
EOF

cat << 'EOF' > "$ROOT/06_streaming_to_iceberg_concepts/README.md"
# Streaming to Iceberg Concepts

## Goal

Understand why streaming engines may write to Iceberg tables.

## Input

A stream of user events processed continuously.

## Requirements

- explain streaming sink to Iceberg conceptually
- explain why a reliable table format matters
- describe one use case with Flink or Spark Structured Streaming

## Expected Output

A short architecture-oriented explanation.

## Extra Challenge

- compare batch writes vs streaming writes
- explain one challenge of mixing streaming and analytics tables
EOF

echo "New module simple-task READMEs created successfully."