# DBT Incremental Models

## Core idea

Incremental models process only new or changed data instead of recomputing everything.

This is critical for:

- large fact tables
- frequent micro-batch jobs
- Snowflake cost control
- lower runtime

--------------------------------------------------

## Basic pattern

    {{ config(
        materialized='incremental'
    ) }}

    select *
    from {{ ref('stg_orders') }}

    {% if is_incremental() %}
    where ingested_at > (
        select coalesce(max(ingested_at), '1900-01-01'::timestamp_ntz)
        from {{ this }}
    )
    {% endif %}

How it works:

first run:
- target does not exist
- `is_incremental()` is false
- dbt creates the table from full source data

next runs:
- target exists
- `is_incremental()` is true
- only new rows are processed

--------------------------------------------------

## Why `{{ this }}` matters

`{{ this }}` refers to the current target relation being built by dbt.

Example:

    from {{ this }}

means:

- query the target table of this model
- read already processed max timestamp
- compare incoming data against that state

This is the basis of state-aware pipelines.

--------------------------------------------------

## Lookback window

A strict max-timestamp filter can lose late-arriving records.

Better pattern:

    {% if is_incremental() %}
    where ingested_at >= (
        select coalesce(
            dateadd(minute, -10, max(ingested_at)),
            '1900-01-01'::timestamp_ntz
        )
        from {{ this }}
    )
    {% endif %}

Why:

- handles delayed ingestion
- handles retry scenarios
- protects against clock and scheduling skew

--------------------------------------------------

## Incremental strategies

Common strategies include:

- merge
- append
- delete+insert

dbt Snowflake supports these incremental strategies through model configs. :contentReference[oaicite:4]{index=4}

--------------------------------------------------

## merge

Best when:

- upsert behavior is needed
- rows can be updated
- `unique_key` is stable

Example:

    {{ config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='order_id'
    ) }}

--------------------------------------------------

## append

Best when:

- source is append-only
- duplicates are handled elsewhere
- no updates are needed

Example:

    {{ config(
        materialized='incremental',
        incremental_strategy='append'
    ) }}

--------------------------------------------------

## delete+insert

Best when:

- full row replacement is acceptable
- merge is not preferred
- target row sets are manageable

Example:

    {{ config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='order_id'
    ) }}

--------------------------------------------------

## Kafka landing pattern without streams

Typical flow:

    Kafka topic
        ↓
    raw table in Snowflake
        ↓
    dbt incremental by ingested_at
        ↓
    parsed staging
        ↓
    intermediate
        ↓
    marts

This is a standard micro-batch near-real-time pattern.

--------------------------------------------------

## Snowflake stream pattern

Another pattern:

    raw table
        ↓
    Snowflake stream
        ↓
    staging table fed by stream
        ↓
    dbt incremental models

Why usually better than reading the stream directly in a complex production pipeline:

- easier to debug
- easier to replay
- easier to restart
- lower risk of consuming change tracking incorrectly

dbt docs describe CDC with Snowflake Streams as one of the important near-real-time incremental patterns. :contentReference[oaicite:5]{index=5}

--------------------------------------------------

## Initial run problem in dev

If Ivan runs an incremental model for the first time in a personal dev schema and the target table does not exist, dbt performs a full create.

That means:

- runtime can be high
- cost can be high
- large source scans may happen

Common mitigations:

- clone prod objects into dev/qa
- create shared dev tables
- add limited initial-load filters for dev

