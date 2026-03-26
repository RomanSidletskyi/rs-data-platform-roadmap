# Sources YAML and Staging

## Task 1 — Create a Detailed Source YAML

### Goal

Learn how to define raw source tables in dbt.

### Input

Assume you have a Snowflake table:

    RAW_DB.RAW.kafka_orders

with columns:

- ingested_at
- payload
- topic
- partition
- offset

### Requirements

Write a complete `sources.yml` entry that includes:

- source name
- database
- schema
- table name
- description
- loaded_at_field
- freshness
- column descriptions
- at least one test

### Expected Output

A valid dbt source YAML definition.

### Extra Challenge

Add tags and `meta` fields for owner and domain.

--------------------------------------------------

## Task 2 — Build a Staging Model for Kafka JSON

### Goal

Practice writing a clean staging model.

### Input

Assume `payload` is JSON with:

- order_id
- customer_id
- amount
- status
- event_time

### Requirements

Write a `stg_kafka_orders.sql` model that:

- reads from `source('raw', 'kafka_orders')`
- parses JSON fields
- casts types correctly
- renames fields into business-friendly names
- keeps technical metadata columns

### Expected Output

A realistic staging model in SQL.

### Extra Challenge

Add a `where payload is not null` filter and explain why it belongs in staging.

--------------------------------------------------

## Task 3 — Write Model YAML for the Staging Model

### Goal

Learn how model YAML differs from source YAML.

### Input

Use the staging model from Task 2.

### Requirements

Write a model YAML file that includes:

- model description
- column descriptions
- `not_null` tests for order_id and ingested_at
- an `accepted_values` test for status

### Expected Output

A valid YAML block for `stg_kafka_orders`.

### Extra Challenge

Explain in notes why model YAML does not decide the target schema or database.

