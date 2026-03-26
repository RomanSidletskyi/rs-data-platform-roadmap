# Solutions: Delta Lake Cookbook

## Task 1

A useful `MERGE` checklist includes: what one row represents, what the match key is, whether updates and inserts both exist, how duplicates are handled, and whether reruns must preserve the same final state.

## Task 2

Main partitioning questions: what filters dominate reads, what key supports bounded repair, how cardinality will grow, whether layout tuning may be enough, and whether the partition key helps both reads and rewrites.

## Task 3

Before choosing restore or bounded rewrite, check: exact damage scope, whether newer valid writes exist, whether restoring would roll back good work, which consumers may see restated values, and whether a narrow repair is safer.

## Task 4

Before allowing schema evolution downstream, check: whether the change is additive or semantic, which consumers depend on the old shape, whether the change should stop in silver, whether views or BI logic will break, and whether the platform should force explicit review.
