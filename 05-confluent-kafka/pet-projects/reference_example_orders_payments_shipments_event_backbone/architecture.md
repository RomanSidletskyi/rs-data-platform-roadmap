# Architecture

## Components

- order service and `sales.order_events`
- payment service and `payments.payment_events`
- shipment service and `logistics.shipment_events`
- downstream consumers such as analytics, support timeline, and fraud checks

## Data Flow

1. each domain service publishes its own events
2. Kafka topics preserve domain boundaries and fan out to consumers
3. downstream systems correlate entities using stable IDs
4. replay or backfill supports new consumer onboarding

## Correlation Model

- `order_id` is the main cross-domain business key
- payments may also carry `payment_id` for payment-domain ordering
- shipments may also carry `shipment_id` for logistics-domain ordering
- downstream journey builders correlate the domains through `order_id`

This is the core lesson of the lab: ownership stays separated by topic, while correlation happens downstream in consumer logic rather than by merging domains into one oversized source topic.

## Suggested Downstream Consumers

- support timeline consumer that builds one customer-facing order journey
- analytics landing consumer that builds event counts and latency metrics
- fraud or risk consumer that reacts only to the events it needs

## Replay Note

Replay should rebuild downstream views without changing upstream ownership boundaries.

If the support timeline is wrong, replay the consumer and rebuild the projection. Do not "fix" the architecture by asking one domain service to publish another domain's facts.

## Trade-Offs

- separate topics improve ownership clarity
- correlation across domains becomes a downstream design responsibility
- schema drift in one domain can impact many consumers if governance is weak