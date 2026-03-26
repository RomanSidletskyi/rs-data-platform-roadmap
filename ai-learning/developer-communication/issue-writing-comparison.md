# Issue Writing Comparison

This guide compares weak, acceptable, and strong issue-writing patterns.

## Weak Pattern

```text
Pipeline is broken. Please fix.
```

Why it fails:

- no scope
- no reproduction
- no impact
- no clue what is known versus guessed

## Acceptable Pattern

```text
The ingestion pipeline fails for files with the new schema version.
This started after the upstream change on March 24.
It seems related to an unknown column in the parser.
```

Why it is only acceptable:

- the symptom is clearer
- but impact, scope, and reproduction are still incomplete

## Strong Pattern

```text
The bronze ingestion job fails when processing files with schema version 2026-03.

Expected:
- the new optional field should be ignored or handled safely

Actual:
- the parser raises an unknown-column error and the batch stops

Scope:
- daily customer events bronze ingestion

Impact:
- downstream silver refresh is blocked

Reproduction:
- run the local fixture for the 2026-03 schema sample

Known versus unknown:
- known: failure starts only with the new schema sample
- unknown: whether the root cause is strict parser config or schema-mapping drift
```

## Rule

The strongest issue is not the longest one.

It is the one that lets another engineer act with minimal follow-up questions.