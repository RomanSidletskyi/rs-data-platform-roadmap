# When Not To Use Kafka Integrations

## Why This Topic Matters

Strong engineers learn not only where Kafka fits, but where it does not.

Many weak platform designs fail because Kafka is treated as the default answer to every integration question. That creates an event bus where a simpler API, database replication pattern, cron job, or queue would have solved the problem with less cost and less ambiguity.

Kafka adds real strengths:

- asynchronous decoupling
- multi-consumer fan-out
- replay and backfill ability
- durable event history
- high-throughput streaming pipelines

Kafka also adds real costs:

- broker operations and monitoring
- schema governance and topic ownership work
- delivery semantics complexity
- consumer lag and replay management
- harder debugging than direct request-response flows

Architectural maturity means choosing Kafka only when the strengths justify the costs.

## A Fast Decision Framework

Ask these questions before introducing Kafka:

1. Do multiple independent consumers need the same stream of facts?
2. Do we need replay, reprocessing, or delayed consumption?
3. Is producer-consumer time decoupling important?
4. Is the integration stream-like rather than command-like?
5. Is the team ready to own contracts, retention, lag, and operational support?

If most answers are no, Kafka is often the wrong tool.

## Cases Where Kafka May Be The Wrong Tool

### 1. Simple Synchronous Request-Response Flows

If service A needs an immediate answer from service B, Kafka usually fights the shape of the problem.

Examples:

- configuration lookup
- current price retrieval
- permission check
- inventory check before order confirmation

These are query-style interactions. An API call, cache, or replicated read model is usually a better fit.

Kafka can carry derived updates that help local caching, but it should not replace a direct query when the business flow is synchronous.

### 2. Command Workflows That Need Immediate Transactional Coupling

Some operations require a clear success or failure answer within the user transaction.

Examples:

- card authorization during checkout
- identity verification before account opening
- lock acquisition before executing a critical operation

If the workflow cannot continue without an immediate result, event streaming alone is insufficient.

This is a common anti-pattern:

- service publishes `do_payment_now`
- frontend waits indirectly for another service to react
- timeouts and partial failures become difficult to reason about

In these cases, use synchronous APIs for the command path. Kafka may still be useful after the command completes, for publishing resulting domain events.

### 3. Tiny One-Step Integrations With No Replay Value

If one system sends a low-volume message to exactly one other system, and nobody needs replay or fan-out, Kafka may be unnecessary ceremony.

Example:

- internal admin tool writes a rare configuration change
- one downstream service needs that change
- the value can be persisted directly in the same database or delivered through an API

Adding Kafka here often creates more moving parts than business value.

### 4. Very Low-Volume Batch Movement

If a team moves one file per day from system A to system B and no one benefits from real-time event flow, Kafka may be the wrong abstraction.

Better options may include:

- scheduled file transfer
- object storage drop zone
- batch ingestion job
- database export/import

This is especially true when the receiving system already works natively in batch windows.

### 5. Stateful Workflow Orchestration

Kafka is good at transporting events. It is not, by itself, a workflow engine.

If the core problem is long-running orchestration with human approval, branching rules, SLA timers, retries across business steps, and visibility into process state, you may need an orchestrator or workflow engine.

Examples:

- loan approval lifecycle
- multi-stage support escalation
- document review with manual checkpoints

Kafka can feed those systems, but should not be mistaken for the orchestration model itself.

### 6. Highly Coupled CRUD Replication With No Event Thinking

If the team is really trying to mirror tables blindly between systems and has not identified domain events, Kafka often becomes a transport for accidental complexity.

Symptoms:

- topics named after generic tables only because they exist
- no distinction between business facts and internal row mutations
- consumers depending on every column in an operational schema

That is usually a sign the team needs a clearer integration model first, not more Kafka.

## Concrete Examples

### Example 1: Configuration Lookup

If one internal service needs a direct configuration lookup from another service, Kafka is usually the wrong shape.

An API call or replicated lookup store may fit better.

Why:

- the caller needs current state now
- event ordering is not the main concern
- replay is rarely valuable for point lookups

### Example 2: Daily Finance File Delivery

If a team needs once-a-day batch file movement with no real streaming value, Kafka may add unnecessary operational complexity.

Why:

- the cadence is batch by nature
- consumers do not need continuous reaction
- object storage and scheduled jobs are often simpler and easier to audit

### Example 3: User Clickstream Analytics

This is a case where Kafka often does fit.

Why:

- high event volume
- multiple downstream consumers
- delayed processing is acceptable
- replay is valuable for bug fixes and model refreshes

The point is not that Kafka is good or bad in general. The point is matching tool shape to problem shape.

## Common Anti-Patterns

### Kafka As Enterprise Decoration

Some teams add Kafka because it looks like a mature platform component, not because the use case needs it.

This usually leads to:

- underused topics
- one producer and one consumer with no real decoupling
- unclear ownership
- operational burden with little return

### Replacing Every API With Events

Events and APIs serve different purposes.

- APIs answer questions and execute commands
- events publish facts that already happened

If a business process still requires command-response semantics, replacing it with Kafka does not make it more decoupled. It usually just makes it less explicit.

### Using Kafka To Hide Domain Ambiguity

If teams do not know which system owns a concept, Kafka will not solve that uncertainty.

It may even amplify it because several systems start publishing overlapping versions of the same truth.

## Better Alternatives By Problem Shape

Use an API when:

- you need immediate response
- the consumer is explicitly asking a question
- the transaction depends on the answer now

Use a queue when:

- one consumer should process one work item
- replay and multi-consumer fan-out are not important
- the main concern is work distribution, not event history

Use batch pipelines when:

- latency requirements are measured in hours, not seconds
- source systems export data in chunks or files
- operational simplicity matters more than real-time reaction

Use database replication or materialized views when:

- consumers need current state rather than event history
- the main goal is local read performance
- state freshness is more important than event semantics

## Good Strategy

- choose Kafka when decoupling, replay, event fan-out, or streaming integration actually matter
- choose simpler tools when the problem is simple
- keep synchronous command paths synchronous when business flow requires it
- use Kafka for facts, not as a forced replacement for every interaction style
- be explicit about why Kafka is earning its operational cost in each integration

## Key Architectural Takeaway

Kafka becomes valuable when its strengths match the integration problem; otherwise it becomes expensive ceremony.