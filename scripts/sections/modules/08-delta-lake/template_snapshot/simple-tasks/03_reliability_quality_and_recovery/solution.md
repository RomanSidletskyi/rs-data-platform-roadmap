# Solutions: Reliability, Quality, And Recovery

## Task 1

Idempotent design means the same slice can be processed again without corrupting the final state. Retries become dangerous when rerunning duplicates rows, rewrites the wrong scope, or changes winner logic accidentally.

## Task 2

Full restore is not obviously best because it may undo valid newer changes. If only three days are wrong, bounded repair may preserve more healthy data and reduce recovery risk.

## Task 3

VACUUM is not only cleanup because it can remove files still needed for time travel, delayed readers, rollback, or incident analysis. Retention is therefore a reliability decision, not just a storage-cost decision.

## Task 4

A good silver-table rule could be that `order_id` must never be null. Silent success would be harmful because downstream consumers would inherit invalid keys and build joins, metrics, or contracts on corrupted rows.
