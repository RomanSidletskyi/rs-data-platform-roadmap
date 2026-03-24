# Architecture — Snowflake dbt Warehouse Foundation

## Components

- Snowflake raw tables for orders, customers, and products
- dbt sources and staging models
- dbt intermediate models for deduplication and enrichment
- marts for dimensions and facts
- docs and tests as first-class warehouse assets

## Data Flow

1. Raw operational tables already exist in Snowflake
2. staging models standardize naming and typing
3. intermediate models apply reusable business logic
4. marts publish dimensions and facts for analytics consumers
5. tests and docs validate and explain the final warehouse graph
