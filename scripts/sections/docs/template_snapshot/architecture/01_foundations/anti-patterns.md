# Foundations Anti-Patterns

## Why This Note Exists

Foundational mistakes usually create long-term architectural confusion because the team misclassifies the problem before choosing tools.

## Anti-Pattern 1: Reporting Directly From OLTP

Why it is bad:

- analytical load competes with operational traffic
- business reporting becomes fragile during production spikes
- query shape is optimized for transactions, not analysis

Better signal:

- operational and analytical responsibilities are separated explicitly

## Anti-Pattern 2: Choosing Streaming Because It Sounds Advanced

Why it is bad:

- the team pays operational cost without business justification
- replay, idempotency, and sink correctness are often underdesigned

Better signal:

- latency need, replay value, and fan-out need are all explicit

## Anti-Pattern 3: No Raw Preservation

Why it is bad:

- bugs are harder to investigate
- replay and data correction become expensive or impossible

Better signal:

- raw input is preserved before business reshaping

## Anti-Pattern 4: One Layer For Everything

Why it is bad:

- ingestion, transformation, and serving become tightly coupled
- downstream users consume unstable technical data as business truth

Better signal:

- raw, transformed, and serving layers have distinct responsibilities

## Review Questions

- did we classify the workload as operational or analytical correctly
- are we paying for low latency without real business need
- could we rerun this system safely after failure