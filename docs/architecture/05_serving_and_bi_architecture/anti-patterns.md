# Serving And BI Architecture Anti-Patterns

## Why This Note Exists

Serving layers fail when teams optimize for loader convenience instead of business trust and consistent consumption.

## Anti-Pattern 1: BI Reads Raw Tables Directly

Why it is bad:

- users inherit unstable source structure
- business meaning stays implicit and fragmented

Better signal:

- semantic or curated layers isolate BI from raw ingestion complexity

## Anti-Pattern 2: Every Dashboard Redefines Metrics

Why it is bad:

- KPI drift becomes inevitable
- teams debate numbers instead of decisions

Better signal:

- core definitions are reusable and governed centrally enough

## Anti-Pattern 3: Technical Models Presented As Business Models

Why it is bad:

- consumers must understand ingestion quirks and join logic themselves
- self-service turns into self-confusion

Better signal:

- serving models are shaped around analytical questions, not raw loader structure

## Anti-Pattern 4: Performance Tuning Happens Only In BI

Why it is bad:

- semantic and storage design misalignment remains unsolved
- dashboards stay slow despite visual-layer optimizations

Better signal:

- storage, semantic model, and dashboard patterns are designed together

## Review Questions

- where is metric truth defined
- which tables are safe for business users to consume directly
- would a new analyst understand this model without ingestion-specific context