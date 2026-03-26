# Solution

## Task 1 — Materialization comparison

| Case | Recommended materialization | Why it fits | Physical behavior in Snowflake | Performance and debugging impact |
| --- | --- | --- | --- | --- |
| Staging model | `view` | Keeps raw standardization lightweight and always current | Snowflake stores view definition, not a fully persisted copy | Cheap storage, easy to inspect, but repeated downstream queries can re-execute logic |
| Small dimension | `table` | Stable lookup dataset reused by many downstream consumers | Snowflake materializes table data on build | Faster reads and easier debugging because the output is persisted |
| Large fact table | `incremental` | Rebuilding everything each run is expensive and slow | Snowflake updates only new or changed slices based on incremental logic | Strong runtime and cost benefits, but requires careful correctness design |
| Helper transformation used once | `ephemeral` | Avoids creating a warehouse object for a tiny single-use step | SQL is inlined into the downstream compiled query | Keeps warehouse cleaner, but debugging compiled SQL becomes harder |

When `ephemeral` becomes a bad idea:

- when the logic is reused in many downstream models
- when the generated SQL becomes very large and hard to debug
- when query plans become harder for the warehouse optimizer to handle
- when analysts need to inspect the intermediate result directly

## Task 2 — Dimension as a table

```sql
{{ config(materialized='table') }}

select
    customer_id,
    customer_name,
    customer_email,
    customer_country,
    customer_segment,
    first_order_at,
    last_order_at
from {{ ref('int_customers_latest') }}
```

Why a table is a better fit here:

- dimensions are often reused by many models and BI queries
- persisting the relation reduces repeated compute compared with a view
- debugging is easier because the dimension exists as a stable warehouse object

Example YAML:

```yaml
version: 2

models:
  - name: dim_customer
    description: Curated customer dimension for analytics and joins.
    columns:
      - name: customer_id
        description: Primary customer key.
        tests:
          - not_null
          - unique
```

## Task 3 — Incremental fact model

```sql
{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

with source_data as (

    select
        order_id,
        customer_id,
        order_amount,
        order_status,
        event_time,
        ingested_at
    from {{ ref('int_orders_enriched') }}

    {% if is_incremental() %}
      where ingested_at >= (
          select coalesce(dateadd(minute, -10, max(ingested_at)), '1970-01-01'::timestamp_ntz)
          from {{ this }}
      )
    {% endif %}

)

select *
from source_data
```

Why full refresh every run is a bad idea here:

- large fact tables usually dominate compute cost
- repeated full rebuilds increase runtime and warehouse contention
- many analytics jobs only need newly arrived or recently updated rows
- a small lookback window protects against late-arriving events while still avoiding full-table scans
