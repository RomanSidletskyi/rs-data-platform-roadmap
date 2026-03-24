# Project ADR Starter

## Project

`06_databricks_adls_powerbi`

## Initial Decision To Capture

Serve BI from curated semantic outputs rather than technical storage layers.

## Why This Is The First Decision

This project introduces business-facing dashboards, so the first architectural decision should protect semantic consistency and consumption boundaries.

## Candidate Context Points

- BI should not depend on bronze or silver directly
- KPI definitions should be stable and reusable
- business truth should be clearer than storage mechanics

## Candidate Alternatives

- expose gold or silver directly to reports without semantic layer
- let each dashboard define metrics independently

## Related Notes

- `README.md`
- `architecture-notes.md`
- `../../docs/architecture/adr/template.md`