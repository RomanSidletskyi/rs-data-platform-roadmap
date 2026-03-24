# Operational Triage Recipe

## Goal

Diagnose Kafka incidents without jumping to the wrong layer.

The biggest operational mistake in Kafka systems is blaming the broker before checking the full pipeline.

Very often, the real issue is:

- sink latency
- consumer instability
- bad retry behavior
- skewed partitioning
- dependency failure outside Kafka itself

## Recipe

1. Check lag for the affected consumer group.
2. Check sink latency and downstream dependency health.
3. Check rebalance frequency and recent deployments.
4. Check DLQ growth and error classes.
5. Decide whether the issue is producer, broker, consumer, or sink related.

## Practical Triage Order

### 1. Is this a backlog problem or a hard failure?

- Is lag increasing steadily?
- Did throughput drop?
- Are records still moving at all?

### 2. Is Kafka unhealthy or only exposed to downstream pain?

- Are brokers reachable?
- Are producers getting acknowledgements?
- Are consumers alive but slow?

### 3. Is the consumer unstable?

- Are rebalances frequent?
- Were there recent deployments?
- Did autoscaling or crash loops change group membership repeatedly?

### 4. Is the sink the bottleneck?

- Is Postgres slow?
- Is the API dependency timing out?
- Is object storage landing degraded?

### 5. Are bad records amplifying the issue?

- Is DLQ volume rising?
- Did a new schema version start failing validation?
- Are poison messages trapped in retry loops?

## Example

High lag with healthy brokers and slow database writes usually points to a sink bottleneck, not to Kafka itself.

## Example Incident Patterns

### Pattern A: Healthy broker, unhealthy sink

- lag rising
- sink latency rising
- DLQ mostly stable

Likely interpretation:

- downstream throughput mismatch

### Pattern B: Consumer restart storm

- lag rising
- rebalance frequency high
- recent deployment happened

Likely interpretation:

- consumer lifecycle instability

### Pattern C: New bad payload rollout

- DLQ volume spikes suddenly
- validation failures cluster around one event type

Likely interpretation:

- contract or producer regression

## Good Incident Questions

- what changed recently?
- which layer became slower first?
- is this one topic, one group, or whole-cluster impact?
- if we replay later, will the sink remain safe?

## Rule

Triage by signal, not by instinct.