# Kafka In Microservices And Domain Boundaries

## Why This Topic Matters

Kafka is often introduced in service architectures to reduce tight coupling.

But if event boundaries are weak, Kafka can spread confusion instead of reducing coupling.

The common beginner mistake is thinking that once services communicate through Kafka, ownership problems disappear. In reality, the opposite is usually true: weak ownership becomes more dangerous because ambiguous events can spread quickly across many downstream consumers.

## What Kafka Should Change And What It Should Not

Kafka should change transport coupling.

Kafka should not erase domain ownership.

Healthy event-driven microservices still need answers to these questions:

- which service owns the concept?
- which team defines the event meaning?
- which service is allowed to publish authoritative changes?
- which consumers may derive their own views without redefining the original fact?

If those answers are unclear, Kafka becomes a broadcasting mechanism for organizational confusion.

## Healthy Microservice Pattern

A service publishes events about its own domain facts.

Examples:

- order service publishes `order_created`
- payment service publishes `payment_captured`
- shipment service publishes `shipment_dispatched`

This keeps ownership aligned with domain responsibility.

Healthy pattern characteristics:

- producer owns the business action that created the event
- topic naming reflects domain ownership
- consumers react to the event without rewriting its meaning
- contract changes follow a clear review process

## Why This Alignment Matters

When topic ownership follows domain ownership, teams gain:

- clearer accountability during incidents
- better schema governance
- safer evolution of contracts
- lower risk of duplicate or conflicting truths

This is not just a documentation benefit. It determines whether the system remains operable when many teams start building on the same event backbone.

## Weak Patterns

### A Service Publishes Another Team's Truth

A service publishes events about another team's domain, or mutates shared event structures without clear ownership.

That creates semantic drift and governance tension.

Example:

- analytics service republishes order lifecycle events in a shape it prefers
- downstream consumers begin reading the analytics-owned topic as if it were the official order stream

Now the architecture has two different order truths.

### Consumers Dictate Producer Semantics

Consumers often want producer contracts optimized for their local convenience.

That pressure becomes dangerous when:

- event fields are added only for one downstream team
- event names start reflecting report language rather than domain language
- producers expose internal details because consumers ask for easier joins

The producer must listen to consumers, but it should not surrender domain semantics to them.

### Shared Topic Without Real Ownership

Some organizations create a generic shared stream where several services publish loosely related events.

Examples:

- `all_events`
- `platform_messages`
- `service_updates`

These usually fail over time because:

- ownership is ambiguous
- schema governance is weak
- retention needs differ by event type
- consumers struggle to reason about guarantees

## Concrete Example

Good:

- order service owns `sales.order_events`

Weak:

- analytics service starts redefining fields in the order topic because it prefers another schema shape

That is a contract ownership violation.

Better alternative:

- order service keeps ownership of domain event contract
- analytics team builds its own downstream derived topic or warehouse model
- derived artifacts are clearly marked as consumer-oriented views, not the source domain contract

## Cross-Team Contract Example

Imagine these domains:

- sales owns order lifecycle
- payments owns payment authorization and settlement
- logistics owns shipment movement

A healthy interaction looks like this:

- sales emits `order_created`
- payments consumes and decides whether payment is authorized
- payments emits `payment_authorized` or `payment_failed`
- logistics consumes only the events it actually needs

An unhealthy interaction looks like this:

- sales emits an oversized order event containing guessed payment and shipment placeholders
- payments and logistics start depending on sales-owned assumptions about their own domains

That makes the order service an accidental central model for everyone else.

## Event Backbone Does Not Mean Shared Domain Model

Kafka can connect many services, but that does not mean all services should converge on one giant shared payload.

Healthy event-driven systems allow:

- shared backbone
- separate domain ownership
- local read models and transformations
- formal contract evolution

Weak event-driven systems drift toward:

- one oversized canonical event model
- bloated payloads carrying fields for every consumer
- teams negotiating endlessly over shared schemas
- producers becoming bottlenecks for unrelated downstream requirements

## Design Rules For Healthy Boundaries

### Publish Facts, Not Guesses

A service should publish facts it owns.

Examples:

- order service can publish that an order was created
- payment service can publish that a payment was captured
- shipment service can publish that a package was dispatched

A service should not publish speculative or second-hand truth about another domain unless that relationship is explicitly modeled.

### Keep Domain Language Stable

Event names and fields should use business language that belongs to the owning context.

If naming starts drifting toward implementation detail or analytics convenience, domain boundaries weaken.

### Let Consumers Build Their Own Projections

Consumers should often transform upstream events into:

- local database tables
- materialized views
- reporting schemas
- derived consumer-facing topics

That is healthier than asking every producer to embed every consumer's local needs.

## Good Strategy

- align topic ownership with domain ownership
- use Kafka to decouple services, not to erase ownership boundaries
- keep consumers from dictating producer semantics without formal review
- allow derived views downstream instead of bloating source-domain events
- treat cross-team event contracts as product interfaces with clear stewardship

## Key Architectural Takeaway

Kafka supports decoupled services only when event ownership remains aligned with domain boundaries.