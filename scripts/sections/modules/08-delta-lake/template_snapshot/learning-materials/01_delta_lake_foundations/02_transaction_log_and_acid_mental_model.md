# Transaction Log And ACID Mental Model

## Why This Topic Matters

Delta Lake becomes easier to reason about once the learner understands that the real product is not only the data files.

The real product is the table state described by the transaction log.

## Core Mental Model

A Delta table is built from two things:

- data files
- the transaction log that records which files belong to each table version

That log is what makes it possible to:

- commit writes atomically
- isolate concurrent operations
- reconstruct previous table versions
- reason about updates and deletes safely

## Example

A merge operation is conceptually not "edit one Parquet file in place."

It is closer to:

1. read current table state
2. write new files representing the changed state
3. commit a new table version in the log

## Why This Matters

Without this mental model, learners often misunderstand:

- why Delta can support time travel
- why VACUUM is safety-sensitive
- why conflicts and retries matter

## Key Architectural Takeaway

Delta Lake reliability comes from file-plus-log table state, not from magical mutation of files in place.
