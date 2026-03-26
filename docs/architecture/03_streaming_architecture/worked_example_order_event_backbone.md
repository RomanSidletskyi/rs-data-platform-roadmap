# Worked Example - Order Event Backbone

## Scenario

An e-commerce platform has separate services for:

- orders
- payments
- shipments
- notifications

Several downstream consumers need the same flow of business facts.

## Why Streaming Is A Good Fit

- several consumers need the same events independently
- operational reaction time matters
- replay is useful for rebuilding downstream projections
- services should stay decoupled in time

## Architecture Shape

    order-service -> sales.order_events
    payment-service -> payments.payment_events
    shipment-service -> logistics.shipment_events

    topics
        -> support timeline consumer
        -> analytics landing consumer
        -> notification consumer
        -> fraud or risk consumer

## What Good Looks Like

- each domain service publishes its own facts
- topics align with bounded contexts
- downstream systems correlate by stable business keys such as `order_id`
- replay rebuilds consumers without changing source-domain ownership

## What Bad Looks Like

- one generic `all_events` topic
- one service publishes guesses about another service's domain
- consumers depend on weakly governed JSON payloads
- no DLQ, replay, or idempotency story

## Questions To Review

- what is the source of truth outside the stream
- which consumers need independent full reads
- what partition key preserves local correctness
- what happens if a sink succeeds but offset commit fails

## Why This Example Matters

It shows that streaming architecture is not just Kafka transport.

It is about ownership, fan-out, replay, and correctness under retry and failure.

## Key Takeaway

Streaming is strongest when one flow of facts must drive several independent low-latency consumers and the system is designed for replay and domain clarity from the start.