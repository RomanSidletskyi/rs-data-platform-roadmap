#!/bin/bash

set -e

mkdir -p \
  docs \
  docs/architecture \
  docs/architecture/01_foundations \
  docs/architecture/02_batch_architecture \
  docs/architecture/03_streaming_architecture \
  docs/architecture/04_lakehouse_architecture \
  docs/architecture/05_serving_and_bi_architecture \
  docs/architecture/06_data_governance_security \
  docs/architecture/07_scalability_reliability \
  docs/architecture/08_cost_performance_tradeoffs \
  docs/architecture/09_architecture_case_studies \
  docs/architecture/adr \
  docs/system-design \
  docs/case-studies \
  docs/trade-offs

########################################
# docs/data-platform-map.md
########################################

cat << 'EOF' > docs/data-platform-map.md
# Data Platform Map

This document explains how all modules in this repository fit into a modern data platform.

The goal is to understand:

- where each technology sits in the architecture
- what problem it solves
- how systems connect together

---

# Logical Architecture

Sources
↓
Ingestion
↓
Processing
↓
Storage / Lakehouse
↓
Transformation
↓
Serving
↓
BI / Analytics

Supporting layers:

- orchestration
- data quality
- observability
- governance
- infrastructure

---

# Repository Modules and Platform Roles

## Ingestion Layer

Modules:

01-python
02-sql
05-confluent-kafka

Purpose:

Move data from source systems into the platform.

Examples:

API -> Python -> Data Lake

Application -> Kafka -> Stream consumers

---

## Processing Layer

Modules:

06-spark-pyspark
07-databricks

Purpose:

Transform large volumes of data.

Responsibilities:

- joins
- aggregations
- transformations
- data enrichment

Example:

Raw -> Spark -> Curated tables

---

## Storage Layer

Modules:

08-delta-lake
09-azure-data-lake-storage

Purpose:

Reliable storage of raw and processed data.

Typical layout:

data-lake/
raw/
bronze/
silver/
gold/

---

## Analytics Layer

Module:

10-powerbi-fabric

Purpose:

Expose business data to analysts.

Example:

Gold tables -> semantic model -> dashboards

---

## Engineering Enablement

Modules:

03-docker
04-github-actions

Purpose:

Reproducible environments and CI/CD pipelines.

---

# Platform Extensions

## Orchestration

Module:

11-airflow

Purpose:

Coordinate pipeline execution and scheduling.

---

## Transformation Layer

Module:

12-dbt

Purpose:

Maintain SQL transformation models.

Features:

- tests
- lineage
- documentation

---

## Streaming Compute

Module:

13-flink

Purpose:

Stateful real-time stream processing.

Example:

Kafka -> Flink -> aggregated metrics

---

## Open Table Formats

Module:

14-iceberg

Purpose:

Engine-independent lakehouse tables.

---

# Production Layers

## Data Quality

Module:

15-data-quality

Purpose:

Validate datasets before consumption.

---

## Observability

Module:

16-observability

Purpose:

Monitor pipelines and infrastructure.

---

## Cloud Architecture

Module:

17-cloud-architecture

Purpose:

Understand cloud-native data platform design.

---

## Infrastructure as Code

Module:

18-terraform

Purpose:

Provision infrastructure reproducibly.

---

# Full Platform Flow

Sources

↓

Ingestion
Python / Kafka

↓

Processing
Spark / Flink

↓

Storage
ADLS / S3

↓

Lakehouse Tables
Delta / Iceberg

↓

Transformation
dbt

↓

Serving
BI tools

Supporting systems:

Airflow -> orchestration
Data Quality -> validation
Observability -> monitoring
Terraform -> infrastructure

---

# Key Architecture Principle

Every tool exists because it solves a specific problem.

Examples:

Kafka -> event transport
Spark -> distributed compute
Flink -> real-time processing
dbt -> SQL transformation layer
Delta / Iceberg -> lakehouse tables
Power BI -> analytics consumption
EOF

########################################
# docs/learning-sequence.md
########################################

cat << 'EOF' > docs/learning-sequence.md
# Learning Sequence

This roadmap describes the recommended order for learning modules.

Goal:

