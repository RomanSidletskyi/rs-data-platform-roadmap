# Assumptions

## Source Feeds

- `orders/` arrives daily as Parquet and is relatively stable
- `shipments/` arrives daily as JSON and has occasional additive schema drift
- `refunds/` arrives daily as CSV from an external partner and is the least reliable feed

## Layering Assumptions

- external tables are used for exploration and onboarding, not as the permanent serving layer
- native raw tables preserve lineage and replayability inside Snowflake
- the publish dataset is shared with a non-Snowflake engine, so open-table publication is justified

## Contract Assumptions

- publish grain is one row per order per business day
- internal helper columns such as intermediate dedup ranks stay out of the final publish contract
- publish freshness target is daily, not near-real-time