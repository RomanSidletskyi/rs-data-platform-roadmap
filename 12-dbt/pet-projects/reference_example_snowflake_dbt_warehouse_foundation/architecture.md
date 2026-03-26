# Architecture - Reference Example Snowflake dbt Warehouse Foundation

## Components

- Snowflake raw tables for orders, customers, and products
- dbt source definitions with freshness metadata
- staging models that standardize raw data
- one intermediate enrichment model
- marts for customer and order analytics

## Data Flow

1. raw tables are declared through `sources.yml`
2. staging models rename and type the raw data
3. an intermediate model centralizes reusable enrichment logic
4. marts publish a customer dimension and an incremental order fact
5. tests validate the key business assumptions

## Key Decisions

- staging is kept as `view` materializations
- marts are persisted because they are reused downstream
- the fact uses an incremental pattern with a small lookback window
- schema naming is environment-aware through a macro, not hardcoded SQL

## Trade-Offs

- one intermediate model is enough for a reference example, but a larger project would likely need more
- the example favors readability over complete production complexity
- the incremental strategy is intentionally small, but still realistic enough to explain late-arrival handling
