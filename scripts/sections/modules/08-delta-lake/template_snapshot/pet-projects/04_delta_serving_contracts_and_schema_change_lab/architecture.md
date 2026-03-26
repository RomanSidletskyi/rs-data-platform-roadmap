# Architecture

## Components

- governed gold Delta table
- one official consumer-facing view or table path
- schema-change review decision point
- downstream dashboard or analytics consumer

## Data Flow

1. curated Delta output is prepared for consumer use
2. an official access path is defined through a governed object
3. schema changes are reviewed for compatibility before they flow further
4. downstream consumption follows the supported path instead of informal direct reads

## Trade-Offs

- fast schema evolution can help engineering but hurt consumer stability
- one official access path improves support and governance clarity
- consumer contracts require more than successful table writes
