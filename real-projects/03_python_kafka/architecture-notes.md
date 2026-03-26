# Architecture Notes

## Project

`03_python_kafka`

## Intended System Shape

Event-driven ingestion with Python producers and consumers:

    Producer -> Kafka Topic -> Consumer -> Sink / Storage

## Main Responsibilities

- event production
- transport through Kafka
- consumer processing and sink correctness
- replay and offset-based recovery

## Key Design Questions

- what business value justifies Kafka instead of scheduled batch
- how are duplicates or retries handled safely
- what source of truth exists outside the event stream

## First Risks To Watch

- Kafka used for prestige rather than need
- consumer sink not idempotent under retry
- no clear ownership for event schema and semantics

## Candidate ADRs

- `Use Kafka Only Where Replayable Event Flow Adds Clear Value`
- `Design Consumer Sinks For Idempotent Recovery`

## Review Pairing

- `../../docs/architecture/reviews/streaming-platform-review-checklist.md`
- `../../docs/architecture/adr/template.md`