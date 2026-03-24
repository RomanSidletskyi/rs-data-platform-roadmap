# Incremental Models and CDC Patterns

## Task 1 — Build a Timestamp-Based Incremental Model

### Goal

Learn the classic dbt incremental pattern.

### Input

Use a staging table with columns:

- order_id
- customer_id
- amount
- ingested_at

### Requirements

Write an incremental model that:

- uses `materialized='incremental'`
- reads from the staging model
- loads full data on first run
- loads only new data on later runs
- uses `{{ this }}`

### Expected Output

A working incremental model.

### Extra Challenge

Add a 10-minute lookback window and explain why it is safer than strict max timestamp logic.

--------------------------------------------------

## Task 2 — Compare merge vs append vs delete+insert

### Goal

Understand different incremental strategies.

### Input

Compare these strategies for a fact table with late updates:

- merge
- append
- delete+insert

### Requirements

For each strategy explain:

- how it behaves
- when it is safe
- when it is dangerous
- what kind of source pattern it fits

### Expected Output

A detailed comparison.

### Extra Challenge

Write a config block for each strategy.

--------------------------------------------------

## Task 3 — Design Two CDC Patterns

### Goal

Understand how dbt participates in CDC but does not necessarily own it.

### Input

Design two architectures:

1. Kafka → raw table → dbt incremental by ingested_at
2. raw table → Snowflake stream → staging table → dbt

### Requirements

Explain for each architecture:

- where changes are captured
- what dbt reads
- why one pattern may be simpler
- why stream-to-staging is often safer in production than direct stream consumption

### Expected Output

Two architecture explanations with flow diagrams in markdown.

### Extra Challenge

Add a note about what happens if a developer runs the incremental model for the first time in a new dev schema.

