# Issue Writing Example

## Scenario

Bronze ingestion started failing after an upstream schema change.

## Weak Version

### Title

Pipeline is broken after schema update

### Body

The ingestion job started failing after upstream changed something in the schema.

Please investigate because downstream is affected.

## Why This Is Weak

- it does not identify which pipeline is failing
- it does not explain expected versus actual behavior
- impact is implied but not scoped
- it hides what is known and what is still uncertain

## Strong Version

### Title

Bronze customer events ingestion fails on schema version 2026-03 sample

### Body

Summary:

The bronze ingestion job fails when it processes files produced with the new upstream schema version `2026-03`.

Expected behavior:

- the new optional field should be ignored or mapped safely
- the batch should continue processing valid records

Actual behavior:

- the parser raises an unknown-column error
- the daily bronze batch stops before publishing output

Scope:

- affected workflow: customer events bronze ingestion
- affected environment: local fixture reproduction and the scheduled dev run

Impact:

- silver refresh is blocked for downstream model development
- schema drift handling is now unclear for future upstream changes

Known facts:

- the failure started only after the upstream team introduced schema version `2026-03`
- the previous sample schema version succeeds with no changes
- the failure happens before any transformation logic runs

Unknowns:

- whether the root cause is strict parser configuration or stale schema mapping
- whether the new field is intended to remain optional across all producers

Reproduction:

1. run the bronze ingestion fixture with the `2026-03` schema sample
2. observe the parser error for the unknown column
3. compare with the `2026-02` sample, which succeeds

Next action:

- confirm intended schema-handling rule with upstream owners
- decide whether to ignore unknown optional columns or update schema mapping explicitly

## Why This Is Strong

- it separates facts from open questions
- it gives another engineer enough context to triage immediately
- it names both local impact and likely next action