# DBT Basics and Project Structure

## Task 1 — Explain Where dbt Fits in a Data Platform

### Goal

Understand the exact role of dbt inside a modern data platform.

### Input

You have the following architecture:

    Kafka / APIs / OLTP DBs
            ↓
    Databricks / Python ingestion
            ↓
    Snowflake raw layer
            ↓
    dbt
            ↓
    BI / API / analytics

### Requirements

Write a short explanation that answers:

- what dbt is responsible for
- what dbt should not be responsible for
- why dbt is usually placed after ingestion
- how dbt differs from Spark / Databricks
- why dbt is strong in Snowflake-centered architectures

### Expected Output

A markdown note with a clear architecture explanation.

### Extra Challenge

Add a short paragraph explaining why dbt is better for warehouse business logic than putting everything into notebooks.

--------------------------------------------------

## Task 2 — Create a Standard dbt Project Skeleton

### Goal

Learn the standard project structure of a dbt project.

### Input

Create a structure that includes:

- models
- macros
- tests
- seeds
- snapshots
- analyses

### Requirements

Write the expected folder tree of a dbt project and explain what each folder is used for.

### Expected Output

A markdown document with a project tree and explanations.

### Extra Challenge

Add a second version of the tree that also separates `staging`, `intermediate`, and `marts`.

--------------------------------------------------

## Task 3 — Describe Layered Modeling

### Goal

Understand why staging, intermediate, and marts should be separate.

### Input

You have raw orders data coming from Kafka in Snowflake.

### Requirements

Describe:

- what should happen in staging
- what should happen in intermediate
- what should happen in marts
- what should not happen in staging
- why this separation helps debugging and maintenance

### Expected Output

A markdown explanation with concrete examples.

### Extra Challenge

Add a simple end-to-end chain:

    raw → stg_orders → int_orders → fct_orders

and explain what each model does.