Move from tool knowledge -> platform engineering -> architecture thinking.

---

# Phase 1 — Engineering Basics

Modules:

01-python
02-sql
03-docker
04-github-actions

Focus:

- coding
- automation
- reproducible environments

Example project:

Python ETL pipeline in Docker.

---

# Phase 2 — Data Processing

Modules:

05-confluent-kafka
06-spark-pyspark

Focus:

- event ingestion
- distributed processing

Example project:

Kafka -> Python consumer
Spark ETL pipeline

---

# Phase 3 — Lakehouse

Modules:

07-databricks
08-delta-lake
09-azure-data-lake-storage

Focus:

- scalable data platforms
- medallion architecture

Example project:

API -> Spark -> Delta pipeline

---

# Phase 4 — Analytics

Module:

10-powerbi-fabric

Focus:

- business intelligence
- dashboards
- semantic models

Example project:

Gold tables -> Power BI dashboards

---

# Phase 5 — Orchestration

Module:

11-airflow

Focus:

- scheduling pipelines
- DAG design
- dependencies

Example project:

Airflow orchestrated ETL pipeline

---

# Phase 6 — Transformation Modeling

Module:

12-dbt

Focus:

- SQL models
- testing
- documentation

Example project:

dbt transformation layer

---

# Phase 7 — Streaming Systems

Module:

13-flink

Focus:

- event time
- streaming windows
- checkpointing

Example project:

Kafka -> Flink -> real-time metrics

---

# Phase 8 — Lakehouse Formats

Module:

14-iceberg

Focus:

- open table formats
- schema evolution

Example project:

Spark + Flink reading Iceberg tables

---

# Phase 9 — Reliability

Modules:

15-data-quality
16-observability

Focus:

- validation
- monitoring
- alerting

---

# Phase 10 — Platform Architecture

Modules:

17-cloud-architecture
18-terraform

Focus:

- cloud systems
- infrastructure automation
EOF

########################################
# docs/data-platform-projects-roadmap.md
########################################

cat << 'EOF' > docs/data-platform-projects-roadmap.md
# Data Platform Projects Roadmap

This document lists recommended end-to-end projects for mastering the full data platform stack.

The projects gradually combine more modules from the roadmap.

---

# Project 1 — Python Batch ETL

Modules used:

- Python
- SQL
- Docker

Architecture:

API -> Python -> CSV / Parquet

Goal:

Learn basic ingestion pipelines.

---

# Project 2 — Event Streaming Pipeline

Modules used:

- Python
- Kafka

Architecture:

Producer -> Kafka -> Consumer -> storage

Goal:

Understand event streaming.

---

# Project 3 — Spark Batch Processing

Modules used:

- Spark
- ADLS

Architecture:

Raw files -> Spark -> processed datasets

Goal:

Process large datasets.

---

# Project 4 — Lakehouse Pipeline

Modules used:

- Databricks
- Delta Lake
- ADLS

Architecture:

Raw -> Bronze -> Silver -> Gold

Goal:

Implement medallion architecture.

---

# Project 5 — Analytics Pipeline

Modules used:

- Databricks
- Power BI

Architecture:

Gold tables -> BI dashboards

Goal:

Deliver business insights.

---

# Project 6 — Orchestrated Data Platform

Modules used:

- Airflow
- Spark
- Delta

Architecture:

Airflow -> Spark jobs -> Delta tables

Goal:

Understand orchestration.

---

# Project 7 — Transformation Layer

Modules used:

- dbt
- Delta

Architecture:

Silver tables -> dbt models -> marts

Goal:

Create maintainable SQL models.

---

# Project 8 — Real-time Metrics Platform

Modules used:

- Kafka
- Flink

Architecture:

Events -> Flink -> real-time aggregates

Goal:

Implement streaming analytics.

---

# Project 9 — Observability Pipeline

Modules used:

- monitoring
- logging
- metrics

Goal:

Monitor pipeline health and performance.

---

# Project 10 — Full Data Platform

Modules used:

All modules.

Architecture:

Sources
-> Kafka ingestion
-> Spark / Flink processing
-> Delta / Iceberg tables
-> dbt transformation
-> BI dashboards
-> Airflow orchestration
-> monitoring + data quality

