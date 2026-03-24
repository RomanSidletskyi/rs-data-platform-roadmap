# Architecture - 05 Incremental Ingestion Simulator

## Components

- source dataset
- source reader
- persisted state store
- diff or change-detection logic
- incremental output writer

## Data Flow

1. read source records
2. load existing state
3. identify new or changed records
4. write incremental output
5. update state after success

## Trade-Offs

- full reloads are simpler but wasteful
- incremental state introduces more logic but reflects real platform behavior better

## What Would Change In Production

- watermark tracking
- partitioned object-storage output
- stronger idempotency guarantees
- orchestration-aware recovery