# Streaming Event Backbone For E-Commerce

## Background

An e-commerce company has separate services for:

- orders
- payments
- shipments
- notifications
- fraud checks

Several downstream consumers need the same business events at low latency.

## Problem

The company wants to decouple systems without losing correctness.

The platform must support:

- several independent consumers
- replay for rebuilding downstream projections
- domain ownership boundaries
- low-latency operational reactions

## Architecture Overview

Typical shape:

    order-service -> sales.order_events
    payment-service -> payments.payment_events
    shipment-service -> logistics.shipment_events

    topics
        -> support timeline consumer
        -> analytics landing consumer
        -> notification consumer
        -> fraud consumer

Each domain publishes its own facts.

Downstream consumers correlate entities, often by `order_id`.

## Why This Shape Makes Sense

- several teams need the same stream independently
- operational reaction time matters for notifications, fraud, and support views
- replay supports new consumers or bug recovery
- domain-aligned topics reduce ownership confusion

## Technologies Used

Possible technology shape:

- Kafka or another durable event backbone
- stream-processing or consumer applications
- analytical landing storage
- serving database or support timeline projection

## Main Trade-Offs

Benefits:

- strong decoupling in time between producers and consumers
- easy fan-out to several downstream use cases
- replay and rebuild are possible when downstream systems fail
- good fit for event-driven business flows

Drawbacks:

- duplicates, replay, and sink correctness become real design concerns
- ownership must be disciplined or topic semantics decay
- debugging across distributed consumers is harder than direct synchronous flows

## Simpler Alternative

A simpler alternative is direct service-to-service APIs plus scheduled analytical loads.

That can be enough when:

- only one or two consumers exist
- replay is not needed
- low latency is not critical

It becomes weak when several consumers need the same facts independently.

## What To Look At In Review

- which system owns each business fact
- whether topics align to bounded contexts
- what partition key protects local correctness
- what sink design makes replay safe
- what the DLQ and retry story looks like

## What Would Be Bad Here

- one generic all-events topic
- one domain service publishing guessed facts for another domain
- no idempotency strategy in sinks
- assuming transport durability alone guarantees business correctness

## Lessons Learned

- streaming architecture is strongest when fan-out, replay, and low-latency reaction all matter together
- event backbone quality depends on ownership, contracts, and sink correctness as much as on Kafka itself

## Read With

- `../architecture/03_streaming_architecture/README.md`
- `../system-design/kafka-ingestion.md`
- `../system-design/streaming-analytics.md`
- `../trade-offs/kafka-vs-batch-ingestion.md`
- `../trade-offs/flink-vs-spark-structured-streaming.md`