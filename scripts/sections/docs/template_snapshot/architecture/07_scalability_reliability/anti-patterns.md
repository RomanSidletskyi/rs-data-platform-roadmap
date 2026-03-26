# Scalability And Reliability Anti-Patterns

## Why This Note Exists

Reliability problems often come from happy-path engineering that assumes retries or scaling will fix deeper design errors.

## Anti-Pattern 1: Infinite Retries For Bad Records

Why it is bad:

- poison data can block healthy throughput indefinitely
- operators lose signal because every failure looks transient

Better signal:

- transient and permanent failure paths are separated clearly

## Anti-Pattern 2: No Idempotency Before Reruns

Why it is bad:

- reprocessing corrupts outputs with duplicates or conflicting state
- recovery becomes a manual cleanup exercise

Better signal:

- retries and reruns are safe by design for the chosen sink behavior

## Anti-Pattern 3: Scaling Compute Without Finding The Real Bottleneck

Why it is bad:

- costs rise while latency barely improves
- sink, storage, or partitioning limits remain untouched

Better signal:

- bottleneck location is observable before capacity is added

## Anti-Pattern 4: Checkpointing Treated As A Detail

Why it is bad:

- teams discover recovery gaps only during incidents
- restart behavior is inconsistent and poorly understood

Better signal:

- recovery state and checkpoint semantics are part of the architecture discussion

## Review Questions

- what happens if this job fails halfway through twice in a row
- which failures should retry and which should isolate bad data
- where is the first bottleneck likely to appear under load