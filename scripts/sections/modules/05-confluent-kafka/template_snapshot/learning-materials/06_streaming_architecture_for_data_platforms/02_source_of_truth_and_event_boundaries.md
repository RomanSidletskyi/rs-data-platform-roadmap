# Source Of Truth And Event Boundaries

## Why This Topic Matters

Kafka carries facts, but it is not automatically the source of truth for every workflow.

Architects need to be explicit about where truth lives.

This matters because many platform failures are not infrastructure failures. They are semantic failures. Teams do not know which system is authoritative, which topic is only an integration stream, whether replay can rebuild current state, or whether a compacted topic is safe to query as truth.

When those boundaries stay vague, several problems appear:

- inconsistent answers across systems
- broken recovery assumptions
- consumers querying the wrong storage layer
- endless debates during incidents about which system is correct

## What "Source Of Truth" Actually Means

Source of truth means the system that is authoritative for a given business concept.

That system defines:

- what the current accepted state is
- which changes are valid
- how corrections are applied
- which history is complete and which is only a derived projection

Kafka may transport events from that source of truth. Kafka may also hold a durable history of published events. But that does not automatically make Kafka the place where business truth is governed.

## Typical Possibilities

- operational database is source of truth
- domain service state is source of truth
- Kafka topic is integration backbone, not primary truth
- compacted topic may serve as latest-state view for some use cases
- warehouse or lakehouse is analytic truth, but not operational truth

These are different roles. Confusing them creates architectural drift.

## A Practical Taxonomy

### 1. Operational Source Of Truth

This is usually where business commands are validated and committed.

Examples:

- order service database for order lifecycle
- payment system ledger for payment authorization and settlement
- inventory service state store for stock reservations

If a customer asks, "what is my current order status right now?", this is usually the place that should answer.

### 2. Event History

Kafka topics may store the history of published domain events.

Examples:

- `sales.order_events`
- `payments.payment_events`
- `logistics.shipment_events`

This is valuable for:

- downstream reactions
- replay
- audit-like integration tracing
- rebuilding derived models

But it is only authoritative to the extent that the producer emits complete and correct events. If corrections happen outside the stream or if only partial state changes are emitted, the topic may not be enough to reconstruct truth.

### 3. State Snapshot Or Replicated Read Model

A compacted topic or materialized view may represent latest known state.

That can be highly useful for:

- fast lookups
- local caches
- reducing API chatter
- bootstrapping consumers

But a replicated state view is not automatically the legal or business source of truth. It may be stale, incomplete, or optimized for consumers rather than for authoritative correction workflows.

### 4. Analytical Truth

Warehouses and lakehouses often become the reporting truth for analytics.

Example:

- monthly finance reporting may use the curated warehouse table as official reporting truth

That still does not mean the warehouse should receive operational commands for payment approval or shipment cancellation.

Operational truth and analytical truth are both real, but they serve different decision contexts.

## Core Design Question

For every important entity, answer these questions explicitly:

1. Which system accepts the authoritative write?
2. Which system should answer "what is the latest official state?"
3. Which topic carries the integration events?
4. Can replay from Kafka fully reconstruct state, or only part of it?
5. Are corrections represented as events, direct database fixes, or both?

If a team cannot answer those questions clearly, the architecture is not yet well bounded.

## Example: Orders Domain

Order service database may remain the source of truth for order lifecycle.

Kafka carries order events outward so other systems can react.

That does not automatically mean Kafka replaces the service's primary state store.

Healthy design:

- order service validates command and updates its database
- order service publishes `order_created`, `order_confirmed`, `order_cancelled`
- fulfillment, analytics, and notifications consume those events
- customer support queries order system or approved read model for authoritative status

Weak design:

- some teams query the order database
- some teams query a compacted Kafka-derived cache
- some teams reconstruct from event history ad hoc
- nobody knows which answer wins during inconsistencies

That is not flexibility. That is unclear authority.

## Example: CDC Topic Is Not Always Truth

Suppose Debezium publishes row-level changes from `orders` table.

That topic is extremely useful for data movement, auditing, and downstream synchronization.

But it may still be a poor business-level source of truth because:

- row mutations may not carry full domain meaning
- internal table refactors change the event shape
- consumers may misunderstand technical updates as business facts
- the database may contain intermediate states not intended for broad consumption

So the table may be the operational truth, while the CDC topic is only a technical change feed.

## Example: Compacted Topic As Current-State Feed

A compacted topic may be a legitimate state distribution mechanism.

Example:

- product catalog service owns product truth
- it publishes updates keyed by `product_id`
- downstream systems consume a compacted topic to get latest product representation

This can work well if:

- event contract is stable
- producer truly owns the domain state
- correction events are represented consistently
- consumers understand it as distributed latest-state feed

Even then, teams should still document whether the compacted topic is authoritative or a synchronized copy of a deeper source.

## Boundary Mistakes

Teams sometimes blur these layers and stop knowing:

- which system should be queried for authoritative state
- whether replay reconstructs full truth or only integration history
- whether a compacted topic is an approximation or a formal truth source

Additional common mistakes:

- using Kafka as the answer to operational queries without defining freshness guarantees
- assuming all emitted events are sufficient to rebuild state when some corrections happen outside the stream
- letting analytics outputs drift into operational usage without governance

## Replay Implications

Replay only helps if you understand what the stream represents.

If Kafka contains full business events with reliable ordering and correction semantics, replay may rebuild downstream state accurately.

If Kafka only contains partial integration signals, replay may rebuild only a projection, not full business truth.

This distinction matters during incident recovery.

Questions to ask:

- does the stream include deletions or tombstones?
- are out-of-band fixes later emitted into the topic?
- can historical schema versions still be interpreted correctly?
- is event history complete from system inception or only from platform adoption date?

## Good Strategy

- define source of truth explicitly for each domain
- define which Kafka topics are event history, integration feeds, or state snapshots
- document whether replay rebuilds authoritative state or only derived models
- separate operational truth from reporting truth
- avoid letting consumers guess which layer is authoritative

## Key Architectural Takeaway

Kafka architecture becomes cleaner when source-of-truth boundaries are explicit rather than assumed.