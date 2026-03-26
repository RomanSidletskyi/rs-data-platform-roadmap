# Topic Design Checklist

Use this checklist before creating a production topic.

## Why This Matters

Many Kafka problems are created before the first event is ever published.

Weak topic design usually causes:

- unclear ownership
- poor event naming
- bad partition-key choice
- replay limitations
- downstream confusion about topic purpose

So a topic should not be created only because a team needs "somewhere to send messages."

It should exist for a clear architectural reason.

## Questions

- what business domain does the topic belong to?
- who owns the contract?
- what is the event meaning?
- what key supports ordering and partitioning?
- is the topic event history or latest-state snapshot?
- how long should retention last?
- what consumers are expected?
- how will replay be used?

## Extended Checklist

Before creating a topic, force yourself to answer all of the following.

### 1. Domain And Meaning

- is this a domain topic, an integration topic, a CDC topic, or a state-snapshot topic?
- does the name reflect business meaning or only technical convenience?
- could a new engineer understand the topic purpose from the name alone?

### 2. Ownership

- which team owns schema evolution?
- which team approves breaking changes?
- who is responsible when a downstream consumer breaks after a producer change?

### 3. Event Model

- are events immutable business facts or mutable snapshots?
- do consumers need full history or only latest state?
- is compaction appropriate or harmful?

### 4. Partitioning

- which key protects correctness?
- which key protects scaling?
- is there hot-partition risk because of low cardinality or dominant entities?

### 5. Retention And Replay

- how long do events need to stay in Kafka?
- what replay scenarios are realistic?
- if a consumer fails for 10 days, can it still recover from Kafka alone?

### 6. Consumer Expectations

- who are the first known consumers?
- is this topic designed for one team today but likely to become a platform topic later?
- do consumers need schema-governed contracts or only lightweight internal conventions?

## Good Example

- topic: `sales.order_events`
- owner: sales platform team
- key: `order_id`
- retention: long enough for recovery and replay

Why it is strong:

- name reflects bounded context and event purpose
- ownership is clear
- key supports order-local correctness
- retention choice is tied to recovery and backfill needs

## Bad Example

- topic: `all_messages`
- owner: unclear
- key: random
- retention: chosen without recovery thinking

Why it is weak:

- topic name hides semantics
- ownership disputes are guaranteed later
- random key may break entity-local ordering
- retention is treated as ops trivia instead of architecture

## Example Topic Decisions

### Orders

- topic: `sales.order_events`
- key: `order_id`
- purpose: domain event history

### Customer Profile Snapshot

- topic: `crm.customer_profile_latest`
- key: `customer_id`
- purpose: latest-state compacted topic

### Raw CDC Stream

- topic: `cdc.orders_raw`
- key: database primary key
- purpose: integration feed, not automatically a clean domain API

## Anti-Patterns

- creating one generic topic per platform because naming is hard
- mixing unrelated domains into one topic because the payload is JSON anyway
- using key choice only for load spread while ignoring correctness needs
- keeping retention short because storage seems expensive without checking replay needs

## Rule

Create a topic only when you can defend its meaning, ownership, partition key, and replay policy clearly.