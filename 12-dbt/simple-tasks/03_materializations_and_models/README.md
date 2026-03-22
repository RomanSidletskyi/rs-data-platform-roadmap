# Materializations and Models

## Task 1 — Compare view, table, incremental, and ephemeral

### Goal

Build strong intuition about materializations.

### Input

You have four model types to compare:

- staging model
- small dimension
- large fact table
- helper transformation used only once

### Requirements

For each of the four cases, choose a materialization and explain:

- why it fits
- what the trade-offs are
- what happens physically in Snowflake
- how this choice affects performance and debugging

### Expected Output

A comparison table or structured markdown explanation.

### Extra Challenge

Add a section describing when `ephemeral` becomes a bad idea.

--------------------------------------------------

## Task 2 — Create a Dimension as a Table

### Goal

Practice a simple persisted dimension model.

### Input

Use `int_customers_latest` as an upstream model.

### Requirements

Write a `dim_customer.sql` model with:

- `materialized='table'`
- selected customer columns
- a short comment explaining why a table is better than a view in this case

### Expected Output

A dbt model for a dimension table.

### Extra Challenge

Add a YAML file with `unique` and `not_null` tests on `customer_id`.

--------------------------------------------------

## Task 3 — Create a Fact Model as Incremental

### Goal

Practice selecting the right materialization for large fact tables.

### Input

Use `int_orders_enriched` as the upstream model.

### Requirements

Write `fct_orders.sql` with:

- `materialized='incremental'`
- `unique_key='order_id'`
- incremental logic using `{{ this }}`
- a lookback window of 10 minutes

### Expected Output

A realistic incremental fact model.

### Extra Challenge

Explain why a full refresh on every run would be a bad idea for this fact table.

