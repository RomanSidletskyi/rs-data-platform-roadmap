# Streaming Architecture Anti-Patterns

## Why This Note Exists

Streaming systems become fragile when teams adopt event infrastructure faster than they design correctness and ownership.

## Anti-Pattern 1: Kafka As A Prestige Choice

Why it is bad:

- complexity rises without matching business value
- teams inherit lag, replay, and sink-correctness burdens for simple workloads

Better signal:

- the design requires low latency, replay, or multi-consumer decoupling

## Anti-Pattern 2: Transport Durability Treated As Business Correctness

Why it is bad:

- teams assume the event stream itself guarantees correct outputs
- sink duplicates and ordering gaps are ignored

Better signal:

- transport guarantees and business correctness guarantees are designed separately

## Anti-Pattern 3: Ad Hoc Stateful Consumer Logic

Why it is bad:

- local scripts accumulate hidden state and fragile retry behavior
- recovery becomes dependent on undocumented implementation details

Better signal:

- stateful processing is explicit, observable, and recoverable

## Anti-Pattern 4: No Replay Story

Why it is bad:

- incidents cannot be corrected safely
- late logic fixes require manual repair instead of controlled recomputation

Better signal:

- replay boundaries and sink idempotency are known in advance

## Review Questions

- what exact business value is low latency creating here
- how would a downstream consumer recover after partial failure
- what source of truth exists outside the stream itself