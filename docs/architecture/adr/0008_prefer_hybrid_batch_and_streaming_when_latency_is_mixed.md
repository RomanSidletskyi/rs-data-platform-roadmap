# ADR 0008: Prefer Hybrid Batch And Streaming When Latency Is Mixed

## Status

Accepted

## Context

Some workloads need near-real-time reaction while reporting and historical curation still fit scheduled processing better.

## Decision

Use a hybrid architecture with streaming for low-latency paths and batch for curated analytical outputs when latency requirements are mixed.

## Consequences

Benefits:

- matches different workloads without forcing one latency model everywhere
- supports both operational reaction and stable reporting
- preserves replayable event history for analytical recomputation

Drawbacks:

- more moving parts
- stronger need for clear layer ownership