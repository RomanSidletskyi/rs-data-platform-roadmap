# Replay And Idempotency

## Scenario

A pipeline must replay raw events after upstream correction or downstream recovery.

The system claims idempotent behavior, but duplicate records appear after some replay paths.

## Core Tension

Should idempotency be enforced at ingestion, validation, merge, or publish boundaries?

## Trade-Offs

- enforcing deduplication too early can hide upstream quality issues
- enforcing it too late can create expensive replay cleanup
- putting the rule in one unclear place makes debugging hard

## Failure Modes

- event identifiers normalized differently across stages
- deduplication logic depending on stale target state
- replay using a different contract than first-pass ingestion

## Code-Backed Discussion Point

```python
def apply_events(existing_ids, incoming_events):
    output = []
    for event in incoming_events:
        if event["event_id"] not in existing_ids:
            output.append(event)
            existing_ids.add(event["event_id"])
    return output
```

The local logic can look correct while the architecture still fails.

The real question is whether `existing_ids` reflects the authoritative state consistently across first pass and replay.

## Decision Signal

Idempotency should be tied to an explicit architectural invariant, not only a helper function.

## Review Questions

- what is the exact replay invariant the system must preserve
- where is the authoritative state for deduplication loaded from
- how can first-pass and replay behavior diverge
- what evidence would prove idempotency is architectural rather than accidental

## AI Prompt Pack

```text
Compare three places to enforce idempotency in an event pipeline: ingestion, validation, and publish. Focus on replay correctness, debugging clarity, and operational complexity.
```

```text
Given this replay bug pattern, propose the most likely architectural causes before suggesting code fixes. Include one test or signal that would confirm each cause.
```