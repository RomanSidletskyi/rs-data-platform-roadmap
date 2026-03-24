# Debezium And CDC Patterns

## Why This Topic Matters

Many Kafka platforms ingest not only app-native events, but also database changes.

That is where CDC, or Change Data Capture, becomes important.

CDC is one of the fastest ways to connect operational systems to a streaming platform, especially when the database is the earliest reliable place where change becomes visible.

## What CDC Does

CDC captures changes from a database and turns them into an event stream.

This is useful when teams need:

- near-real-time replication
- downstream analytics feeds
- incremental sync patterns
- event-driven reactions to table changes

That makes CDC highly practical for both data-platform ingestion and integration modernization.

## Where Debezium Fits

Debezium is one of the most common tools for CDC into Kafka.

It helps transform database change logs into Kafka topics.

Architecturally, Debezium often becomes a bridge from operational persistence into a wider event-driven or analytical platform.

## Example

Table:

- `orders`

CDC events might represent:

- insert
- update
- delete

Downstream systems can then react without heavy polling.

This is often a major step forward from batch polling because it reduces source-system load and improves freshness.

## Why Teams Like CDC

CDC helps teams move fast because they do not need every application team to redesign service interfaces before data can start flowing.

It is especially valuable for:

- legacy systems
- packaged applications
- environments where database access is easier than application changes

## Important Architectural Warning

CDC is powerful, but it is not the same as well-designed business events.

Database row changes may expose:

- storage model details
- noisy updates
- weak business semantics

So CDC is often best understood as an integration pattern, not a full replacement for domain-event design.

This is the key distinction:

- CDC says a row changed
- domain events say a business fact happened

Those are related, but not identical.

## Healthy CDC Patterns

### Raw CDC For Technical Replication

Use CDC topics for:

- synchronization
- staging ingestion
- archival landing
- incremental propagation

In this model, consumers know they are subscribing to low-level database changes.

### CDC To Curated Domain Topics

Use CDC as an upstream signal, then transform it into curated domain streams.

Example:

- Debezium captures `orders` table changes
- transformation logic emits `order_created`, `order_confirmed`, `order_cancelled`
- broad consumers use curated topics instead of raw row mutations

This is often healthier for cross-team usage.

### CDC As Migration Bridge

Some platforms use CDC first, then gradually move important domains toward explicit application-level events.

That is often a pragmatic path rather than trying to redesign everything upfront.

## Common CDC Risks

### Storage-Coupled Contracts

If downstream consumers depend directly on table columns, operational schemas become accidental public APIs.

### Noisy Change Streams

Some row updates are technically real but not business meaningful. Downstream systems can drown in changes that add little semantic value.

### Misunderstood Deletes And Tombstones

Consumers must know whether deletes represent business deletion, storage cleanup, or compaction behavior.

## Good Strategy

- use CDC when database-originated change streams are the right source of truth
- distinguish between raw data-change streams and curated business-event topics
- keep raw CDC topics scoped and governed when they expose storage details
- prefer curated contracts for broad multi-team consumption
- treat CDC as an integration primitive, not as automatic business modeling

## Bad Strategy

- assume every CDC topic is automatically a clean domain contract
- expose raw storage changes to all downstream consumers without abstraction
- let teams infer business semantics from table mutations without shared rules
- ignore how schema refactors ripple through raw CDC consumers

## Key Architectural Takeaway

CDC is excellent for propagation of change, but business architecture still decides whether raw row changes are the right interface for consumers.