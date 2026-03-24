# ADR Comparison

This guide compares weak, acceptable, and strong architecture decision record patterns.

## Weak Pattern

```text
We chose Delta Lake because it is better.
```

Why it fails:

- no context
- no constraints
- no rejected alternatives
- no trade-offs

## Acceptable Pattern

```text
We chose Delta Lake because we need schema evolution and better data reliability.
Iceberg was considered but not selected.
```

Why it is only acceptable:

- it gives a direction
- but still does not explain what trade-off was accepted

## Strong Pattern

```text
Decision:
- use Delta Lake for the current platform table layer

Constraints:
- Spark-first execution today
- frequent schema changes
- need recovery after partial failures

Alternatives considered:
- raw Parquet tables
- Apache Iceberg

Why this option was chosen:
- Delta gives stronger built-in support for transactional reliability in the current Spark-first environment
- it reduces local operational complexity for merge, repair, and recovery workflows

Trade-offs accepted:
- weaker multi-engine neutrality than an Iceberg-first approach
- tighter alignment with a Spark-centric stack

What might change later:
- if multi-engine access becomes a primary requirement, the table-format decision should be revisited
```

## Rule

A strong ADR explains not only why the chosen option is good, but why the rejected options were not chosen.