# Architecture Notes

## Project

`05_python_spark_delta`

## Intended System Shape

Lakehouse-style batch processing with layered tables:

    Ingestion -> Bronze -> Silver -> Gold

## Main Responsibilities

- raw preservation in bronze
- cleanup and standardization in silver
- business-serving output in gold
- operational table semantics through Delta

## Key Design Questions

- what real need justifies Spark and Delta here
- what distinct responsibility does each layer carry
- how are replay and repair handled after transformation bugs

## First Risks To Watch

- Spark chosen before scale requires it
- bronze, silver, and gold become renamed copies
- dashboards or consumers read non-gold tables directly

## Candidate ADRs

- `Adopt Delta Tables Only When Repairability And Layering Matter`
- `Separate Bronze Silver And Gold By Responsibility`

## Review Pairing

- `../../docs/architecture/reviews/lakehouse-serving-review-checklist.md`
- `../../docs/architecture/adr/template.md`