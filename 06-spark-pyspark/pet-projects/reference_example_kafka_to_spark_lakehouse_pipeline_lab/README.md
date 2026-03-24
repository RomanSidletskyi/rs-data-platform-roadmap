# Reference Example - Kafka To Spark Lakehouse Pipeline Lab

This folder contains a ready reference implementation for the guided Kafka-to-Spark lakehouse lab.

You should attempt the guided project first:

- `06-spark-pyspark/pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab`

## What This Reference Example Demonstrates

- bronze normalization of Kafka-style event envelopes
- silver projection with one row per order
- deterministic fixture-driven validation for both layers
- a concrete example of Spark's role between streaming ingestion and analytical storage

## Folder Overview

- `.env.example` for local path placeholders
- `src/normalize_kafka_orders_to_bronze.py` for bronze normalization
- `src/build_silver_order_status.py` for silver status projection
- `data/sample_kafka_order_events.jsonl` as replayable valid event input
- `tests/fixture_expected_bronze_output.json` and `tests/fixture_expected_silver_output.json` as deterministic expectations
- `tests/verify_kafka_to_spark_assets.sh` for smoke validation
- `architecture.md` for target flow reasoning