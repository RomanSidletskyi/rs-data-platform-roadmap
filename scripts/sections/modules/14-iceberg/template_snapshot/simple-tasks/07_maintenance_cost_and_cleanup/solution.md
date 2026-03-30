# 07 Maintenance Cost And Cleanup Solution

## Task 1 - Decide When To Run Compaction

One strong answer: schedule compaction periodically based on observed small-file pressure and query degradation, for example daily or several times per day for hot tables. Every-write compaction is weak because it adds constant rewrite overhead and can turn maintenance into the dominant workload.

## Task 2 - Choose A Snapshot Expiration Posture

One strong answer: keep a recent debugging window deliberately, then expire older snapshots on a governed cadence. Trade-off: longer retention improves investigation and rollback options, while shorter retention reduces metadata and storage cost.

## Task 3 - Separate Business Delete From Maintenance Cleanup

Business delete changes row visibility in the table contract. Physical cleanup removes or rewrites obsolete layout and historical artifacts later. One maintenance action is `expire_snapshots`, often paired with rewrite procedures.

## Task 4 - Diagnose Metadata Growth Cost

Likely problem: the table is accumulating metadata overhead faster than business value, often because of too many small writes or mutation-heavy patterns. Cost is not only storage bytes because planning, maintenance, retries, and debugging effort also increase.

## Task 5 - Choose A Safer Cleanup Boundary

Cleanup must account for branches and tags because referenced snapshots may still be intentionally protected. If you ignore them, you can break reproducibility expectations or remove state that a governed reference still depends on.

## Task 6 - Design A Minimal Maintenance Plan

One strong plan:

1. run `rewrite_data_files` on a scheduled cadence matched to daily merge pressure
2. expire snapshots with a deliberate recent-history window instead of immediate aggressive cleanup
3. monitor file counts, planning time, and manifest growth so maintenance is triggered by evidence rather than habit