# Kafka Vs Batch Ingestion

## Decision

Choose between event-stream ingestion and scheduled batch ingestion.

## Context

This decision appears when designing operational or analytical data movement.

The wrong choice usually creates either unnecessary complexity or unacceptable delay.

## Decision Criteria

- required freshness
- replay and fan-out needs
- operational complexity tolerance
- workload frequency and scale

## Option A

### Benefits

- supports low-latency reaction
- good for several downstream consumers
- replay and event-history patterns are natural

### Drawbacks

- higher operational and design complexity
- duplicates, lag, and sink correctness become central concerns

## Option B

### Benefits

- simpler to operate and reason about
- strong fit for reporting and scheduled analytical loads
- reruns and backfills are often easier to control

### Drawbacks

- weaker for near-real-time needs
- not ideal when many consumers need the same data continuously

## Recommendation

Choose Kafka or another event backbone when low latency, multi-consumer fan-out, or replayable event flows are core to the problem.

Choose batch when freshness can be scheduled and the main value is stable, reproducible analytical delivery.

## Revisit Trigger

Revisit this choice when downstream consumer count, latency pressure, or recovery requirements change materially.