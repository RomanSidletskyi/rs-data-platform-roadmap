# Reference Example - Kafka To Postgres Reliable Sink Lab

This folder contains a ready implementation kept as a reference example.

Its purpose is:

- self-checking after attempting the guided project
- comparing sink-validation and DLQ-design decisions
- preserving a reusable reliability pattern for Kafka-to-database ingestion

You should attempt the guided project first:

- `05-confluent-kafka/pet-projects/04_kafka_to_postgres_reliable_sink_lab`

Only after that should you compare your implementation with this reference example.

## What This Reference Example Demonstrates

- validation and normalization before sink writes
- fixture-driven classification into valid upsert records and DLQ records
- sample duplicate events for idempotency discussion
- a small reliability-focused sink project shape

## Folder Overview

- `.env.example` for local broker and Postgres values
- `src/order_sink_helpers.py` for validation, upsert preparation, and DLQ record building
- `src/preview_sink_decisions.py` for previewing sink decisions without a live Kafka runtime
- `data/sample_order_events.jsonl` and `data/sample_bad_order_events.jsonl` as valid and invalid samples
- `data/sample_target_table_schema.sql` for the target sink shape
- `tests/fixture_expected_valid_upsert_record.json`, `tests/fixture_expected_dlq_record.json`, and `tests/verify_sink_decisions.sh` for smoke validation

## How To Run

Preview valid sink decisions:

```bash
python3 src/preview_sink_decisions.py data/sample_order_events.jsonl
```

Preview invalid sink decisions:

```bash
python3 src/preview_sink_decisions.py data/sample_bad_order_events.jsonl
```

Run the smoke check:

```bash
/bin/sh tests/verify_sink_decisions.sh
```

## What To Compare

When comparing this reference example with your own implementation, focus on:

- whether you validate required fields before building sink records
- whether your DLQ metadata is enough for incident triage
- whether your implementation makes idempotency and duplicate handling explicit