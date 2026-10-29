# 01 Iceberg Metadata And Table State Solution

## Task 1 - Identify The Current Table State From Metadata

One strong answer:

1. start from the current metadata root file
2. inspect `current-snapshot-id` in `metadata.json`
3. locate the matching snapshot entry inside `snapshots`
4. read the `manifest-list` path from that snapshot entry
5. open the manifest list to see which manifests define the snapshot
6. open the manifests to see which data and delete files participate

Key point: current table state is defined by metadata, not by whichever parquet file looks newest in storage.

## Task 2 - Distinguish Manifest List Versus Manifest

Manifest list:

- belongs to a snapshot
- points to one or more manifests
- summarizes file and row counts across those manifests
- tells the reader which manifests matter for that snapshot

Manifest:

- contains file-level entries
- indexes data files or delete files
- carries partition and bounds metadata for planning
- lets the engine decide which files should be scanned

Why separate them: the snapshot-level object can stay compact while manifests can be reused or replaced more selectively.

## Task 3 - Choose V1 Versus V2 For A Table Contract

Scenario A: `v1`.

- append-only event log does not need delete-file mutation semantics
- simpler compatibility model is enough
- schema evolution and snapshot history still work

Scenario B: `v2`.

- current-state table needs row-level mutation behavior
- late corrections and deletes by business key are part of the contract
- delete-aware planning becomes important

Risk of casual `v2`: you increase semantic and engine-compatibility expectations without a real workload reason.

## Task 4 - Explain What A Commit Rebuilds

One strong answer:

1. a new data file is written
2. a new or updated manifest is written to describe that file
3. a new manifest list is written for the new snapshot
4. a new metadata root file is written
5. the catalog pointer is advanced to the new metadata root

Key point: the catalog does not point to the parquet file. It points to the latest metadata root.

## Task 5 - Explain Equality Delete Versus Position Delete

Case 1: equality delete.

- delete identity is based on business key values like `order_id`

Case 2: position delete.

- delete identity is based on physical file path plus row position

Comparison: equality delete is value-based, while position delete is file-layout-aware. Both still rely on metadata planning so the engine knows which delete artifacts apply to which reads.

## Task 6 - Trace A Table State By Hand

One strong chain:

1. catalog -> `000121-a9b4.metadata.json`
2. metadata root -> current snapshot and `snap-702.avro`
3. manifest list -> `manifest-a2.avro`
4. manifest entry -> `data/2026/03/27/00000-35-1e8d.parquet`

What each step contributes:

- catalog tells you the current metadata root
- metadata root tells you which snapshot is current
- manifest list tells you which manifests define that snapshot
- manifest tells you which concrete data files participate