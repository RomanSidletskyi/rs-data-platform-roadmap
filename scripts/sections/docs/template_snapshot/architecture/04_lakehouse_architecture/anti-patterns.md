# Lakehouse Architecture Anti-Patterns

## Why This Note Exists

Lakehouse designs become expensive and confusing when the medallion idea is copied as a label instead of used as a responsibility model.

## Anti-Pattern 1: Calling Any File Lake A Lakehouse

Why it is bad:

- teams think they have stronger reliability semantics than they actually do
- operational repair, schema evolution, and table management remain weak

Better signal:

- table semantics, layered responsibilities, and repair behavior are explicit

## Anti-Pattern 2: Bronze, Silver, And Gold With No Boundary Meaning

Why it is bad:

- each layer becomes a renamed copy of the previous one
- data contracts are unclear

Better signal:

- each layer answers a different question: raw preservation, cleanup, or business serving

## Anti-Pattern 3: Dashboards Reading Bronze Or Silver

Why it is bad:

- unfinished technical data becomes business-facing truth
- schema changes break consumers unexpectedly

Better signal:

- BI and downstream consumers read stable gold or semantic outputs

## Anti-Pattern 4: Table Format Features Ignored Until Failure

Why it is bad:

- teams postpone decisions about schema evolution, upserts, and repairability
- operational problems appear under load or during incidents

Better signal:

- format capabilities are chosen according to recovery and governance needs early

## Review Questions

- what exactly makes this system a lakehouse rather than a file landing zone
- which consumers are allowed to read each layer
- how would we repair a broken transformation without losing raw truth