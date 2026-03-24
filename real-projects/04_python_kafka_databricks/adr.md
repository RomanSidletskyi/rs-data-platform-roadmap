# Project ADR Starter

## Project

`04_python_kafka_databricks`

## Initial Decision To Capture

Separate raw event transport from analytical transformation and curated reporting layers.

## Why This Is The First Decision

This project is where streaming ingestion begins to feed analytical processing, so the boundary between transport and business-serving must be explicit.

## Candidate Context Points

- Kafka carries raw event flow
- Databricks should model and curate, not only mirror the stream
- replay should rebuild analytical outputs safely

## Candidate Alternatives

- use raw event tables directly for analytics
- combine ingestion and business logic into one processing layer

## Related Notes

- `README.md`
- `architecture-notes.md`
- `../../docs/architecture/adr/template.md`