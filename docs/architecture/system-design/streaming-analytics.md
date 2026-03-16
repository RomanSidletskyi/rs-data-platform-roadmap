# Streaming Analytics System Design

## Problem Statement

Design a system that receives events continuously, processes them in near real time, and exposes analytics outputs for monitoring or business consumption.

## Typical Use Cases

- live dashboarding
- operational event monitoring
- website clickstream analysis
- IoT monitoring
- near real-time KPI tracking

## Example Architecture

    Producers
        ->
    Kafka
        ->
    Stream Processing
        ->
    Analytical Storage
        ->
    Dashboard / Alerts

## Core Components

- event producers
- broker
- stream processor
- checkpointing
- analytical storage
- dashboard or alerting layer

## Why Each Component Exists

### Event Producers

Send real-time activity into the system.

### Broker

Buffers and distributes events reliably.

### Stream Processing

Applies transformations, filters, enrichments, and aggregations.

### Checkpointing

Tracks progress and supports recovery.

### Analytical Storage

Stores processed results for fast queries.

### Dashboard / Alerts

Surfaces the latest metrics to users or systems.

## Data Flow

1. producers send events
2. events are stored in the broker
3. stream processor consumes events
4. aggregations or transformations are applied
5. processed results are stored
6. dashboards or alerts consume the latest outputs

## When To Use This Design

- low-latency visibility is needed
- events arrive continuously
- operational reaction time matters
- analytics should update frequently

## When Not To Use This Design

- daily reporting
- low event frequency
- use cases where delay is acceptable
- teams without operational capacity to support streaming

## Trade-Offs

Benefits:

- faster insight delivery
- continuous updates
- scalable event-driven processing

Drawbacks:

- higher complexity
- state and duplicate handling are harder
- monitoring and recovery require more discipline

## Failure Handling

Typical strategies:

- checkpointing
- idempotent writes
- DLQ for bad events
- replay from offsets
- lag monitoring

## Common Mistakes

- no state management strategy
- confusing raw events with aggregated outputs
- no checkpoint or replay plan
- exposing dashboards directly to unstable raw streams

## Interview Questions

- What is the difference between event streaming and streaming analytics?
- Why is checkpointing important?
- How do you handle late or duplicate events?
- Why can streaming dashboards be harder than batch dashboards?
- When is near real-time worth the complexity?

## Related Repository Work

- 05-confluent-kafka
- 06-spark-pyspark
- real-projects/07_kafka_databricks_powerbi
- docs/architecture/03_streaming_architecture
