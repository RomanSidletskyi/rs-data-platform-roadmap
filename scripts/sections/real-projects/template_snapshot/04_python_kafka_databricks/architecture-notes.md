# Architecture Notes

## Project

`04_python_kafka_databricks`

## Intended System Shape

Streaming ingestion feeding analytical storage and modeling:

    Producer -> Kafka -> Raw Event Landing -> Analytical Processing -> Curated Output

## Main Responsibilities

- event transport
- raw event preservation
- analytical processing in Databricks
- separation between technical landing and business-facing output

## Key Design Questions

- where does event transport end and analytical modeling begin
- how are raw events replayed after a processing bug
- which layer is safe for reporting and which is not

## First Risks To Watch

- raw event landing consumed directly as reporting truth
- transport and transformation concerns mixed together
- analytical layer inherits stream semantics without curation

## Candidate ADRs

- `Separate Event Transport From Analytical Transformation`
- `Preserve Raw Events Before Curated Databricks Models`

## Review Pairing

- `../../docs/architecture/reviews/system-shape-review-checklist.md`
- `../../docs/architecture/adr/template.md`