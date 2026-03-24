# Writing Better Issues

Good issues reduce wasted clarification loops.

## A Strong Issue Should Include

- what is happening
- what should happen instead
- why it matters
- where it happens
- how to reproduce it
- what is currently known and unknown

## Weak Example

```text
Pipeline is broken. Please fix.
```

## Better Example

```text
The batch ingestion job fails when processing files with the new schema version.
Expected behaviour: rows with the new optional field should still be accepted.
Actual behaviour: the parser raises an unknown-column error and the full batch stops.
Scope: bronze ingestion for daily customer events.
Impact: downstream silver refresh is blocked.
Reproduction: run the local sample using the 2026-03 schema fixture.
```

## How AI Helps

Use AI to:

- tighten wording
- improve structure
- identify missing context
- suggest reproduction or impact fields you forgot

Do not use AI to invent root causes you have not verified.