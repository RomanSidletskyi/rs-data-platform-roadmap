# Producer Flow And Delivery

## Why This Topic Matters

Many learners first meet Kafka through the producer API.

That is useful, but dangerous if they reduce producer behavior to:

- connect
- send
- done

In production, producer design affects:

- throughput
- latency
- duplicate risk
- ordering behavior
- retry behavior
- downstream correctness

## Producer Mental Model

A producer does not simply "drop a message into Kafka".

It usually does all of the following:

- serialize the payload
- choose a topic
- choose or derive a partition key
- send the record to Kafka
- wait for an acknowledgment according to configuration
- retry if needed

So producer behavior is part of delivery design, not just application plumbing.

## Core Questions Every Producer Must Answer

Before writing producer code, ask:

- what topic should this event go to?
- what event key should be used?
- what payload format should be used?
- what ordering assumptions matter downstream?
- what happens if the broker does not acknowledge in time?
- what happens if the send is retried?

These are architecture questions before they become code questions.

## Basic Flow Example

Simple order event:

```json
{
  "event_id": "evt-1001",
  "order_id": "ord-501",
  "event_type": "order_created",
  "amount": 149.90,
  "event_time": "2026-03-24T10:15:00Z"
}
```

Typical producer decision:

- topic: `sales.order_events`
- key: `ord-501`

Why key by order ID:

- all events for one order should stay in the same partition
- downstream consumers often need order-level ordering

## Producer Without Thoughtful Keying

Bad producer behavior:

- send all order events with no key
- let partition assignment vary randomly

Possible consequence:

- `order_created`
- `order_paid`
- `order_cancelled`

can land in different partitions, which makes order-level ordering weaker for downstream consumers.

## Acknowledgments And Reliability

Producer reliability depends partly on acknowledgment behavior.

At a simplified level:

- weaker acknowledgment settings may reduce latency but increase loss risk
- stronger acknowledgment settings improve durability confidence but may cost more latency

The learner does not need to memorize every config immediately.

But they should understand the architectural trade-off:

- lower latency
- versus stronger delivery confidence

## Retry Behavior

If a producer retries after a timeout or transient failure, duplicates may become possible depending on the design and configuration.

That means a producer cannot be reasoned about in isolation.

Producer retries affect downstream consumer design.

This is why idempotency is a system-level concern.

## Example 1: Clickstream Producer

Scenario:

- frontend emits page views
- events are high volume
- strict per-user ordering may not be critical for every downstream use case

Possible design:

- topic: `web.page_views`
- key: user ID or session ID

Trade-off:

- session ID improves session-local ordering
- user ID improves user-local grouping
- no key may spread load well but weakens order-related assumptions

## Example 2: Payment Event Producer

Scenario:

- payment lifecycle events are sensitive
- downstream state transitions must remain coherent

Possible design:

- topic: `payments.payment_events`
- key: payment ID

Why:

- keeps lifecycle events for one payment in the same partition
- helps downstream ordered processing assumptions

## Example 3: IoT Device Producer

Scenario:

- thousands of devices send telemetry continuously
- per-device ordering matters more than global ordering

Possible design:

- topic: `iot.device_events`
- key: device ID

Why:

- per-device event streams stay coherent
- partitions can still scale across many devices

## Good Producer Strategy

- choose keys according to downstream correctness needs
- use stable payload contracts
- document topic ownership and event meaning
- assume retries and transient failures will happen

## Bad Producer Strategy

- emit random JSON with no contract
- choose keys only for convenience
- ignore downstream ordering assumptions
- assume retries are harmless because Kafka is "reliable"

## Key Architectural Takeaway

Producer design is part of event architecture.

Topic, key, payload, and retry behavior all shape downstream correctness.