Goal:

Build a production-style data platform.
EOF

########################################
# docs/architecture/README.md
########################################

cat << 'EOF' > docs/architecture/README.md
# Architecture

This section is dedicated to architecture thinking for data platforms.

The goal is to understand not only how to use tools, but also:

- why specific components exist
- how systems are designed
- what trade-offs are involved
- how to choose between alternatives
- how to explain architecture decisions clearly

---

## What This Section Covers

- foundational architecture concepts
- batch and streaming patterns
- lakehouse thinking
- serving and BI architecture
- governance and reliability concepts
- architecture decisions
- links between repository modules and platform design

---

## Recommended Study Order

1. Foundations
2. Batch Architecture
3. Streaming Architecture
4. Lakehouse Architecture
5. Serving and BI Architecture
6. Governance and Security
7. Scalability and Reliability
8. Cost and Performance Trade-offs
9. Case Studies

---

## Architecture Thinking Template

Use this template when analyzing any design:

### Problem

What business or technical problem is being solved?

### Requirements

What are the constraints?

### Components

What are the major building blocks?

### Data Flow

How does data move through the system?

### Trade-Offs

What is gained and what is sacrificed?

### Alternatives

What could be used instead?

### Failure Points

Where can the system break?

### Observability

How will problems be detected?

### Cost Considerations

What could make this architecture expensive?

### Final Decision

Why is this architecture a good fit?
EOF

########################################
# docs/architecture/01_foundations
########################################

cat << 'EOF' > docs/architecture/01_foundations/README.md
# Data Engineering Foundations

This section introduces the fundamental concepts required to understand data architecture.

These concepts appear in almost every data platform.

---

## What Problem Does It Solve

This topic gives the conceptual foundation needed to understand how data systems are designed and why architectural choices matter.

## Why It Matters

These concepts appear in almost every real pipeline and every architecture interview.

## What You Need to Learn

- OLTP vs OLAP
- batch vs streaming
- ETL vs ELT
- schema-on-read vs schema-on-write
- latency vs throughput
- idempotency
- partitioning
- lineage
- data quality basics

## Interview Questions

- What is the difference between OLTP and OLAP?
- When should you choose batch processing?
- What is idempotency in data pipelines?
- What is schema-on-read?
- Why is partitioning important?

## Related Courses

See:

    resources.md

## Completion Checklist

- [ ] I understand OLTP vs OLAP
- [ ] I understand batch vs streaming
- [ ] I understand ETL vs ELT
- [ ] I understand schema-on-read vs schema-on-write
- [ ] I understand idempotency
- [ ] I understand partitioning
EOF

cat << 'EOF' > docs/architecture/01_foundations/resources.md
# Learning Resources — Foundations

## Articles

- OLTP vs OLAP
- batch vs stream processing
- schema-on-read
- analytics architecture guidance

## Courses

### Coursera

Add your completed or planned courses here.

### Udemy

Add your completed or planned courses here.

## Books

- Designing Data-Intensive Applications
- Fundamentals of Data Engineering
EOF

########################################
# docs/architecture/02_batch_architecture
########################################

cat << 'EOF' > docs/architecture/02_batch_architecture/README.md
# Batch Architecture

## What Problem Does It Solve

Batch architecture is used when data does not need to be processed immediately and can be delivered on a schedule.

## Why It Matters

A large number of analytics systems and reporting workflows are built using batch pipelines.

## Typical Architecture

    Source -> Landing -> Raw -> Transform -> Curated -> BI

## When To Use It

- daily reporting
- hourly synchronization
- historical backfills

## When Not To Use It

- fraud detection
- live monitoring
- real-time alerting

## Interview Questions

- Why choose batch over streaming?
- What is the role of raw storage?
- What is a backfill?
- When should you use incremental processing?

## Related Courses

See:

    resources.md

## Completion Checklist

- [ ] I can explain a standard batch pipeline
- [ ] I understand raw vs curated layers
- [ ] I understand full refresh vs incremental load
EOF

cat << 'EOF' > docs/architecture/02_batch_architecture/resources.md
# Learning Resources — Batch Architecture

## Articles

- batch processing concepts
- incremental loading patterns
- backfill strategies

