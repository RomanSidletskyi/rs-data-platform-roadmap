# 02 Clickstream Session Pipeline

## Project Goal

Build a clickstream pipeline where Kafka carries raw events and a downstream layer reasons about sessions and analytics.

## Scenario

An e-commerce site publishes page views, product clicks, cart actions, and checkout events.

The platform must:

- ingest high-volume events
- choose a defensible key such as `session_id` or `user_id`
- support multiple consumers such as analytics and monitoring
- prepare the stream for later sessionization or enrichment in Spark or Flink

## Project Type

This folder is a guided project, not a ready solution.

If you want a ready implementation afterwards for comparison, use the separate sibling reference project:

- `05-confluent-kafka/pet-projects/reference_example_clickstream_session_pipeline`

## Expected Deliverables

- raw clickstream event design
- topic-key choice and justification
- a simple producer and at least one consumer or landing path
- explanation of why Kafka is transport and not the full session engine
- note about replay and lakehouse landing

## Starter Assets To Prepare

- `.env.example`
- `src/README.md`
- `data/README.md`
- `tests/README.md`
- `config/README.md`
- `docker/README.md`
- `architecture.md`

## Definition Of Done

The lab shows a credible raw event pipeline for clickstream data and clearly separates Kafka transport from downstream sessionization and analytics responsibilities.