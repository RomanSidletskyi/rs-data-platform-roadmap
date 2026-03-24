# What Kafka Is And Is Not

## Why This Topic Matters

Kafka is frequently introduced with short slogans such as:

- distributed log
- event streaming platform
- pub/sub system

All of those are partly true, but none of them alone is enough.

If the learner keeps only the slogan and not the boundary, Kafka gets misused very quickly.

## What Kafka Is

Kafka is a durable event transport platform built around append-only logs.

Its practical job is to let producers publish records and let one or more independent consumer groups read those records at their own pace.

Kafka is strong when the system needs:

- continuous event flow
- decoupling between producers and consumers
- multiple downstream consumers for the same events
- replay within a retention window
- scalable parallel reads through partitions

In plain language:

- a producer writes an event
- Kafka stores the event in a topic partition
- consumers read events from their current offset position
- different consumer groups can read the same event stream independently

## What Kafka Is Not

Kafka is not:

- a relational database for final serving queries
- a replacement for every message queue
- a scheduler
- a warehouse transformation layer
- a full stream-processing engine by itself
- a guarantee that downstream systems are correct

Kafka can transport events correctly and still leave the whole business system incorrect if:

- the consumer is not idempotent
- schemas drift without control
- partitioning destroys ordering assumptions
- downstream storage cannot handle duplicates or retries safely

## Kafka Compared To Simpler Patterns

### Kafka vs polling

Polling means asking a source again and again whether something changed.

Kafka means the producer pushes events into a durable stream and consumers read from that stream.

Kafka is usually better than polling when:

- event frequency is continuous
- multiple downstream systems need the same changes
- replay matters
- low latency matters

Polling is often better when:

- updates are infrequent
- only one downstream reader exists
- the volume is small
- operational simplicity is more important than streaming capability

### Kafka vs queue

A classic queue is often optimized for one consumer path where the message is consumed and removed from the queue.

Kafka is optimized for shared event streams, replay, and multiple consumer groups.

That distinction matters.

If one producer emits order events and three downstream systems need them:

- fraud checks
- operational database updater
- analytics pipeline

Kafka is naturally stronger than a single-consumer queue model.

## Realistic Use Cases

Kafka is a good fit for:

- clickstream events from web or mobile apps
- IoT telemetry from many devices
- order, payment, and shipment event pipelines
- application audit events
- operational monitoring events
- near-real-time analytics ingestion

Kafka is often a bad fit for:

- one nightly file move
- one low-volume sync job
- simple database replication where a managed CDC tool already solves the problem more directly
- systems that do not need replay or multi-consumer decoupling

## Architecture View

Typical high-level shape:

    Producers
        ↓
    Kafka topics
        ↓
    Consumers / processing
        ↓
    Storage / serving
        ↓
    Applications / analytics / alerts

Kafka sits in the middle as transport and buffering.

It should usually not become the place where people try to solve every downstream modeling problem.

## Good Strategy

- use Kafka when decoupled event transport and replay actually matter
- define clearly who owns producers, schemas, topics, and downstream consumers
- treat Kafka as one layer in a larger architecture

## Bad Strategy

- introduce Kafka because it sounds more advanced than batch or polling
- store weakly defined JSON payloads with no contract discipline
- assume that transport guarantees automatically solve business correctness

## Small Cookbook Example

Scenario:

- checkout service emits `order_created`
- payment service emits `payment_captured`
- shipping service emits `shipment_dispatched`

Good Kafka-based design:

- domain events published to well-defined topics
- consumers subscribe independently
- analytics pipeline can replay events if needed
- operations system can process near-real-time changes without coupling directly to producer databases

Bad design:

- one giant `all_events` topic with random payload shapes
- no event versioning
- no partition-key strategy
- no replay plan

## Key Architectural Takeaway

Kafka is a transport and decoupling layer for event streams.

It is valuable precisely because it is not the whole system.