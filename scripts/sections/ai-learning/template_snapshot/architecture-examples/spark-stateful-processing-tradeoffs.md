# Spark Stateful Processing Trade-Offs

## Scenario

A team needs event-time logic, deduplication, or aggregation over streams and considers stateful Spark processing.

## Core Tension

Should the system use stateful streaming logic for correctness guarantees, or keep the flow simpler and accept weaker real-time guarantees?

## Trade-Offs

- stateful processing can provide stronger deduplication and event-time semantics
- it increases operational and recovery complexity
- simpler batch-oriented compensation models may be easier to reason about for small teams

## Failure Modes

- state growth becoming hard to manage
- replay behavior differing from live processing
- watermark choices silently dropping valid late events

## Code-Backed Discussion Point

```python
(
    events
    .withWatermark("event_time", "10 minutes")
    .dropDuplicates(["event_id"])
)
```

The API call is short.

The architecture question is what lateness guarantee the platform is actually making and whether the team can operate that guarantee consistently.

## Decision Signal

Choose stateful complexity only when the correctness gain is worth the operational burden.

## Review Questions

- what correctness guarantee requires stateful processing
- what replay and recovery burden does state introduce
- how would watermark settings affect late but valid events
- what simpler design would be good enough for this team

## AI Prompt Pack

```text
Compare stateful Spark streaming against simpler batch-style compensation for a small team that needs deduplication and event-time correctness. Focus on operational burden, replay behavior, watermark risk, and actual correctness gains.
```

```text
Challenge this stateful processing design. What assumptions about late data, recovery, and team operating ability are still too optimistic?
```