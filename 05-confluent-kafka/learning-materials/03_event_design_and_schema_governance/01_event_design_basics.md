# Event Design Basics

## Why This Topic Matters

Kafka can transport events very well.

But if the events themselves are badly designed, the platform becomes noisy, ambiguous, and expensive to evolve.

Weak event design causes problems such as:

- unclear downstream meaning
- broken replay logic
- schema drift
- topic ownership conflicts
- duplicated business logic across consumers

That is why event design is not just naming.

It is part of architecture.

## What An Event Should Represent

A good event should communicate that something meaningful happened in a system.

Typical examples:

- order created
- payment captured
- shipment dispatched
- user logged in
- page viewed
- device reported temperature

An event should usually describe:

- what happened
- to which entity it happened
- when it happened
- enough metadata for safe downstream handling

## Events vs Commands

This distinction matters.

An event usually means:

- something already happened

A command usually means:

- please do something

Event examples:

- `order_created`
- `payment_captured`

Command examples:

- `create_order`
- `capture_payment`

Kafka topics can carry both in some systems, but mixing them casually often weakens clarity.

For a learning roadmap, event-first design is usually the better foundation.

## Good Event Shape

Reasonable example:

```json
{
  "event_id": "evt-1001",
  "event_type": "order_created",
  "event_time": "2026-03-24T10:15:00Z",
  "order_id": "ord-501",
  "customer_id": "cust-77",
  "amount": 149.90,
  "currency": "EUR"
}
```

Why this shape is useful:

- clear business event type
- stable entity identifiers
- explicit event time
- event ID available for idempotency and tracing

## Weak Event Shape

Bad example:

```json
{
  "type": "data",
  "id": "123",
  "payload": {
    "x": 1,
    "y": 2,
    "z": "foo"
  }
}
```

Problems:

- unclear meaning
- weak field names
- unclear business entity
- poor long-term readability
- downstream consumers must guess semantics

## Design Questions For Every Event

Before publishing an event, ask:

- what business fact does this represent?
- who owns the event contract?
- which entity identifier is primary?
- which fields are required for downstream correctness?
- what field enables idempotency or dedup?
- what will happen during replay or reprocessing?

## Example 1: Clickstream Event

```json
{
  "event_id": "evt-page-17",
  "event_type": "page_viewed",
  "event_time": "2026-03-24T11:00:00Z",
  "user_id": "user-21",
  "session_id": "sess-8",
  "page_url": "/checkout",
  "device_type": "mobile"
}
```

What makes it useful:

- event meaning is clear
- analytics and operational consumers can both use it
- session and user boundaries are visible

## Example 2: IoT Telemetry Event

```json
{
  "event_id": "evt-temp-9001",
  "event_type": "temperature_reported",
  "event_time": "2026-03-24T11:01:00Z",
  "device_id": "sensor-44",
  "temperature_c": 23.7,
  "site_id": "warehouse-2"
}
```

What matters here:

- device identity
- measurement timestamp
- stable measurement field names

## Example 3: Payment Event

```json
{
  "event_id": "evt-pay-300",
  "event_type": "payment_captured",
  "event_time": "2026-03-24T11:05:00Z",
  "payment_id": "pay-300",
  "order_id": "ord-501",
  "amount": 149.90,
  "currency": "EUR",
  "provider": "stripe"
}
```

What makes this production-shaped:

- event can be joined to order flows
- provider context exists
- amount and currency are explicit

## Good Strategy

- publish events with clear business meaning
- use stable identifiers and explicit timestamps
- design for replay, dedup, and long-term readability

## Bad Strategy

- publish opaque generic payloads
- force consumers to reverse-engineer meaning
- keep changing field semantics without contract control

## Key Architectural Takeaway

Strong Kafka systems start with strong events, not only strong brokers.