## Courses

### Coursera

Add relevant course sections here.

### Udemy

Add relevant course sections here.

## Books

- Designing Data-Intensive Applications
- Fundamentals of Data Engineering
EOF

########################################
# docs/architecture/03_streaming_architecture
########################################

cat << 'EOF' > docs/architecture/03_streaming_architecture/README.md
# Streaming Architecture

## What Problem Does It Solve

Streaming architecture is used when data must be processed continuously with low latency.

## Why It Matters

Modern platforms often require near real-time event processing and decoupled system communication.

## Typical Architecture

    Producers -> Kafka -> Stream Processing -> Storage / Serving -> Consumers

## When To Use It

- near real-time analytics
- event-driven systems
- clickstream analysis
- operational monitoring

## When Not To Use It

- daily reporting
- simple one-time sync jobs
- low-frequency workloads

## Interview Questions

- When would you choose Kafka?
- What is the purpose of a consumer group?
- What are offsets?
- What is the difference between at-least-once and exactly-once?

## Related Courses

See:

    resources.md

## Completion Checklist

- [ ] I understand why streaming exists
- [ ] I can explain topics, partitions, and offsets
- [ ] I understand consumer groups
- [ ] I can explain when not to use streaming
EOF

cat << 'EOF' > docs/architecture/03_streaming_architecture/resources.md
# Learning Resources — Streaming Architecture

## Articles

- Kafka fundamentals
- event-driven architecture
- delivery guarantees

## Courses

### Coursera

Add streaming-related modules here.

### Udemy

Add Kafka and real-time processing sections here.

## Books

- Designing Event-Driven Systems
- Designing Data-Intensive Applications
EOF

########################################
# docs/architecture/04_lakehouse_architecture
########################################

cat << 'EOF' > docs/architecture/04_lakehouse_architecture/README.md
# Lakehouse Architecture

## What Problem Does It Solve

Lakehouse architecture combines scalable low-cost storage with reliable table features for analytics.

## Why It Matters

Modern platforms need open storage, scalable compute, and curated BI-friendly layers.

## Typical Architecture

    Ingestion -> Bronze -> Silver -> Gold -> BI / ML / Serving

## When To Use It

- analytics platforms
- multi-stage transformations
- historical retention
- large-scale processing

## When Not To Use It

- tiny local workflows
- simple single-table reporting

## Interview Questions

- What is a lakehouse?
- Why use Delta Lake instead of plain Parquet?
- What is medallion architecture?
- Why separate bronze, silver, and gold?

## Related Courses

See:

    resources.md

## Completion Checklist

- [ ] I understand what a lakehouse solves
- [ ] I understand bronze, silver, and gold layers
- [ ] I understand why table formats matter
EOF

cat << 'EOF' > docs/architecture/04_lakehouse_architecture/resources.md
# Learning Resources — Lakehouse Architecture

## Articles

- lakehouse overview
- Delta Lake concepts
- medallion architecture guidance

## Courses

### Coursera

Add lakehouse-related modules here.

### Udemy

Add Databricks, Spark, and Delta-related sections here.

## Books

- Fundamentals of Data Engineering
EOF

########################################
# docs/architecture/05_serving_and_bi_architecture
########################################

cat << 'EOF' > docs/architecture/05_serving_and_bi_architecture/README.md
# Serving and BI Architecture

## What Problem Does It Solve

This architecture prepares curated data for reporting, analytics, and dashboard consumption.

## Why It Matters

Business users need fast, trusted, easy-to-understand data models instead of raw storage tables.

## Typical Architecture

    Curated Data -> Semantic Layer -> BI Tool -> Dashboards / Reports

## When To Use It

- reporting
- dashboards
- self-service analytics
- KPI delivery

## When Not To Use It

- raw exploratory ingestion
- low-level source archival

## Interview Questions

- Why should Power BI not read raw data directly?
- What is a semantic layer?
- What is the difference between fact and dimension tables?
- Why use data marts?

## Related Courses

See:

    resources.md

## Completion Checklist

- [ ] I understand the purpose of semantic models
- [ ] I understand fact vs dimension tables
- [ ] I understand why curated layers exist
EOF

