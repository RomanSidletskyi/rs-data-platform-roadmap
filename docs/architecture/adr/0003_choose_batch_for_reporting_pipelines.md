# ADR 0003: Choose Batch for Reporting Pipelines

## Status

Accepted

## Context

Many reporting workflows do not require real-time processing.

## Decision

Prefer batch architecture for reporting unless low latency is a real requirement.

## Consequences

Benefits:

- simpler architecture
- lower operational cost
- easier debugging
