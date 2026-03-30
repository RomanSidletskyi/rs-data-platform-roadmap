# Contract

## Required Tables

### `raw.order_events`

Purpose:

- append-only preservation of incoming order change events

Contract idea:

- not a final BI serving table
- used for replay, diagnostics, and lineage

### `analytics.fct_orders_current`

Purpose:

- current-state fact table for accepted order truth

Contract idea:

- one accepted row per `order_id`
- supports late corrections and delete semantics

### `analytics.dim_customer_history`

Purpose:

- Type 2 customer history table

Contract idea:

- historical customer attributes by business-valid time
- one current row at a time per `customer_id`

## Contract Warning

Do not put unstable raw payload fields directly into curated consumer-facing contracts without clear justification.