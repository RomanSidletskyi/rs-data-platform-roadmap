# DBT Sources and Staging Layer

## What sources are

Sources represent raw tables already existing in the warehouse.

They are declared in YAML and referenced via `source()`.

Example:

    {{ source('raw', 'kafka_orders') }}

This is better than hardcoding:

    RAW_DB.RAW.kafka_orders

because it gives:

- lineage
- documentation
- centralized metadata
- source freshness checks
- reusable naming

--------------------------------------------------

## Detailed source YAML example

    version: 2

    sources:
      - name: raw
        description: Raw ingestion layer for Kafka and source systems
        database: RAW_DB
        schema: RAW
        loader: databricks
        freshness:
          warn_after: {count: 30, period: minute}
          error_after: {count: 60, period: minute}
        loaded_at_field: ingested_at

        tables:
          - name: kafka_orders
            description: Raw Kafka order events
            identifier: kafka_orders
            tags: ['kafka', 'raw']
            meta:
              owner: data-platform
              domain: sales
            columns:
              - name: ingested_at
                description: Timestamp when event landed in Snowflake
                tests:
                  - not_null

              - name: payload
                description: Raw JSON payload

              - name: topic
                description: Kafka topic name

              - name: partition
                description: Kafka partition number

              - name: offset
                description: Kafka offset

--------------------------------------------------

## Source YAML fields explained

`version`
- schema version for dbt YAML files

`sources`
- list of source groups

`name`
- logical source name used in `source()`

`description`
- docs text for dbt docs

`database`
- source database

`schema`
- source schema

`loader`
- optional metadata to indicate the ingesting system

`freshness`
- optional freshness SLA rules

`loaded_at_field`
- column used for freshness checking

`tables`
- list of actual source tables

`identifier`
- physical object name if different from YAML name

`tags`
- grouping and selection labels

`meta`
- arbitrary metadata

`columns`
- column-level docs and tests

--------------------------------------------------

## Staging layer purpose

Staging should do:

- JSON parsing
- field renaming
- type casting
- light normalization
- technical cleanup

Staging should avoid:

- heavy business joins
- broad aggregations
- final KPI logic

--------------------------------------------------

## Staging example

    select
        payload:order_id::string           as order_id,
        payload:customer_id::string        as customer_id,
        payload:amount::number(18,2)       as amount,
        payload:status::string             as order_status,
        payload:event_time::timestamp_ntz  as event_time,
        ingested_at,
        topic,
        partition,
        offset
    from {{ source('raw', 'kafka_orders') }}
    where payload is not null

--------------------------------------------------

## Why staging should stay simple

Because staging is:

- the bridge from raw to modeled data
- easier to debug if it is close to source structure
- easier to test
- easier to reuse across downstream models

