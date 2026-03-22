# Project 02 — Kafka → Snowflake → dbt Incremental Platform

## Project Goal

Build a realistic near-real-time analytics pipeline where event data from Kafka lands in Snowflake and is processed by dbt using incremental logic.

--------------------------------------------------

## Why this project matters

This project simulates a very realistic data engineering pattern:

- Kafka produces events
- ingestion lands them into a Snowflake raw table
- dbt processes only new records
- marts are refreshed in micro-batches

This is one of the most important practical dbt patterns in modern data platforms.

--------------------------------------------------

## Architecture

    Kafka
        ↓
    ingestion job
        ↓
    Snowflake raw table
        ↓
    dbt staging
        ↓
    dbt intermediate
        ↓
    incremental marts
        ↓
    BI / analytics

Optional advanced variant:

    raw table
        ↓
    Snowflake stream
        ↓
    staging landing table
        ↓
    dbt incremental marts

--------------------------------------------------

## What should be implemented

1. Define raw Kafka event source table in YAML
2. Create a staging model that parses JSON payloads
3. Add dedup logic in intermediate layer
4. Build an incremental fact model
5. Add lookback window handling
6. Add tests for keys and business status values
7. Document the micro-batch design

--------------------------------------------------

## Suggested source columns

Raw table should simulate fields such as:

- ingested_at
- payload
- topic
- partition
- offset

Payload may include:

- event_id
- order_id
- customer_id
- status
- amount
- event_time

--------------------------------------------------

## What this project teaches

- timestamp-based incremental loading
- late-arriving data handling
- why `{{ this }}` matters
- why lookback windows matter
- why dbt is micro-batch, not true streaming
- how dbt integrates with Kafka-based architectures without directly consuming Kafka

--------------------------------------------------

## Expected outcome

The learner should finish this project able to explain and implement a realistic event-driven dbt pipeline with Snowflake as the warehouse and incremental models as the transformation layer.