cat << 'EOF' > docs/architecture/05_serving_and_bi_architecture/resources.md
# Learning Resources — Serving and BI Architecture

## Articles

- star schema basics
- semantic model design
- BI serving best practices

## Courses

### Coursera

Add BI-related course content here.

### Udemy

Add Power BI or reporting architecture sections here.

## Books

- The Data Warehouse Toolkit
EOF

########################################
# docs/architecture/06_data_governance_security
########################################

cat << 'EOF' > docs/architecture/06_data_governance_security/README.md
# Data Governance and Security

## What Problem Does It Solve

This topic addresses ownership, access control, compliance, and auditability.

## Why It Matters

A platform is not production-ready if access is uncontrolled or sensitive data is exposed.

## Typical Topics

- RBAC
- lineage
- audit logs
- secrets management
- environment separation

## Interview Questions

- What is RBAC?
- Why is lineage important?
- How do you protect PII?
- Why separate dev, test, and prod?

## Related Courses

See:

    resources.md

## Completion Checklist

- [ ] I understand RBAC
- [ ] I understand least privilege
- [ ] I understand lineage and auditability
EOF

cat << 'EOF' > docs/architecture/06_data_governance_security/resources.md
# Learning Resources — Data Governance and Security

## Articles

- RBAC fundamentals
- data lineage basics
- data governance principles
- secrets management guidance

## Courses

### Coursera

Add governance-related sections here.

### Udemy

Add governance and security sections here.

## Books

- Fundamentals of Data Engineering
EOF

########################################
# docs/architecture/07_scalability_reliability
########################################

cat << 'EOF' > docs/architecture/07_scalability_reliability/README.md
# Scalability and Reliability

## What Problem Does It Solve

This topic focuses on designing systems that keep working as data volume grows and failures happen.

## Why It Matters

Good architecture anticipates retries, reruns, checkpointing, scaling limits, and bottlenecks.

## Typical Topics

- retry logic
- checkpointing
- scaling strategy
- partitioning
- failure recovery

## Interview Questions

- What happens if a pipeline fails halfway through?
- How do you avoid duplicates after reruns?
- What is checkpointing?
- How does partitioning affect scale?

## Related Courses

See:

    resources.md

## Completion Checklist

- [ ] I understand retry and rerun safety
- [ ] I understand idempotency
- [ ] I understand checkpointing conceptually
EOF

cat << 'EOF' > docs/architecture/07_scalability_reliability/resources.md
# Learning Resources — Scalability and Reliability

## Articles

- idempotent pipeline design
- checkpointing concepts
- retry and backoff strategies
- distributed processing bottlenecks

## Courses

### Coursera

Add reliability-related content here.

### Udemy

Add Spark, Kafka, and production reliability sections here.

## Books

- Designing Data-Intensive Applications
- Fundamentals of Data Engineering
EOF

########################################
# docs/architecture/08_cost_performance_tradeoffs
########################################

cat << 'EOF' > docs/architecture/08_cost_performance_tradeoffs/README.md
# Cost and Performance Trade-offs

## What Problem Does It Solve

This topic explains how to balance performance, complexity, and cost in data platforms.

## Why It Matters

The best architecture is the one that meets requirements with acceptable cost and operational burden.

## Typical Topics

- storage strategy
- compute strategy
- partition design
- file sizing
- workload tuning

## Interview Questions

- Why are small files a problem?
- What is partition explosion?
- When is Spark unnecessary?
- How do you balance latency and budget?

## Related Courses

See:

    resources.md

## Completion Checklist

- [ ] I understand common cost drivers
- [ ] I understand common performance bottlenecks
- [ ] I understand the small files problem
EOF

cat << 'EOF' > docs/architecture/08_cost_performance_tradeoffs/resources.md
# Learning Resources — Cost and Performance Trade-offs

## Articles

- small files problem
- partitioning strategy
- storage vs compute cost basics
- Spark tuning fundamentals

## Courses

### Coursera

Add optimization-related sections here.

### Udemy

Add Spark optimization and cloud cost sections here.

## Books

- Fundamentals of Data Engineering
EOF

########################################
# docs/architecture/09_architecture_case_studies
########################################

