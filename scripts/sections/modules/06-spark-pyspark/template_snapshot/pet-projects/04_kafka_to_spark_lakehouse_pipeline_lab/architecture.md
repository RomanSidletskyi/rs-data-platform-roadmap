# Architecture Note

## Target Flow

1. Kafka-style event envelopes arrive from upstream services
2. Spark parses and validates envelope fields and payload shape
3. valid records are normalized into a bronze lakehouse layer
4. bad records are isolated for review
5. a silver status view is derived for downstream analytical use

## Core Design Questions

- what metadata must be preserved in bronze?
- what business grain belongs in silver?
- how should duplicates and replay windows be handled?
- when should downstream consumers read bronze versus silver?