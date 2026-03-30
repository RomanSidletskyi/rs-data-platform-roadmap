# Architecture

## Reference Shape

1. Raw bucket prefix receives append-only source files
2. Spark registers and writes Iceberg tables through Glue catalog
3. `raw_orders_events` preserves source event history
4. `curated_orders_current` exposes one accepted row per order grain
5. `dim_customer_history` exposes Type 2 customer attribute history
6. Trino or Athena read curated tables through the same Glue-backed metadata

## Why This Shape Is Used

- raw replay remains intact
- current truth does not depend on consumers reconstructing CDC
- historical customer analysis is isolated to a dedicated table
- the catalog is shared across engines instead of hidden in one Spark job