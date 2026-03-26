# Real Project 06: Databricks Plus ADLS Plus Power BI

## Goal

Build a curated lakehouse-to-BI flow from storage and transformation layers into business consumption.

The project should make semantic serving and dashboard safety visible.

## Suggested Stack

- Databricks
- ADLS
- Power BI

## Architecture Focus

- medallion-to-serving flow
- semantic consistency
- BI-safe curated outputs
- business-facing metric stability

## Suggested Deliverables

- bronze, silver, and gold data flow
- curated mart or serving model
- Power BI dashboard or semantic model description
- documentation of stable business-facing outputs

## Review Questions

- where does business truth become stable
- what raw or technical layers are intentionally hidden from BI
- how is KPI drift prevented

## Read With

- `../../docs/architecture/reviews/real-project-review-exercises.md`
- `../../docs/architecture/reviews/lakehouse-serving-review-checklist.md`
- `../../docs/architecture/adr/template.md`