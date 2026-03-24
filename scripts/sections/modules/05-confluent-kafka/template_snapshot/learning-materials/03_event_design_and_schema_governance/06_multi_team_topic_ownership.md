# Multi-Team Topic Ownership

## Why This Topic Matters

Kafka becomes strategically important when many teams rely on it.

That is exactly when weak ownership becomes dangerous.

## Ownership Questions

For every important topic, the platform should be able to answer:

- who owns the topic?
- who owns the schema?
- who approves changes?
- who monitors downstream breakage?
- who decides retention and replay policy?

Without clear answers, incident response becomes chaotic.

## Example

Topic:

- `sales.order_events`

Possible ownership model:

- sales platform team owns event publication and contract
- analytics team consumes for warehouse landing
- fraud team consumes for detection
- search team consumes for indexing

This is healthy only if the publishing team understands it owns the contract impact, not just the producer code.

## Bad Ownership Model

- infra team owns Kafka cluster
- no one owns topic meaning
- any producer changes payloads freely
- consumer teams discover breakage after deployment

This leads to platform-level fragility.

## Topic Review Questions

When introducing or changing a topic, review:

- domain boundary
- event meaning
- partition-key choice
- retention requirement
- compatibility rules
- expected consumers
- replay expectations

## Good Strategy

- separate cluster ownership from event-contract ownership
- keep domain teams responsible for event meaning
- document consumers and compatibility expectations

## Key Architectural Takeaway

Kafka clusters may be shared infrastructure, but topic semantics must still have clear business ownership.