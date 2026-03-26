# Architecture - 02 JSON Normalizer

## Components

- input JSON files
- JSON reader
- normalization and flattening logic
- flat output writer
- validation or fallback handling

## Data Flow

1. read nested JSON input
2. validate structural assumptions
3. flatten selected nested fields
4. write normalized output
5. report errors or skipped records

## Trade-Offs

- more aggressive flattening makes downstream use easier
- flattening without a clear contract can silently lose meaning

## What Would Change In Production

- config-driven mappings
- schema contracts
- Parquet output or warehouse landing