# Real Project 05: Python Plus Spark Plus Delta

## Goal

Build a small lakehouse-oriented project using Spark and Delta tables.

The project should justify why distributed compute and table-format semantics matter.

## Suggested Stack

- Python
- Spark
- Delta Lake

## Architecture Focus

- bronze, silver, and gold boundaries
- distributed transformation value
- Delta operational semantics
- repair and replay strategy

## Suggested Deliverables

- raw data ingestion into bronze
- cleanup or standardization into silver
- curated analytical output in gold
- brief explanation of why Delta is being used

## Review Questions

- what makes this a lakehouse rather than just files plus jobs
- why are Spark and Delta justified here
- which downstream consumers should read only gold outputs

## Read With

- `../../docs/architecture/reviews/real-project-review-exercises.md`
- `../../docs/architecture/reviews/lakehouse-serving-review-checklist.md`
- `../../docs/architecture/adr/template.md`