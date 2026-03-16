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
