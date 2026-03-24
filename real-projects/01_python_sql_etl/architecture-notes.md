# Architecture Notes

## Project

`01_python_sql_etl`

## Intended System Shape

Simple scheduled batch ETL:

    Source -> Extract -> Raw Landing -> Transform -> Curated Output

## Main Responsibilities

- extraction from source
- preservation of raw input
- deterministic transformation logic
- curated analytical output for reporting

## Key Design Questions

- where is raw data stored before transformations
- how does rerun behavior stay safe and idempotent
- what output is stable enough for business consumption

## First Risks To Watch

- no raw preservation
- full refresh chosen without thinking about backfills
- curated output mixed with technical intermediate logic

## Candidate ADRs

- `Use Scheduled Batch ETL With Raw Preservation`
- `Separate Raw Landing From Curated Reporting Output`

## Review Pairing

- `../../docs/architecture/reviews/batch-pipeline-review-checklist.md`
- `../../docs/architecture/adr/template.md`