# Solution

## Task 1 — Incremental model with timestamp filter

```sql
{{
    config(
        materialized='incremental',
        unique_key='order_id',
        on_schema_change='sync_all_columns'
    )
}}

with source_data as (

    select
        order_id,
        customer_id,
        order_status,
        order_amount,
        updated_at,
        ingested_at
    from {{ ref('stg_orders') }}

    {% if is_incremental() %}
      where updated_at >= (
          select coalesce(dateadd(minute, -10, max(updated_at)), '1970-01-01'::timestamp_ntz)
          from {{ this }}
      )
    {% endif %}

)

select *
from source_data
```

Why `{{ this }}` matters:

- it points to the currently built relation in the warehouse
- it allows the model to compare new source data with the already materialized target table
- without `{{ this }}`, incremental logic cannot inspect prior build state cleanly

## Task 2 — Lookback windows and late-arriving data

Why late-arriving data breaks naive incrementals:

- if the filter is only `updated_at > max(updated_at)`, rows that arrive out of order can be skipped forever
- ingestion delays, source retries, and event replay are common in production

Recommended strategy:

- use a small lookback window such as 10 or 30 minutes
- re-read a recent slice on every run
- combine this with a merge strategy or deterministic deduplication on the target key

Example concept:

```sql
where updated_at >= (
    select dateadd(minute, -10, max(updated_at))
    from {{ this }}
)
```

Trade-off:

- slightly more repeated work
- much safer correctness for delayed events

## Task 3 — CDC architecture options

Comparison:

| Pattern | Strength | Weakness | Best fit |
| --- | --- | --- | --- |
| Timestamp incremental | Simple and easy to explain | Can miss out-of-order updates without lookback | Append-heavy event pipelines |
| Merge on business key | Handles updates more explicitly | More complex warehouse behavior and tuning | Mutable facts or dimension maintenance |
| Snapshot-based history | Preserves change history over time | Adds storage and modeling complexity | Slowly changing dimensions and auditability |

Practical guidance:

- use timestamp incremental when ingestion is append-first and update semantics are limited
- use merge when business keys can be corrected or updated after first load
- use snapshots when historical version tracking is a real business requirement

## Task 4 — dbt and Kafka relationship

Correct explanation:

- dbt does not read from Kafka directly
- Kafka events must first land in a warehouse table through an ingestion service
- dbt then transforms the landed records in micro-batches using standard warehouse queries

So the real platform flow is:

    Kafka
        ↓
    ingestion consumer / connector
        ↓
    Snowflake RAW table
        ↓
    dbt staging / intermediate / marts

Why this matters operationally:

- dbt is a transformation framework, not a stream processor
- streaming systems handle transport and landing
- dbt adds modeling, testing, lineage, and repeatable batch transformation on top of landed data
