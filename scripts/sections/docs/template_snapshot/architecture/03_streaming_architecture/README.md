# Streaming Architecture

## What This Topic Is For

Streaming architecture is for systems where data must move continuously and the value of the system depends on low-latency reaction, decoupled consumers, or replayable event history.

The important lesson is not that streaming is modern.

The important lesson is when its additional complexity is actually justified.

## Typical Architecture

    Producers -> Kafka -> Stream Processing -> Storage / Serving -> Consumers

## When Streaming Is A Strong Fit

- near-real-time analytics
- event-driven systems
- clickstream analysis
- operational monitoring
- decoupled multi-consumer event backbones

## When Streaming Is A Weak Fit

- daily reporting
- simple one-time sync jobs
- low-frequency workloads
- teams that do not need replay or multi-consumer fan-out

## What To Pay Attention To

- whether low latency is truly required
- how ordering, duplicates, and replay affect correctness
- where stateful processing should live
- whether Kafka is being used as transport, as backbone, or both
- what sink behavior makes consumer recovery safe or unsafe

## Good Architecture Signals

- event contracts and ownership are clear
- processing responsibilities are separated from transport responsibilities
- lag, replay, and DLQ behavior are designed intentionally
- consumers remain correct under retry and rerun conditions

## Common Mistakes

- using Kafka because it sounds more scalable than batch
- confusing transport durability with business correctness
- placing too much stateful logic in ad hoc consumer scripts
- building streaming systems without a replay or idempotency story

## Real Examples To Think Through

- clickstream event backbone
- IoT telemetry ingestion
- fraud-monitoring event flow
- order, payment, and shipment event backbone across services

Worked example:

- `worked_example_order_event_backbone.md`

For each example, ask:

- what would batch fail to do well here
- which consumers need the stream independently
- what is the source of truth outside the stream

## Interview Questions

- When would you choose Kafka?
- What is the purpose of a consumer group?
- What are offsets?
- What is the difference between at-least-once and exactly-once?

## Read Next

- `resources.md`
- `anti-patterns.md`
- `worked_example_order_event_backbone.md`
- `../../system-design/README.md`
- `../../trade-offs/README.md`

## Completion Checklist

- [ ] I understand why streaming exists
- [ ] I can explain topics, partitions, and offsets
- [ ] I understand consumer groups
- [ ] I can explain when not to use streaming
