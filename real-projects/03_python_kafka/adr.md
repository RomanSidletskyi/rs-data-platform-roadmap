# Project ADR Starter

## Project

`03_python_kafka`

## Initial Decision To Capture

Use Kafka only if replayable event flow, decoupled consumers, or low-latency transport create clear value.

## Why This Is The First Decision

The first architecture risk in this project is adopting streaming infrastructure before the business need is explicit.

## Candidate Context Points

- low-latency need must be real
- consumer recovery and duplicate handling must be safe
- stream transport is not the same as business truth

## Candidate Alternatives

- incremental batch ingestion
- queue or simpler event transport with narrower scope

## Related Notes

- `README.md`
- `architecture-notes.md`
- `../../docs/architecture/adr/template.md`