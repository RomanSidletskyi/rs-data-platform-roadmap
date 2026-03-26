# Simple Tasks: Table Operations And Change Patterns

## Task 1: Merge Or Append

A table stores latest customer status by `customer_id`.

Explain whether append-only writes are enough or whether `MERGE` is the healthier choice.

## Task 2: Bounded Overwrite

You need to rebuild only one business date after a transformation bug.

Explain why bounded overwrite can be healthier than full overwrite.

## Task 3: Partitioning Choice

A sales table is usually queried by `order_date`, but analysts also filter by `store_id`.

Explain how you would think about partitioning and why you would avoid bad partition keys.

## Task 4: CDC Versus SCD

Explain the difference between loading latest state from change events and preserving state history for consumers.
