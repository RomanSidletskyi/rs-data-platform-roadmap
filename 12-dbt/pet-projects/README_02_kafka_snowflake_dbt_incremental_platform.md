# Project 02 — Kafka → Snowflake → dbt Incremental Platform

## Project Goal

Build a realistic event-driven analytics pipeline where Kafka events land in Snowflake and dbt transforms them using incremental logic.

This project is designed to teach how dbt fits into near-real-time analytics architectures without pretending that dbt itself is a streaming engine.

--------------------------------------------------

## Why this project matters

This is one of the most important production dbt patterns.

In many real systems:

- Kafka carries business events
- ingestion jobs land those events in Snowflake raw tables
- dbt processes them in micro-batches
- marts are updated every few minutes

This project teaches how to design that pattern correctly.

--------------------------------------------------

## Core Architecture

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
    BI / analytics / downstream consumers

--------------------------------------------------

## Optional advanced architecture

More advanced production variant:

    Kafka
        ↓
    ingestion job
        ↓
    Snowflake raw table
        ↓
    Snowflake stream
        ↓
    landing / staging table
        ↓
    dbt incremental transformations
        ↓
    marts

This project may include both designs and compare them.

--------------------------------------------------

## Business Scenario

Imagine an e-commerce system that publishes order events into Kafka.

Events may include:

- order created
- order paid
- order shipped
- order cancelled

A warehouse analytics team needs:

- near-real-time order analytics
- current order state reporting
- reliable event processing
- no duplicate facts
- late-arriving events handled safely

--------------------------------------------------

## Recommended raw table schema

Snowflake raw event table should include:

technical metadata:
- ingested_at
- topic
- partition
- offset

raw payload:
- payload VARIANT

Example payload fields:
- event_id
- order_id
- customer_id
- status
- amount
- event_time

--------------------------------------------------

## Recommended modeling flow

    raw.kafka_orders
        ↓
    stg_kafka_orders
        ↓
    int_orders_dedup
        ↓
    int_orders_latest_state
        ↓
    fct_orders_events
        or
    fct_orders_current

--------------------------------------------------

## What the project should demonstrate

This project should clearly demonstrate:

- source YAML for Kafka raw table
- parsing JSON from VARIANT
- preserving technical metadata
- deduplication logic
- incremental processing
- use of `{{ this }}`
- late-arriving data protection with lookback windows
- tests for keys and valid status values
- realistic micro-batch design

--------------------------------------------------

## Recommended incremental design

The key fact table should be incremental.

Recommended pattern:

- `materialized='incremental'`
- stable `unique_key`
- timestamp filter on `ingested_at`
- lookback window for safe reprocessing

Example design ideas:

- unique key for current-state fact: `order_id`
- unique key for event fact: `event_id`
- lookback window: 10 minutes

--------------------------------------------------

## Why lookback matters

Strict incremental logic based only on:

    max(ingested_at)

can lose late-arriving events.

A safer pattern is:

- take max processed timestamp
- subtract a safety window
- deduplicate again downstream

This project should explicitly implement and explain that.

--------------------------------------------------

## Optional stream design

If you include Snowflake Streams in the project, explain:

- stream tracks changes on a raw table
- dbt usually should not own the whole CDC mechanism
- stream-to-staging is often safer than direct stream consumption in complex pipelines
- dbt is still doing micro-batch transformation, not true streaming

--------------------------------------------------

## Recommended tests

At minimum:

- `not_null` on event_id / order_id
- `unique` on chosen primary key
- `accepted_values` on status
- relationships if dimensions are included

Useful singular tests:

- no negative amount
- no impossible event timestamps
- no duplicate latest state after dedup logic

--------------------------------------------------

## Recommended project structure

    models/
        sources/
            raw_sources.yml

        staging/
            stg_kafka_orders.sql
            staging.yml

        intermediate/
            int_orders_dedup.sql
            int_orders_latest_state.sql
            intermediate.yml

        marts/
            facts/
                fct_orders_events.sql
                fct_orders_current.sql
            marts.yml

    macros/
    tests/
    seeds/

--------------------------------------------------

## Recommended extensions

After the base version works, extend the project with:

- separate dimension models
- order status transition validation
- CI/CD workflow
- selector-based frequent jobs
- warehouse routing for heavy vs light models
- comparison between direct raw incremental and stream-assisted landing

--------------------------------------------------

## What this project teaches

This project should make the learner comfortable with:

- dbt incremental architecture
- Kafka-to-Snowflake landing patterns
- JSON staging models
- CDC-aware warehouse design
- micro-batch analytics
- safe event deduplication patterns

--------------------------------------------------

## Success Criteria

The project is successful if:

- raw events are documented
- staging cleanly parses payloads
- duplicates are handled explicitly
- incremental models process only new data safely
- marts are usable for analytics
- documentation clearly explains why dbt here is micro-batch, not streaming

