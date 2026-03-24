# Solution

Example platform shape:

- producer: order service
- topic: `sales.order_events`
- consumers: fraud scoring and analytics landing
- storage layer: lakehouse bronze table

Source-of-truth example:

- order service database remains the source of truth
- Kafka is the transport and event-history layer for integration

Replay safety requires:

- retained events still available
- consumers able to reread safely
- downstream writes idempotent or deduplicated