cat << 'EOF' > docs/architecture/09_architecture_case_studies/README.md
# Architecture Case Studies

## What Problem Does It Solve

Case studies help translate theory into real-world reasoning.

## Why It Matters

Architecture becomes easier to understand when you analyze how real companies solve data problems at scale.

## Suggested Case Studies

- Netflix data platform
- Uber streaming architecture
- Spotify data pipelines
- Airbnb analytics platform

## Completion Checklist

- [ ] I analyzed at least one real architecture
- [ ] I can explain its main components
- [ ] I can identify trade-offs
EOF

cat << 'EOF' > docs/architecture/09_architecture_case_studies/resources.md
# Learning Resources — Architecture Case Studies

## Suggested Sources

Use engineering blogs, conference talks, and architecture write-ups from technology companies.

## Candidate Companies

- Netflix
- Uber
- Spotify
- Airbnb
- LinkedIn
- Shopify
EOF

########################################
# docs/architecture/adr
########################################

cat << 'EOF' > docs/architecture/adr/README.md
# Architecture Decision Records

This directory contains architecture decisions used across the repository.

The goal is to document not only what was built, but why specific design choices were made.

## Suggested Reading Order

- 0001 Store Raw Data Before Transformation
- 0002 Separate Raw, Processed, and Curated Layers
- 0003 Choose Batch for Reporting Pipelines
- 0004 Use Kafka for Event Streaming
- 0005 Use Delta Lake for Lakehouse Tables
EOF

cat << 'EOF' > docs/architecture/adr/0001_store_raw_data_before_transformation.md
# ADR 0001: Store Raw Data Before Transformation

## Status

Accepted

## Context

Pipelines often need reprocessing, debugging, and auditability.

## Decision

Always store raw input data before transformations.

## Consequences

Benefits:

- reprocessing
- debugging
- source-of-truth retention

Drawbacks:

- more storage
- retention policy needs
EOF

cat << 'EOF' > docs/architecture/adr/0002_separate_raw_processed_curated_layers.md
# ADR 0002: Separate Raw, Processed, and Curated Layers

## Status

Accepted

## Context

Mixing source data, cleaned data, and business-ready data makes pipelines harder to manage.

## Decision

Separate data into raw, processed, and curated layers.

## Consequences

Benefits:

- clearer lifecycle
- easier debugging
- better governance
EOF

cat << 'EOF' > docs/architecture/adr/0003_choose_batch_for_reporting_pipelines.md
# ADR 0003: Choose Batch for Reporting Pipelines

## Status

Accepted

## Context

Many reporting workflows do not require real-time processing.

## Decision

Prefer batch architecture for reporting unless low latency is a real requirement.

## Consequences

Benefits:

- simpler architecture
- lower operational cost
- easier debugging
EOF

cat << 'EOF' > docs/architecture/adr/0004_use_kafka_for_event_streaming.md
# ADR 0004: Use Kafka for Event Streaming

## Status

Accepted

## Context

Some systems need low-latency event transport, replay, and multiple consumers.

## Decision

Use Kafka for event streaming workloads where these needs are important.

## Consequences

Benefits:

- replay
- decoupling
- multiple consumers

Drawbacks:

- more complexity
EOF

cat << 'EOF' > docs/architecture/adr/0005_use_delta_lake_for_lakehouse_tables.md
# ADR 0005: Use Delta Lake for Lakehouse Tables

## Status

Accepted

## Context

Plain Parquet files do not provide all table-management features needed for production lakehouse workflows.

## Decision

Use Delta Lake for production lakehouse tables.

## Consequences

Benefits:

- transactional reliability
- schema evolution
- merge support
EOF

########################################
# docs/system-design
########################################

cat << 'EOF' > docs/system-design/README.md
# System Design

This section contains system design notes for common data engineering scenarios.

The goal is to practice thinking in systems, not only in scripts or tools.

## Suggested System Design Topics

- batch ETL pipeline
- Kafka ingestion platform
- lakehouse + BI architecture
- streaming analytics platform
- hybrid batch + streaming platform
EOF

cat << 'EOF' > docs/system-design/batch-etl-template.md
# Batch ETL Design Template

## Problem Statement

