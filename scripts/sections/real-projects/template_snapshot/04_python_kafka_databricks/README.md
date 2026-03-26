# Real Project 04: Python Plus Kafka Plus Databricks

## Goal

Extend a streaming ingestion pattern into analytical processing using Databricks.

The project should make the separation between event transport and analytical modeling explicit.

## Suggested Stack

- Python
- Kafka
- Databricks

## Architecture Focus

- raw event landing
- separation between transport and curated analytics
- replayable ingestion into analytical storage
- complexity growth across layers

## Suggested Deliverables

- event producer or simulated source
- Kafka ingestion flow
- raw landing into analytical storage
- first curated analytical output
- design notes describing the layer boundary

## Review Questions

- where does transport end and analytical modeling begin
- how would raw events be replayed after a bug
- which layer is safe for reporting and which is not

## Read With

- `../../docs/architecture/reviews/real-project-review-exercises.md`
- `../../docs/architecture/reviews/system-shape-review-checklist.md`
- `../../docs/architecture/adr/template.md`