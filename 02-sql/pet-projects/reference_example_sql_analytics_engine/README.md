# Reference Example - SQL Analytics Engine

This folder contains a ready comparison implementation for the guided SQL analytics project.

Its purpose is:

- self-checking after attempting the guided project
- showing one credible layered SQL shape for analytics outputs
- preserving a concrete example of reusable analytical query design

You should attempt the guided project first:

- `02-sql/pet-projects/01_sql_analytics_engine`

Only after that should you compare your implementation with this reference example.

## What This Reference Example Demonstrates

- a reusable KPI layer
- customer and product analytics separated from shared metric logic
- one behavior layer for funnel and retention outputs
- reconciliation checks that protect business meaning

## Folder Overview

- `src/kpi_layer.sql` for reusable KPI and daily revenue logic
- `src/customer_product_analytics.sql` for customer and product outputs
- `src/behavior_analytics.sql` for funnel and retention outputs
- `tests/reconciliation_checks.sql` for validation queries
- `data/assumptions.md` for explicit business rules behind the example

## Why This Is A Good Reference Shape

- business filters are made explicit
- grain changes are visible through CTE boundaries
- final outputs are separated by use case instead of hidden in one giant query
- validation is treated as part of the analytics layer, not as an afterthought

## How To Compare With Your Own Solution

When comparing this reference example with your own implementation, focus on:

- whether your revenue logic uses one stable business definition
- whether your intermediate grain changes are easy to follow
- whether funnel and retention definitions are documented clearly
- whether your checks would catch common business or data-quality mistakes
