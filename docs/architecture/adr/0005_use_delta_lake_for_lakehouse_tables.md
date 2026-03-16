# ADR 0005: Use Delta Lake for Lakehouse Tables

## Status

Accepted

## Context

Plain Parquet files do not provide all table-management features needed for production lakehouse workflows.

## Decision

Use Delta Lake for production lakehouse tables.

## Consequences

Benefits:

- transactional reliability
- schema evolution
- merge support
