# 06 Snowflake Open Table And Refresh

## Overview

These tasks focus on Snowflake decisions that are architectural rather than purely syntactic.

The main themes are:

- when to publish as Iceberg
- when to stay on native tables
- when external tables are enough
- when dynamic tables are the right refresh model

---

## Task 1 — Choose Native Table vs Snowflake-managed Iceberg

### Goal

Decide how to publish a curated orders dataset.

### Input

Scenario:

- finance uses Snowflake
- a Spark-based ML team needs the same curated order facts
- the dataset is a stable daily contract, not a temporary intermediate model

### Requirements

- choose native Snowflake table or Snowflake-managed Iceberg
- justify the choice in 5 to 7 bullet points
- explain one situation where your answer would change

### Expected Output

- one decision
- one architecture justification

### Extra Challenge

Explain why external tables are not the strongest final answer for this scenario.

---

## Task 2 — Design A Snowflake-managed Iceberg Table

### Goal

Write a first credible publish definition for an open-format curated table.

### Input

Dataset:

- daily order facts

Columns:

- `order_id`
- `customer_id`
- `order_date`
- `net_amount`
- `gross_amount`
- `currency`
- `load_ts`

### Requirements

- write a `CREATE ICEBERG TABLE` statement
- include `EXTERNAL_VOLUME`, `CATALOG`, and `BASE_LOCATION`
- explain why this table should be treated as a contract boundary

### Expected Output

- one table definition
- one short contract explanation

### Extra Challenge

Explain why publishing unstable intermediate fields into this table is risky.

---

## Task 3 — Choose Dynamic Tables vs Tasks

### Goal

Pick the right refresh tool for a derived table.

### Input

Scenario A:

- simple deduplicated staging table
- target freshness 5 minutes

Scenario B:

- workflow requires branching logic, notifications, and downstream side effects

### Requirements

- choose dynamic tables or tasks for each scenario
- explain the difference in control model

### Expected Output

- one decision for Scenario A
- one decision for Scenario B
- one comparison paragraph

### Extra Challenge

Explain why “everything low latency should be a dynamic table” is a weak rule.

---

## Task 4 — Create A Dynamic Table For Daily Revenue

### Goal

Write a dynamic table definition for a small mart.

### Input

Source table:

- `stg_orders_clean`

Output grain:

- revenue per hour

### Requirements

- use `TARGET_LAG = '15 minutes'`
- specify a warehouse
- aggregate revenue by hour
- explain why this is a reasonable dynamic-table use case

### Expected Output

- one `CREATE DYNAMIC TABLE` statement
- one short reasoning note

### Extra Challenge

Explain which business question you would ask before reducing target lag from 15 to 5 minutes.

---

## Task 5 — Separate Exploration Layer From Publish Layer

### Goal

Design a small Snowflake data flow.

### Input

Required elements:

- external table for partner files
- native raw table
- curated publish table

### Requirements

- describe the data flow in 5 to 8 steps
- explain which layer is exploratory, which is operational, and which is contractual
- name one anti-pattern this separation avoids

### Expected Output

- one mini architecture flow
- one anti-pattern explanation

### Extra Challenge

Add where dynamic tables could fit in this flow without replacing every other layer.

---

## Task 6 — Set Freshness By Business Need

### Goal

Assign reasonable target lags to three tables.

### Input

Tables:

- `stg_orders_clean`
- `int_customer_daily_metrics`
- `mart_finance_monthly_rollup`

### Requirements

- propose a target lag for each table
- justify each lag by consumer need and cost
- explain why using the same lag for every table is usually a bad idea

### Expected Output

- three target lag decisions
- one short design rationale

### Extra Challenge

Explain which table you would move back to scheduled batch first if warehouse cost becomes too high.