# Schema Evolution

## Problem

Data changes over time:

- new columns appear
- types evolve
- source payloads drift

## Lakehouse Need

A scalable platform must handle schema change intentionally.

## Common Practices

- enforce schema in curated layers
- allow controlled evolution in ingestion layers
- add audit logic around schema changes
- document table contracts

## Main Trade-Off

Too strict:
- breaks ingestion often

Too loose:
- creates schema chaos
