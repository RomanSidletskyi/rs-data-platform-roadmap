# Hybrid Batch And Streaming Platform Design

## Problem Statement

Design a platform where some workloads need near-real-time reaction while others need stable batch-oriented curation and reporting.

## Typical Use Cases

- operational alerting plus daily finance reporting
- real-time event ingestion plus scheduled business marts
- product telemetry plus curated historical analytics

## Example Architecture

    Sources / Producers
        ->
    Kafka or event backbone
        ->
    streaming consumers / alerts / operational projections
        ->
    raw analytical landing
        ->
    scheduled transformations
        ->
    curated marts and BI

## Core Components

- event or ingestion backbone
- operational low-latency consumers
- raw landing layer
- batch transformation layer
- curated serving layer

## Why Each Component Exists

### Event Backbone

Supports low-latency transport, fan-out, and replay.

### Streaming Consumers

Handle the use cases where reaction time matters immediately.

### Raw Landing Layer

Preserves durable history for later recomputation and analytics.

### Batch Transformation Layer

Builds stable, curated models without forcing every business question into continuous compute.

### Serving Layer

Exposes trustworthy business outputs for BI and downstream consumption.

## When To Use This Design

- one part of the business needs fast reaction
- another part needs stable curated analytics
- event history should serve both operational and analytical needs

## When Not To Use This Design

- everything is comfortably batch-oriented
- everything truly requires low-latency serving
- the team cannot yet operate both streaming and batch responsibilities safely

## Main Trade-Offs

Benefits:

- avoids forcing one latency model on all workloads
- supports both operational reaction and curated reporting
- allows replayable history to feed both paths

Drawbacks:

- more moving parts and ownership boundaries
- data contracts across streaming and batch layers must stay aligned
- teams can confuse what belongs in each path

## Failure Points

- streaming path correct but batch path stale
- raw landing preserved, but transformations lag or break
- business users consume operational projections as if they were curated truth

## Observability

Watch:

- consumer lag
- raw landing freshness
- batch schedule health
- curated mart completeness

## Read With

- `README.md`
- `../trade-offs/kafka-vs-batch-ingestion.md`
- `../case-studies/05_startup_data_stack_evolution.md`