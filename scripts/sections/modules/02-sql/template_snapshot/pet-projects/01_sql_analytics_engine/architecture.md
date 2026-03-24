# Architecture - 01 SQL Analytics Engine

## Components

- transactional source tables
- event source tables
- reusable analytical transformations
- KPI outputs
- funnel and retention outputs
- validation queries

## Target Project Shape

The intended implementation should include:

- one clear source-understanding layer
- one reusable analytical layer for shared logic
- final outputs for KPI, customer, product, funnel, and retention use cases
- validation notes that protect the analytical meaning of the outputs

## Data Flow

1. understand source grain and business definitions
2. standardize reusable filters and assumptions
3. build intermediate analytical logic such as daily revenue or customer-level revenue
4. publish reporting-ready query outputs
5. validate that outputs reconcile with the source business rules

## Modeling Rules

- final outputs should not depend on hidden assumptions
- ranking and deduplication logic should be deterministic
- shared business rules should be reused consistently across multiple outputs

## Trade-Offs

- layered SQL is easier to maintain than one giant query
- extra intermediate steps improve clarity but create more files to manage
- tight business definitions reduce ambiguity but require explicit documentation

## What Would Change In Production

- views or tables instead of loose query files
- formal data quality tests
- scheduler or dbt orchestration around refreshes
- warehouse-specific physical optimization
