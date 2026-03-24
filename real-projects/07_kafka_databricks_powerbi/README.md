# Real Project 07: Kafka Plus Databricks Plus Power BI

## Goal

Build a mixed-latency analytical system where streaming ingestion and curated reporting coexist.

The project should make clear which parts of the platform are real-time and which are still batch-oriented.

## Suggested Stack

- Kafka
- Databricks
- Power BI

## Architecture Focus

- hybrid batch and streaming design
- streaming ingestion versus curated marts
- freshness promises versus actual usage
- replayability and serving stability

## Suggested Deliverables

- event ingestion path
- raw analytical landing
- curated reporting layer
- Power BI-facing business output
- notes describing which outputs are operational versus curated

## Review Questions

- which paths truly need low latency
- where does curated reporting diverge from live operational views
- how would recovery work after a downstream processing bug

## Read With

- `../../docs/architecture/reviews/real-project-review-exercises.md`
- `../../docs/architecture/reviews/streaming-platform-review-checklist.md`
- `../../docs/architecture/reviews/lakehouse-serving-review-checklist.md`
- `../../docs/architecture/adr/template.md`