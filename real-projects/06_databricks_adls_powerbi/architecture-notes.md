# Architecture Notes

## Project

`06_databricks_adls_powerbi`

## Intended System Shape

Lakehouse-to-BI serving flow:

    ADLS -> Databricks Bronze / Silver / Gold -> Semantic / BI Layer -> Dashboards

## Main Responsibilities

- layered storage and transformation
- curated business-serving outputs
- semantic consistency for KPI delivery
- dashboard-safe consumption boundaries

## Key Design Questions

- where does business truth become stable
- what technical layers are intentionally hidden from Power BI
- how is KPI drift prevented across reports

## First Risks To Watch

- Power BI reads bronze or silver directly
- KPI logic is redefined in dashboards
- storage structure drives serving design instead of business usage

## Candidate ADRs

- `Serve BI From Curated Semantic Models Over Lakehouse Layers`
- `Prevent Dashboards From Reading Technical Lakehouse Layers Directly`

## Review Pairing

- `../../docs/architecture/reviews/lakehouse-serving-review-checklist.md`
- `../../docs/architecture/adr/template.md`