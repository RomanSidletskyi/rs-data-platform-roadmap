# 04 Kafka To Spark Lakehouse Pipeline Lab

## Project Goal

Design a Spark-centered pipeline that reads Kafka-style order events, normalizes them into bronze output, and builds a cleaner silver status layer for downstream analytics.

## Scenario

Kafka carries operational order events from several upstream services.

The platform wants Spark to:

- parse those messages
- normalize the event envelope
- quarantine bad records
- publish a replayable lakehouse layer
- derive a simple silver projection for downstream teams

## Project Type

This folder is a guided project, not a ready solution.

The starter assets help you reason about:

- event ingestion into analytical storage
- bronze and silver responsibilities
- schema-shape validation
- replay and late-event implications

If you want a ready implementation afterwards for comparison, use the separate sibling reference project:

- `06-spark-pyspark/pet-projects/reference_example_kafka_to_spark_lakehouse_pipeline_lab`

## Expected Deliverables

- a Kafka-to-Spark ingestion design
- bronze record shape with metadata fields
- silver model definition with explicit grain
- invalid-record isolation strategy
- note about replay and downstream contract behavior

## Starter Assets Already Provided

- `.env.example`
- `src/normalize_kafka_orders_to_bronze.py`
- `src/build_silver_order_status.py`
- `data/sample_kafka_order_events.jsonl`
- `data/sample_bad_kafka_order_events.jsonl`
- `tests/fixture_expected_bronze_output.json`
- `tests/fixture_expected_silver_output.json`
- `tests/verify_kafka_to_spark_assets.sh`
- `src/README.md`
- `data/README.md`
- `tests/README.md`
- `config/README.md`
- `docker/README.md`
- `architecture.md`

## Definition Of Done

The lab demonstrates Spark as the bridge between event ingestion and durable analytical layers rather than as an isolated transformation script.