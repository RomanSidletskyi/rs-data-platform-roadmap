# 05 Branching Retention And Governance Solution

## Task 1 - Choose Branch Versus Tag

Scenario A: tag.

- quarter-close state should be a fixed reference

Scenario B: branch.

- validation writes require a mutable line of table state

Difference: tag is stable and reference-like, while branch is an active mutable reference that can advance with new commits.

## Task 2 - Set A Retention Policy By Use Case

One strong answer:

- raw replay-debug table: moderate retention focused on recent operational recovery
- curated finance audit table: longer and more governed retention posture
- temporary experimentation table: short retention and aggressive cleanup

Reasoning: retention should match replay, audit, and cost needs rather than follow one default everywhere.

## Task 3 - Choose A Safer Governance Boundary

One strong split:

- platform team owns catalog-level guardrails, namespace rules, and storage/governance controls
- domain team owns the business meaning, schema contract, and serving logic of the curated table

Mixing them causes confusion because control-plane safety and business semantics are different responsibilities.

## Task 4 - Decide Whether A Snapshot Reference Should Be Permanent

Recommended answer: not permanent.

- a two-week experiment should usually have a time-bounded lifecycle
- leaving too many stale references behind can preserve metadata and snapshots longer than intended and complicate cleanup expectations

## Task 5 - Protect An Audit Snapshot

Recommended answer: create a governed tag for the quarter-close state and align retention so the referenced snapshot is preserved for the required audit window.

Key point: reproducibility requires an explicit retained reference, not hope.

## Task 6 - Explain Why Governance Is Not Only SQL Access

One strong answer: governance includes who controls the catalog, which namespaces teams can publish into, how long historical state must be retained, and which write patterns are allowed. Query permissions alone do not control table lifecycle, metadata growth, or publish safety.