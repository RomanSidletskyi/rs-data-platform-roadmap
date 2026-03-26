# ADR 0001: Store Raw Data Before Transformation

## Status

Accepted

## Context

Pipelines often need reprocessing, debugging, and auditability.

## Decision

Always store raw input data before transformations.

## Consequences

Benefits:

- reprocessing
- debugging
- source-of-truth retention

Drawbacks:

- more storage
- retention policy needs
