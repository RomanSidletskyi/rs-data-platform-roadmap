# Learning Resources - Streaming Architecture

## How To Use These Resources

Streaming resources are most useful when you read them with one question in mind:

- what real requirement forces this complexity?

For every resource, capture:

- what latency or decoupling problem is being solved
- what correctness risk appears because of streaming
- what would be simpler if batch were acceptable

## What To Search For

- Kafka fundamentals
- event-driven architecture
- delivery guarantees
- consumer groups and offsets
- streaming replay and idempotency
- when not to use Kafka

## Best Resource Types

- architecture talks from teams running event backbones
- articles that explain failure handling, not only happy-path messaging
- postmortems or operational write-ups about lag, DLQ, replay, and skew

## Real Examples To Pair With Reading

- clickstream pipeline
- IoT ingestion
- order, payment, and shipment event backbone
- operational monitoring stream with replay needs

## Books

- Designing Event-Driven Systems
- Designing Data-Intensive Applications
