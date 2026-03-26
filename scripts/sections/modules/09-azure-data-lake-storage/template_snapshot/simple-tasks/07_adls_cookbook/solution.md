# Solutions: ADLS Cookbook

## Task 1

Choose a new storage account only when you need a stronger administrative, network, or compliance boundary.

Choose a new container for a major logical boundary with distinct lifecycle or access expectations.

Choose a new top-level path when the dataset fits existing broad boundaries but still needs its own stable namespace.

## Task 2

Give the Databricks workload the narrowest write scope needed on the raw subtree.

Give analysts read access only to the publish subtree through group-based access where possible.

Avoid broad rights across the whole container when the requirement is path-specific.

## Task 3

A temporary curated folder is weak because it exposes internal processing structure as if it were a consumer contract.

A stronger publish boundary uses a stable, intentionally named path with clear ownership and change expectations.

## Task 4

Review cleanup by separating replay-critical raw history, active consumer-facing publish data, reconstructible curated outputs, and temporary backfill remnants.

Delete only after confirming retention policy, downstream dependence, and recovery strategy.

## Task 5

The main problems are that consumers depend on an internal working path, access scope is too broad, and cleanup is being planned before replay and contract boundaries are understood.

The fix order should be: establish a proper publish boundary, narrow consumer access to supported paths, then review raw retention and cleanup against replay and audit requirements.
