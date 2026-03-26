# Consumer Poll Loop And Offset Control

## Why This Topic Matters

Consumers are where many Kafka systems become operationally difficult.

The transport may work, but the consuming application can still fail through:

- bad offset handling
- weak retry behavior
- non-idempotent writes
- unclear failure recovery

So consumer design is one of the main places where engineering maturity shows.

## Consumer Mental Model

A consumer repeatedly:

- polls for records
- processes them
- decides when progress is safe enough to record

This is why the poll loop matters.

The important question is not only:

- how do I read records?

It is also:

- when is it safe to consider those records successfully processed?

## Poll Loop As A Safety Boundary

Simplified loop:

```python
while True:
    records = consumer.poll(timeout_ms=1000)
    for record in records:
        process(record)
    commit_offsets_if_safe()
```

This small loop hides a large correctness question:

- if processing fails after reading but before safe persistence, what should happen next?

That is why offsets and downstream writes must be reasoned about together.

## Offset Commit Intuition

At a high level:

- committing offsets too early risks data loss in downstream systems
- committing offsets too late can increase duplicate reprocessing after restart

This is a trade-off space, not a magic setting.

## Example 1: Logging Consumer

Scenario:

- consumer reads application events
- only writes them to console or simple log storage

This is relatively forgiving.

If the consumer reprocesses some events after restart, the cost may be acceptable.

## Example 2: Postgres Sink Consumer

Scenario:

- consumer reads order events
- writes rows into Postgres

Now correctness matters more.

If offsets are committed before the database write is truly safe, a crash can cause data loss in Postgres while Kafka believes the events were processed.

If offsets are committed only after the database write, duplicates become more likely after restart unless the Postgres write path is idempotent.

This is exactly why downstream idempotency matters.

## Example 3: Warehouse Landing Consumer

Scenario:

- consumer lands raw events into analytical storage
- storage can tolerate duplicates if dedup happens later

In this architecture, at-least-once behavior may be acceptable if:

- landing is append-friendly
- downstream deduplication is explicit
- replay is operationally supported

## Consumer Group Rebalance Impact

Consumers do not run in total isolation.

If members join or leave a consumer group, partitions can be reassigned.

That means long-running processing and delayed commits can interact badly with rebalances.

Architecturally, this is one reason consumers should:

- keep processing bounded
- make progress visible
- avoid huge hidden in-memory work before safe checkpoints

## Good Strategy

- think of the consumer as part of the storage pipeline, not just a reader
- align offset commits with truly safe downstream state
- assume restarts and rebalances will happen

## Bad Strategy

- auto-commit offsets without understanding failure behavior
- treat downstream writes as independent from commit timing
- build consumers that only work on the happy path

## Small Cookbook Example

Better pattern for a sink consumer:

1. read event
2. validate payload
3. write idempotently to storage
4. confirm success
5. commit offsets for safely processed records

This does not remove all complexity, but it keeps the safety boundary explicit.

## Key Architectural Takeaway

The consumer poll loop is not just a reading loop.

It is the operational boundary between Kafka offsets and real downstream correctness.