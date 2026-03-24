# 04 Kafka To Postgres Reliable Sink Lab

## Project Goal

Build a reliable sink pattern from Kafka into PostgreSQL with retries, DLQ, and idempotent thinking.

## Scenario

An operational team needs Kafka events to land in PostgreSQL for serving and operational queries.

The pipeline must:

- consume events safely
- survive transient database failures
- avoid poisoning the whole consumer loop with bad records
- reduce duplicate side effects when retries happen

## Project Type

This folder is a guided project, not a ready solution.

If you want a ready implementation afterwards for comparison, use the separate sibling reference project:

- `05-confluent-kafka/pet-projects/reference_example_kafka_to_postgres_reliable_sink_lab`

## Expected Deliverables

- consumer-to-Postgres sink design
- retry and DLQ policy
- idempotency strategy
- note about lag and sink bottlenecks
- short runbook for common failure modes

## Starter Assets Already Provided

- `.env.example`
- `src/order_sink_helpers.py`
- `src/preview_sink_decisions.py`
- `data/sample_order_events.jsonl`
- `data/sample_bad_order_events.jsonl`
- `data/sample_target_table_schema.sql`
- `tests/fixture_expected_valid_upsert_record.json`
- `tests/fixture_expected_dlq_record.json`
- `src/README.md`
- `data/README.md`
- `tests/README.md`
- `config/README.md`
- `docker/README.md`
- `architecture.md`

## Definition Of Done

The lab demonstrates that end-to-end correctness depends on sink design, not only on Kafka transport.