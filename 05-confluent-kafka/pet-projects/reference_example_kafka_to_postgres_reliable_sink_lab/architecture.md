# Architecture

## Components

- Kafka source topic such as `sales.order_events`
- consumer group for sink processing
- PostgreSQL target table
- retry logic and DLQ topic
- optional dedup or idempotency table

## Data Flow

1. producer publishes business events to Kafka
2. sink consumer validates and transforms records
3. successful writes land in PostgreSQL
4. transient failures retry with bounds
5. permanent failures route to DLQ with metadata

## Trade-Offs

- stronger idempotency reduces duplicate business side effects
- retry behavior improves resilience but can increase lag
- PostgreSQL sink throughput can become the real bottleneck rather than Kafka itself