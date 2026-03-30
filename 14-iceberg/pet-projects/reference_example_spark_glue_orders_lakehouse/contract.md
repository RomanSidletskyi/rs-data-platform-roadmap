# Contract

## Table Contracts

### raw_orders_events

- append-only
- replayable
- not the main BI-serving table

### curated_orders_current

- one row per order at accepted serving grain
- updated by merge logic
- default table for operational analytics

### dim_customer_history

- many rows per customer over time
- explicit effective dating semantics
- used only for historical attribute analysis