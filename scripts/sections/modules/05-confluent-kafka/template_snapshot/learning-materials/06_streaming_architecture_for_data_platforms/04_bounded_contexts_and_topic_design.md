# Bounded Contexts And Topic Design

## Why This Topic Matters

Topic design should reflect domain boundaries, not accidental implementation details.

This is where bounded context thinking becomes useful.

Without bounded contexts, teams often create topics that are easy to start with but painful to evolve. The cost appears later: unclear ownership, bloated schemas, generic topic names, replay confusion, and downstream consumers that no longer know what a topic actually represents.

## What A Bounded Context Means Here

A bounded context is a domain boundary where language, rules, and ownership stay coherent.

In Kafka topic design, that usually means:

- topic meaning is tied to a business domain
- producer ownership is clear
- event contracts use language from that domain
- consumers know what guarantees and semantics to expect

The goal is not academic purity. The goal is survivable long-term architecture.

## Healthy Pattern

Topics align with business domains.

Examples:

- `sales.order_events`
- `payments.payment_events`
- `logistics.shipment_events`

This improves ownership and semantic clarity.

Healthy topic characteristics:

- clear domain prefix or namespace
- obvious producer ownership
- event meaning understandable without reading pipeline code
- retention and partitioning strategy aligned with usage

## Weak Patterns

### Generic Catch-All Topics

Topics are named around technical pipelines or generic payload buckets.

Examples:

- `all_events`
- `pipeline_data`
- `service_messages`

These names often hide ownership and weaken long-term maintainability.

They also make it hard to answer:

- who owns the schema?
- what ordering guarantees matter?
- which consumers are legitimate?
- how should retention be configured?

### Topics Named After Internal Pipelines

Examples:

- `spark_ingest_topic`
- `etl_stage_1`
- `job_output_events`

These names reveal pipeline structure, not business meaning.

That is fragile because pipelines change more often than domains.

### One Topic For Too Many Domains

If orders, payments, shipments, and returns all share a single stream only because they are "commerce events," the system often becomes harder to govern.

Why:

- contracts become huge
- consumers must filter too much noise
- retention needs diverge
- partitioning strategy becomes compromised

## Why It Matters

Bounded-context alignment helps with:

- ownership
- schema governance
- evolution discipline
- clearer consumer expectations
- safer replay and recovery
- better access control and platform governance

## Concrete Example

Suppose a commerce platform has three teams:

- sales
- payments
- logistics

Healthy design:

- sales owns `sales.order_events`
- payments owns `payments.payment_events`
- logistics owns `logistics.shipment_events`

Each team publishes facts from its own domain.

Weak design:

- one central `commerce_events` topic carries every event type
- a shared platform team becomes gatekeeper for all contract changes
- teams negotiate unrelated schema changes in one stream

The second design may look centralized and tidy at first. It usually becomes slower and more political over time.

## Topic Design Questions To Ask

Before creating a topic, ask:

1. Which bounded context owns this fact?
2. Is this topic describing domain events, state snapshots, or technical change feed?
3. Will retention, partitioning, and consumer access policies be similar for all records in the topic?
4. Does the topic name reveal business meaning or only implementation detail?
5. Are we grouping these events together because they belong together semantically, or only because it is convenient right now?

Those questions prevent many future migrations.

## Domain-Aligned Topic Patterns

### Pattern 1: Domain Event Stream

Examples:

- `sales.order_events`
- `payments.payment_events`

Good for:

- business facts over time
- multiple downstream consumers
- replay and audit-style reconstruction of decisions

### Pattern 2: Entity Snapshot Stream

Examples:

- `catalog.product_snapshot`
- `customers.customer_profile_snapshot`

Good for:

- latest-state distribution
- compacted topics
- cache warm-up and local materialized views

### Pattern 3: Technical CDC Stream

Examples:

- `dbserver1.sales.orders_cdc`
- `erp.inventory_table_changes`

Good for:

- infrastructure replication
- technical synchronization
- feeding downstream transformation pipelines

But these topics should be clearly distinguished from domain event streams. Otherwise consumers may mistake table changes for business events.

## Partitioning And Context Boundaries

Bounded context also affects partition-key design.

Examples:

- order events usually partition by `order_id`
- payment events usually partition by `payment_id` or `order_id`, depending on business processing model
- shipment events usually partition by `shipment_id`

If several unrelated domains share one topic, partition-key decisions become awkward because the ordering unit differs by domain.

That is another signal that the topic boundary is too broad.

## Anti-Patterns To Watch For

### The Canonical Mega Topic

One topic is designed to become the universal company event stream.

This usually leads to:

- excessive schema branching
- weak ownership
- complicated consumer filtering
- platform bottlenecks

### Consumer-Driven Topic Proliferation

Every downstream team asks for a new source topic variant instead of building local projections.

That creates:

- redundant topics
- duplicated semantics
- rising governance cost

It is usually better to keep strong source-domain topics and let consumers build their own derived layers.

### Technical Names Hiding Business Facts

If a topic is named after a job or connector rather than the business concept it carries, consumers become dependent on implementation details.

## Good Strategy

- model topics around domain facts and bounded contexts
- avoid generic catch-all topics where meaning becomes ambiguous
- distinguish domain events from snapshots and CDC feeds
- let partitioning strategy reinforce domain boundaries instead of fighting them
- prefer strong source topics plus downstream projections over one oversized shared contract

## Key Architectural Takeaway

Good Kafka topic design usually follows domain boundaries more than technical convenience.