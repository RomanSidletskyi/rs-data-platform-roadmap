# Solutions: PySpark DataFrames And Transformations

## Task 1

Possible grain:

- one row per customer per event date

Possible mistakes if grain is unclear:

- revenue may be double-counted after downstream joins
- consumers may aggregate the dataset incorrectly

## Task 2

A large-to-small enrichment join is usually simpler than a large fact-to-fact join because one side acts more like reference context.

Before the join, prune:

- unused columns
- irrelevant rows
- obviously invalid keys

This reduces data movement and keeps the join semantically cleaner.

## Task 3

- null revenue values: define whether they mean zero, missing, or invalid
- malformed timestamps: quarantine or flag them rather than silently guessing
- inconsistent country codes: standardize before core aggregations

The main idea is to make semantics explicit before the model becomes consumer-facing.

## Task 4

Output layout affects read cost, partition pruning, backfills, and consumer usability. A technically correct dataset can still be an architectural problem if its layout creates slow downstream scans or too many tiny files.