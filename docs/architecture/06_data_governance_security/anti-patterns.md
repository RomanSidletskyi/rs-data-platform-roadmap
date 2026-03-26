# Data Governance And Security Anti-Patterns

## Why This Note Exists

Governance failures usually come from vague ownership and convenience-first access, not from missing tooling alone.

## Anti-Pattern 1: Shared Broad Access By Default

Why it is bad:

- sensitive data spreads faster than teams realize
- incident review becomes ambiguous because too many actors could change or read critical assets

Better signal:

- least privilege is the starting point and exceptions are explicit

## Anti-Pattern 2: Governance As Documentation Only

Why it is bad:

- policies exist but system behavior does not enforce them
- teams assume written rules equal operational control

Better signal:

- ownership, access, and audit rules are encoded in platform behavior

## Anti-Pattern 3: No Clear Dataset Ownership

Why it is bad:

- incidents get routed late
- quality, access, and schema decisions have no accountable owner

Better signal:

- every important dataset and serving layer has a named owner

## Anti-Pattern 4: Sandbox And Production Paths Mixed Together

Why it is bad:

- accidental writes and reads cross trust boundaries
- debugging behavior leaks into production workflows

Better signal:

- environments are distinct in access, storage paths, and operational behavior

## Review Questions

- who owns this dataset end to end
- who can read, publish, or delete it
- what evidence would an incident review rely on after a failure