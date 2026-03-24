# Architecture

## Components

- landed order-event input
- Databricks normalization task
- gold serving-table publish task
- SQL warehouse consumer surface

## Data Flow

1. landed events are normalized into a stable silver-like shape
2. serving projection publishes one row per order
3. SQL consumers read the curated output through warehouse-serving boundaries

## Trade-Offs

- latest-state projection is strong for operations dashboards
- event-history consumers may still need a different layer
- serving contracts must stay more stable than landing contracts