# Project ADR Starter

## Project

`01_python_sql_etl`

## Initial Decision To Capture

Use scheduled batch ETL with explicit raw landing before curated analytical output.

## Why This Is The First Decision

This project should first establish correct layer boundaries and safe rerun behavior before adding more tooling or orchestration complexity.

## Candidate Context Points

- the project is batch-oriented
- analytical trust matters more than low latency
- replay and recovery require raw preservation

## Candidate Alternatives

- load directly into the reporting table
- skip raw storage and transform in place

## Related Notes

- `README.md`
- `architecture-notes.md`
- `../../docs/architecture/adr/template.md`