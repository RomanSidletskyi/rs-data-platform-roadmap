# Streaming Analytics System Design

## Problem Statement

Design a system that receives events continuously, processes them in near real time, and exposes analytics outputs.

## Typical Use Cases

- live KPI monitoring
- operational alerts
- clickstream or telemetry aggregation
- near-real-time business dashboards

## Typical Architecture

    Producers -> Kafka -> Stream Processing -> Analytical Storage -> Dashboard / Alerts

## Core Components

- event producers
- Kafka or event backbone
- stream-processing engine
- analytical serving or alerting store
- dashboard or alert layer

## Why Each Component Exists

### Stream Processing

Handles continuous aggregation, enrichment, and stateful logic.

### Analytical Storage

Exposes processed outputs in a form that dashboards or alerts can consume.

## When To Use It

- analytics must update continuously
- the business value falls sharply if data is delayed too much
- several consumers depend on recent outputs

## When Not To Use It

- daily reporting is enough
- event volume is low and batch is simpler
- the team does not need the operational burden of low-latency processing

## Failure Points

- late or duplicate events corrupt aggregates
- checkpoint or state recovery is weak
- dashboard consumers read unstable real-time outputs without guardrails

## Observability

Watch:

- consumer lag
- checkpoint and state health
- output freshness
- alerting false positives or gaps

## Interview Questions

- Why is checkpointing important?
- How do you handle late or duplicate events?
- When is near real-time worth the complexity?

## Read With

- `README.md`
- `../trade-offs/flink-vs-spark-structured-streaming.md`
- `../case-studies/02_streaming_event_backbone_for_ecommerce.md`
