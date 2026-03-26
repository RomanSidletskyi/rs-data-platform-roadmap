# ADR 0010: Introduce Quality Gates For Shared Data Products

## Status

Accepted

## Context

Shared datasets and metrics lose trust when quality failures are detected late and consumers receive bad data without clear guardrails.

## Decision

Introduce data quality checks and release gates for important shared data products.

## Consequences

Benefits:

- earlier detection of trust-breaking failures
- clearer release boundaries for curated data
- better incident routing and accountability

Drawbacks:

- extra operational gating logic
- risk of noisy blocking behavior if severity is designed badly