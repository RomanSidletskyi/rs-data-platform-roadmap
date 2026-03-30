# Pipeline Flow

## Raw To Curated Flow

1. land source files unchanged into raw storage
2. append source rows into `raw_orders_events`
3. build the latest accepted order state in a staging relation
4. `MERGE` the staging relation into `curated_orders_current`
5. derive customer attribute changes and update `dim_customer_history`
6. run compaction and snapshot cleanup on mutation-heavy curated tables

## Why `MERGE` Is Not Used Everywhere

- raw history is append-only by design
- current-state serving needs merge semantics
- Type 2 history needs state transition logic, not simple append of unreviewed source payloads