# Solution

## Task 1 — Detailed source YAML

```yaml
version: 2

sources:
  - name: raw
    description: Raw ingestion layer for Kafka order events landed in Snowflake.
    database: RAW_DB
    schema: RAW
    tags: [raw, kafka, orders]
    meta:
      owner: data-platform
      domain: commerce
    tables:
      - name: kafka_orders
        description: Raw Kafka messages for order lifecycle events.
        loaded_at_field: ingested_at
        freshness:
          warn_after: {count: 15, period: minute}
          error_after: {count: 60, period: minute}
        columns:
          - name: ingested_at
            description: Timestamp when the ingestion service wrote the record to Snowflake.
            tests:
              - not_null
          - name: payload
            description: JSON payload with business event content.
          - name: topic
            description: Kafka topic name used by the source producer.
          - name: partition
            description: Kafka partition number for the event.
          - name: offset
            description: Kafka offset used for ordering inside a partition.
            tests:
              - not_null
```

Why this is production-shaped:

- `loaded_at_field` enables source freshness checks
- `freshness` turns ingestion lag into an operational signal
- `meta` and `tags` help ownership and selection conventions
- column descriptions make the raw contract easier to understand in docs

## Task 2 — Staging model for Kafka JSON

```sql
with source_data as (

    select *
    from {{ source('raw', 'kafka_orders') }}
    where payload is not null

), parsed as (

    select
        ingested_at,
        topic,
        partition,
        offset,
        payload:order_id::string as order_id,
        payload:customer_id::string as customer_id,
        try_cast(payload:amount as number(18,2)) as order_amount,
        payload:status::string as order_status,
        try_to_timestamp_ntz(payload:event_time::string) as event_time
    from source_data

)

select
    order_id,
    customer_id,
    order_amount,
    order_status,
    event_time,
    ingested_at,
    topic,
    partition,
    offset
from parsed
```

Why `where payload is not null` belongs in staging:

- staging is the first standardization boundary
- invalid raw records should be filtered or flagged before downstream joins and marts
- keeping this rule close to raw parsing prevents repeated defensive logic in every downstream model

## Task 3 — Model YAML for the staging model

```yaml
version: 2

models:
  - name: stg_kafka_orders
    description: Clean typed staging model for raw Kafka order events.
    columns:
      - name: order_id
        description: Business order identifier extracted from JSON payload.
        tests:
          - not_null
      - name: customer_id
        description: Customer identifier associated with the order.
      - name: order_amount
        description: Monetary amount of the order event.
      - name: order_status
        description: Business status value reported by the source system.
        tests:
          - accepted_values:
              values: ['created', 'paid', 'shipped', 'cancelled']
      - name: event_time
        description: Event timestamp from the business payload.
      - name: ingested_at
        description: Warehouse landing timestamp for the raw event.
        tests:
          - not_null
      - name: topic
        description: Kafka topic name.
      - name: partition
        description: Kafka partition number.
      - name: offset
        description: Kafka offset within the partition.
```

Why model YAML does not decide target schema or database:

- model YAML describes metadata, tests, and documentation
- final placement is controlled by `profiles.yml`, `dbt_project.yml`, folder config, and optional model `config()`
- keeping routing separate from documentation makes project structure easier to manage at scale
