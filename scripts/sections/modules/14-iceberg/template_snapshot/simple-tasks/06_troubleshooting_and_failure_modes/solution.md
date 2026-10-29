# 06 Troubleshooting And Failure Modes Solution

## Task 1 - Debug Different Row Counts Across Two Engines

One strong order:

1. compare the current snapshot each engine is reading
2. compare whether both engines understand the table features being used
3. inspect manifest and delete-file participation for the current snapshot
4. verify catalog and namespace configuration consistency

Key point: different row counts can come from metadata interpretation or engine compatibility differences, not only storage damage.

## Task 2 - Diagnose A Small-File Problem

Diagnosis: classic small-file and planning-overhead problem.

Action: run `rewrite_data_files` and review write batching behavior.

Why this is more than storage cost: too many small files increase manifest growth, planning work, and scan inefficiency.

## Task 3 - Recognize A Commit-Conflict Scenario

Likely reason: both writers started from an older view of the table state, and when one writer committed first, the second writer's expected metadata base became stale. Optimistic concurrency protects correctness by rejecting a conflicting commit rather than silently corrupting table state.

## Task 4 - Find The Most Likely Misconfiguration Layer

Three likely layers:

1. catalog configuration
2. engine feature support and reader configuration
3. namespace or storage path assumptions

Catalog is a prime suspect because it defines how the engine resolves the table metadata root in the first place.

## Task 5 - Choose A Better Failure Analysis Question

Better questions:

1. which current snapshot is each engine resolving for this table
2. are delete files or other `v2` features involved that one engine may interpret differently
3. is the catalog or namespace configuration identical across the readers involved

## Task 6 - Plan A Minimal Incident Response

One strong response:

1. inspect current snapshot, manifests, and delete-heavy metadata state
2. verify whether the slowdown is associated with small files or accumulated delete artifacts
3. run a governed maintenance step such as `rewrite_data_files`, then review retention posture separately

Key point: full rebuild is often too blunt as a first response because the real problem may be metadata growth or neglected maintenance rather than irrecoverable table design.