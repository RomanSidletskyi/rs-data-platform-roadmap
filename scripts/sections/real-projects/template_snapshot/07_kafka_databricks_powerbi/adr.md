# Project ADR Starter

## Project

`07_kafka_databricks_powerbi`

## Initial Decision To Capture

Use hybrid streaming and batch design for mixed-latency analytics and reporting.

## Why This Is The First Decision

This project combines real-time ingestion with BI, so the first design decision should clarify which outputs are live operational views and which are curated reporting truth.

## Candidate Context Points

- not every consumer needs the same freshness
- streaming ingestion and curated marts solve different problems
- replay and stable BI output must coexist

## Candidate Alternatives

- make every layer real time
- remove streaming and use batch only

## Related Notes

- `README.md`
- `architecture-notes.md`
- `../../docs/architecture/adr/template.md`