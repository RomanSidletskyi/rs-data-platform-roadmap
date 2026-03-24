# Solutions: Operating Delta Lake Tables

## Task 1

Useful health signals include write failures, merge-duration growth, file-count growth, maintenance frequency, and downstream freshness pain. Together these show whether the table is degrading operationally.

## Task 2

Broad overwrite becomes debt because it rewrites healthy data together with changed data, increases cost, expands failure scope, and teaches the platform to rely on oversized recovery patterns.

## Task 3

Small files and hot partitions are architectural clues because they often reflect write cadence, skewed key distribution, or bad layout choices. More compute alone does not solve the root shape problem.

## Task 4

Delta capability outruns discipline when teams use merge, schema evolution, and restore features without clear keys, contracts, retention thinking, or bounded repair design. That is how table syntax becomes platform debt.
