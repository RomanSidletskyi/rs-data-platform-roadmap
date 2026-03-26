# ADR 0009: Enforce Least Privilege For Sensitive Data Products

## Status

Accepted

## Context

Shared analytical platforms often accumulate broad access over time, which makes incident review, compliance, and trust significantly weaker.

## Decision

Apply least-privilege access as the default for sensitive data products and make exceptions explicit and reviewable.

## Consequences

Benefits:

- reduced blast radius
- clearer ownership and auditability
- stronger alignment between governance policy and system behavior

Drawbacks:

- more operational access design effort
- occasional friction for teams requesting broader access