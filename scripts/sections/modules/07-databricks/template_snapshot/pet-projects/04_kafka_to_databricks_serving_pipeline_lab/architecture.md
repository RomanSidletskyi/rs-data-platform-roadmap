# Architecture

## Components

- Kafka-landed order events in storage
- Databricks normalization task
- Databricks gold serving task
- SQL warehouse or BI consumer

## Data Flow

1. landed events are read from storage
2. Databricks normalizes them into a silver-like layer
3. a gold serving table publishes latest or daily business view
4. downstream consumers query only the governed serving output

## Trade-Offs

- event freshness affects compute choice
- gold contract design affects BI stability
- backfill design matters when event logic changes