# Batch ETL System Design

## Problem Statement

Design a batch pipeline that ingests data from source systems, stores raw input, transforms it, and prepares curated outputs for reporting.

## Typical Use Cases

- daily business reports
- nightly data warehouse refresh
- hourly synchronization
- historical backfills
- periodic API ingestion

## Example Architecture

    Source Systems
        ->
    Ingestion Layer
        ->
    Raw Storage
        ->
    Transformation Layer
        ->
    Curated Layer
        ->
    BI / Analytics

## Core Components

- source systems
- ingestion job
- raw storage
- transformation logic
- curated output
- scheduler
- monitoring and logging

## Why Each Component Exists

### Source Systems

Provide original business or operational data.

### Ingestion Layer

Moves data from source to storage.

### Raw Storage

Preserves original data for reruns, debugging, and auditability.

### Transformation Layer

Cleans, validates, and reshapes data.

### Curated Layer

Makes data ready for reporting and downstream analytics.

### Scheduler

Runs pipelines on a defined cadence.

### Monitoring and Logging

Helps detect failures and understand what happened.

## Data Flow

1. extract data from the source
2. store raw input
3. validate and clean records
4. transform into business-friendly structures
5. write curated outputs
6. refresh downstream consumers

## When To Use This Design

- reporting is not real-time
- business can tolerate delay
- pipeline logic is easier to manage in batches
- cost matters more than low latency

## When Not To Use This Design

- fraud detection
- live monitoring
- instant event reaction
- user-facing real-time decisions

## Trade-Offs

Benefits:

- simpler architecture
- easier reruns and backfills
- lower operational complexity
- often cheaper

Drawbacks:

- higher latency
- delayed visibility
- repeated full refreshes can be expensive if not optimized

## Failure Handling

Typical strategies:

- retries
- idempotent writes
- raw data retention
- reruns from source or raw layer
- logging and run summaries

## Common Mistakes

- no raw layer
- no incremental strategy
- directly writing to final reporting layer from source
- no rerun safety
- no separation between raw and curated data

## Interview Questions

- Why choose batch over streaming?
- What is the role of raw storage?
- How do you rerun a failed job safely?
- What is the difference between full refresh and incremental load?
- Why separate raw and curated layers?

## Related Repository Work

- real-projects/01_python_sql_etl
- 01-python/pet-projects/01_api_to_csv_pipeline
- docs/architecture/02_batch_architecture
