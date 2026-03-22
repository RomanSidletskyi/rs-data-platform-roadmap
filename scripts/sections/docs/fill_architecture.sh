#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="docs-fill-architecture"
REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
SECTION_ROOT="$REPO_ROOT/docs/architecture"


log "Creating docs architecture files..."

########################################
# docs/architecture/README.md
########################################


cat <<'EOF' > "$SECTION_ROOT/README.md"
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

cat <<'EOF' > "$SECTION_ROOT/01_foundations/README.md"
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

cat << 'EOF' > "$SECTION_ROOT/01_foundations/resources.md"
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

cat << 'EOF' > "$SECTION_ROOT/02_batch_architecture/README.md"
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

cat << 'EOF' > "$SECTION_ROOT/02_batch_architecture/resources.md"
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

cat <<'EOF' > "$SECTION_ROOT/03_streaming_architecture/README.md"
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

cat << 'EOF' > "$SECTION_ROOT/03_streaming_architecture/resources.md"
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

cat << 'EOF' > "$SECTION_ROOT/04_lakehouse_architecture/README.md"
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

cat << 'EOF' > "$SECTION_ROOT/04_lakehouse_architecture/resources.md"
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

cat <<'EOF' > "$SECTION_ROOT/05_serving_and_bi_architecture/README.md"
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

cat << 'EOF' > "$SECTION_ROOT/05_serving_and_bi_architecture/resources.md"
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

cat << 'EOF' > "$SECTION_ROOT/06_data_governance_security/README.md"
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

cat << 'EOF' > "$SECTION_ROOT/06_data_governance_security/resources.md"
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

cat << 'EOF' > "$SECTION_ROOT/07_scalability_reliability/README.md"
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

cat << 'EOF' > "$SECTION_ROOT/07_scalability_reliability/resources.md"
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

cat << 'EOF' > "$SECTION_ROOT/08_cost_performance_tradeoffs/README.md"
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

cat << 'EOF' > "$SECTION_ROOT/08_cost_performance_tradeoffs/resources.md"
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


cat << 'EOF' > "$SECTION_ROOT/09_architecture_case_studies/README.md"
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

cat << 'EOF' > "$SECTION_ROOT/09_architecture_case_studies/resources.md"
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

cat << 'EOF' > "$SECTION_ROOT/adr/README.md"
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

cat << 'EOF' > "$SECTION_ROOT/adr/0001_store_raw_data_before_transformation.md"
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

cat << 'EOF' > "$SECTION_ROOT/adr/0002_separate_raw_processed_curated_layers.md"
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

cat << 'EOF' > "$SECTION_ROOT/adr/0003_choose_batch_for_reporting_pipelines.md"
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

cat << 'EOF' > "$SECTION_ROOT/adr/0004_use_kafka_for_event_streaming.md"
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

cat << 'EOF' > "$SECTION_ROOT/adr/0005_use_delta_lake_for_lakehouse_tables.md"
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


echo "Docs architecture created successfully."