Describe a batch data pipeline use case.

## Architecture

Source -> ingestion -> raw storage -> transformation -> curated data -> BI

## Interview Questions

- Why choose batch over streaming?
- What is the role of raw storage?
- How would you rerun the job safely?
EOF

cat << 'EOF' > docs/system-design/streaming-template.md
# Streaming Design Template

## Problem Statement

Describe a real-time or near real-time data use case.

## Architecture

Producers -> Kafka -> stream processing -> serving/storage

## Interview Questions

- When is streaming worth the complexity?
- What is replay?
- How do you handle duplicates?
EOF

cat << 'EOF' > docs/system-design/batch-etl.md
# Batch ETL System Design

## Problem Statement

Design a batch pipeline that ingests data from source systems, stores raw input, transforms it, and prepares curated outputs for reporting.

## Typical Architecture

    Source -> Ingestion -> Raw -> Transform -> Curated -> BI

## Interview Questions

- Why choose batch over streaming?
- What is the role of raw storage?
- How do you rerun a failed job safely?
EOF

cat << 'EOF' > docs/system-design/kafka-ingestion.md
# Kafka Ingestion System Design

## Problem Statement

Design a near real-time ingestion system that receives events from producers, transports them through Kafka, and processes them downstream.

## Typical Architecture

    Producers -> Kafka Topics -> Consumers -> Storage / Serving

## Interview Questions

- Why use Kafka instead of polling?
- What is a consumer group?
- Why do partitions matter?
EOF

cat << 'EOF' > docs/system-design/lakehouse-bi.md
# Lakehouse to BI System Design

## Problem Statement

Design a data platform that ingests raw data into a lakehouse and serves business-ready data to a BI tool.

## Typical Architecture

    Sources -> Bronze -> Silver -> Gold -> Semantic Layer -> Dashboards

## Interview Questions

- Why not connect BI directly to raw files?
- What is the purpose of bronze, silver, and gold?
- Why use a semantic layer?
EOF

cat << 'EOF' > docs/system-design/streaming-analytics.md
# Streaming Analytics System Design

## Problem Statement

Design a system that receives events continuously, processes them in near real time, and exposes analytics outputs.

## Typical Architecture

    Producers -> Kafka -> Stream Processing -> Analytical Storage -> Dashboard / Alerts

## Interview Questions

- Why is checkpointing important?
- How do you handle late or duplicate events?
- When is near real-time worth the complexity?
EOF

########################################
# docs/case-studies
########################################

cat << 'EOF' > docs/case-studies/README.md
# Case Studies

This section contains architecture case studies and design breakdowns.

The goal is to learn architecture by analyzing real or realistic systems.

## Suggested Topics

- streaming event platform
- batch lakehouse platform
- analytics serving architecture
- startup data stack
- enterprise multi-team data platform
EOF

cat << 'EOF' > docs/case-studies/case-study-template.md
# Case Study Title

## Background

Describe the business or technical context.

## Problem

Describe the data challenge.

## Architecture Overview

Describe the main components and data flow.

## Technologies Used

List the tools used in the system.

## Trade-Offs

Describe benefits and drawbacks.

## Lessons Learned

Summarize what this case study taught you.
EOF

########################################
# docs/trade-offs
########################################

cat << 'EOF' > docs/trade-offs/README.md
# Trade-Offs

This section is dedicated to one of the most important architecture skills:

understanding trade-offs.

Architecture is not choosing the best tool in general.
Architecture is choosing the best fit for a specific situation.

## Suggested Trade-Off Notes

- Kafka vs batch ingestion
- Spark vs pandas
- Delta vs Iceberg
- dbt vs SQL scripts
- Airflow vs cron
- Flink vs Spark Structured Streaming
EOF

cat << 'EOF' > docs/trade-offs/trade-off-template.md
# Trade-Off Title

## Decision

Describe the decision being evaluated.

## Context

Explain the use case and constraints.

## Option A

### Benefits

- item 1
- item 2

### Drawbacks

- item 1
- item 2

## Option B

### Benefits

- item 1
- item 2

### Drawbacks

- item 1
- item 2

## Recommendation

Explain which option is better in this context.
EOF

echo "Docs created successfully."