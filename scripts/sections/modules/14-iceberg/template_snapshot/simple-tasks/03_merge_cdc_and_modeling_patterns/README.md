# 03 Merge CDC And Modeling Patterns

## Overview

These tasks focus on the hardest practical boundary in Iceberg work:

- when to stay append-only
- when to use `MERGE`
- when deletes are part of the contract
- when a table is a fact upsert table versus a dimension history table

The goal is not only to write mutation SQL.

The goal is to pick the right model for the business contract.

---

## Task 1 - Choose Snapshot Ingestion Versus CDC Ingestion

### Goal

Pick the right ingestion mental model.

### Input

Scenario A:

- upstream sends one full daily customer snapshot

Scenario B:

- upstream emits inserts, updates, and delete tombstones throughout the day

### Requirements

- choose snapshot-based or CDC-based ingestion for each scenario
- explain the write implication for each choice
- explain one danger of pretending a full snapshot feed is CDC

### Expected Output

- two ingestion decisions
- two short explanations

### Extra Challenge

Explain why snapshot ingestion can still require overwrite or reconciliation logic rather than simple append.

---

## Task 2 - Design A Current-State Fact Upsert Flow

### Goal

Propose a fact-table upsert pattern.

### Input

Table:

- `fct_orders`

Characteristics:

- late corrections exist
- deletes may arrive for canceled orders

### Requirements

- describe a 4 to 6 step flow from staging to curated fact table
- include deduplication before `MERGE`
- explain why this is a fact upsert problem rather than an SCD problem

### Expected Output

- one mini flow
- one semantic explanation

### Extra Challenge

Explain why keeping raw CDC separately is useful even if the curated fact table stores only current state.

---

## Task 3 - Write A Merge For Late Corrections

### Goal

Write a mutation-aware merge.

### Input

Target:

- `glue_prod.analytics.orders_curated`

Source temp view:

- `latest_orders_cdc`

Available source columns:

- `order_id`
- `customer_id`
- `order_ts`
- `order_date`
- `amount`
- `status`
- `event_ts`
- `op`

### Requirements

- update matched rows for `U` and `C`
- delete matched rows for `D`
- insert unmatched rows for `I`, `U`, `C`

### Expected Output

- one `MERGE` statement

### Extra Challenge

Explain why this table generally belongs on `v2` rather than `v1`.

---

## Task 4 - Choose Fact Upsert Versus SCD Type 2

### Goal

Choose the right modeling pattern.

### Input

Scenario A:

- need the latest valid order record for financial reporting

Scenario B:

- need to know what tier each customer had at any historical date

### Requirements

- choose fact upsert or SCD Type 2 for each scenario
- justify each choice in 3 to 5 bullets

### Expected Output

- two modeling decisions
- two short justifications

### Extra Challenge

Explain why Iceberg time travel is not the same thing as a proper Type 2 model.

---

## Task 5 - Design A Type 2 History Table

### Goal

Write a first credible Type 2 dimension schema.

### Input

Entity:

- customer

Attributes:

- `customer_id`
- `customer_name`
- `customer_tier`
- `country_code`

### Requirements

- include business key
- include surrogate key
- include validity columns
- include current-row flag

### Expected Output

- one `CREATE TABLE` statement

### Extra Challenge

Explain why a Type 2 table should not allow multiple current rows for one business key.

---

## Task 6 - Plan Post-Delete Maintenance

### Goal

Design the first maintenance response to delete-heavy tables.

### Input

Scenario:

- daily `MERGE` jobs produce many logical deletes
- read performance is degrading

### Requirements

- propose one compaction action
- propose one retention action
- explain why maintenance is a separate concern from business deletion semantics

### Expected Output

- one two-step maintenance plan
- one short explanation

### Extra Challenge

Explain one risk of expiring snapshots too aggressively after heavy mutation periods.