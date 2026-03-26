# Project ADR Starter

## Project

`05_python_spark_delta`

## Initial Decision To Capture

Adopt Spark and Delta only where layered lakehouse responsibilities and repairability justify the stack.

## Why This Is The First Decision

This project introduces a heavier lakehouse toolset, so the first decision should defend why the stack is needed and how the layers differ.

## Candidate Context Points

- bronze, silver, and gold should have distinct meanings
- Delta should add operational value, not only branding
- distributed processing should match real workload shape

## Candidate Alternatives

- simpler batch ETL on local or lighter infrastructure
- single-stage transformation without layered table model

## Related Notes

- `README.md`
- `architecture-notes.md`
- `../../docs/architecture/adr/template.md`