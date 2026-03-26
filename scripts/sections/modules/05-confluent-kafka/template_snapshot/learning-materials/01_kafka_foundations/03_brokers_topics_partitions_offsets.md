# Brokers, Topics, Partitions, And Offsets

## Why This Topic Matters

These four concepts are the mechanical core of Kafka.

If the learner confuses them, every later topic becomes blurry.

## Brokers

A broker is a Kafka server that stores data and serves clients.

In a real cluster, Kafka usually runs as multiple brokers.

Why multiple brokers exist:

- scale storage and traffic
- distribute partitions across machines
- improve resilience with replication

Architecturally, a broker is infrastructure.

It is not the same thing as a topic or partition.

## Topics

A topic is the named event stream that producers write into and consumers read from.

Examples:

- `clickstream.page_views`
- `sales.order_events`
- `payments.payment_events`

Good topic naming should help answer:

- what kind of event is this
- which domain owns it
- which consumers should care about it

Bad topic design usually creates confusion around ownership and payload meaning.

## Partitions

A topic is split into partitions.

Partitions exist for:

- horizontal scale
- parallel consumption
- ordered records within a partition

Important rule:

ordering is guaranteed only within a partition, not across the whole topic.

That means partition strategy directly affects correctness.

If an application assumes all events for one order must stay in order, then the partition key should usually route all events for that order to the same partition.

## Offsets

Each record in a partition has an offset.

Offset meaning:

- the record's position in that partition log

Offsets are per partition, not global across the topic.

This matters because:

- replay is per partition position
- lag is measured per partition position
- checkpointing and commits are partition-aware

## Practical Example

Suppose topic `sales.order_events` has 3 partitions.

Events might look like this:

- partition 0: order 1001, 1004, 1009
- partition 1: order 1002, 1005, 1010
- partition 2: order 1003, 1006, 1011

Inside each partition, offsets increase:

- partition 0: offsets 0, 1, 2
- partition 1: offsets 0, 1, 2
- partition 2: offsets 0, 1, 2

There is no single global topic offset.

## Why This Is Architecturally Important

Partition count and partition-key choice influence:

- throughput
- parallelism
- ordering behavior
- hot spots
- consumer scaling strategy

This is one of the main reasons Kafka topic design should be treated as architecture, not as a random implementation detail.

## Common Mistakes

- assuming one topic means one ordered stream globally
- choosing partition keys randomly
- under-partitioning high-volume topics
- over-partitioning without understanding operational cost

## Good Strategy

- choose topics by domain and event type intentionally
- choose partition keys according to downstream correctness and scale needs
- remember that offsets are partition-local positions

## Small Cookbook Example

For clickstream events:

- topic: `web.page_views`
- possible partition key: session ID or user ID

Trade-off:

- session ID helps per-session ordering
- user ID may help per-user ordering
- no key or poor key may create weak ordering for the queries the system actually needs

## Key Architectural Takeaway

Topics define stream boundaries, partitions define scale and ordering scope, and offsets define reader position.