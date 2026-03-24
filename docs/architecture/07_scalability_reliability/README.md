# Scalability and Reliability

## What This Topic Is For

This topic focuses on how systems behave when data volume grows, dependencies degrade, or failures interrupt processing.

Architecture quality is visible here very quickly.

Weak systems work only on the happy path.

## Core Areas

- retry logic
- checkpointing
- scaling strategy
- partitioning
- failure recovery

## What To Pay Attention To

- what happens if a job fails halfway through
- what happens if the same data is processed twice
- where bottlenecks appear first: storage, compute, network, or dependency
- how partitioning changes both correctness and throughput
- how the system recovers after restart, lag, or backlog

## Good Architecture Signals

- idempotency is designed before incidents
- retries are bounded and observable
- recovery path is documented and realistic
- scaling model matches the shape of the workload rather than theoretical max throughput

## Common Mistakes

- infinite retries for bad records
- no distinction between transient and permanent failures
- scaling compute without checking sink or storage bottlenecks
- treating checkpointing as an implementation detail instead of recovery design

## Real Examples To Think Through

- Kafka consumer lag caused by slow sink writes
- batch job rerun after partial failure
- Spark job that scales poorly because partitioning is wrong
- replay after a transformation bug in a downstream consumer

Worked example:

- `worked_example_replay_after_sink_failure.md`

## Interview Questions

- What happens if a pipeline fails halfway through?
- How do you avoid duplicates after reruns?
- What is checkpointing?
- How does partitioning affect scale?

## Read Next

- `resources.md`
- `anti-patterns.md`
- `worked_example_replay_after_sink_failure.md`
- `../../system-design/README.md`
- `../../trade-offs/README.md`

## Completion Checklist

- [ ] I understand retry and rerun safety
- [ ] I understand idempotency
- [ ] I understand checkpointing conceptually
