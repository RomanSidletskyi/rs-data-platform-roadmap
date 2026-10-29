# Manifest Lists, Manifests, And Data Files In Detail

## 1. The Three Layers People Constantly Confuse

Many engineers compress the whole metadata tree into one vague sentence like:

- Iceberg stores metadata about parquet files

That is too weak.

The real hierarchy is:

1. metadata JSON defines snapshot references
2. a snapshot points to one manifest list
3. a manifest list points to many manifests
4. each manifest points to many data files or delete files

That is not accidental layering. Each level solves a different planning problem.

## 2. What A Data File Is

A data file is where rows actually live.

Usually that means:

- Parquet
- ORC
- Avro

At file level, Iceberg cares about metadata such as:

- file path
- file format
- record count
- file size
- partition tuple
- lower and upper bounds per column where available
- null counts and value counts where available
- split offsets for scan planning

So a data file is not just bytes on S3. It is a file with planning metadata attached through the manifest layer.

## 3. What A Manifest Is

A manifest is an immutable Avro file that lists files belonging to part of a table snapshot.

A manifest is not the whole table.

It is a subset of files under one partition spec.

This detail matters a lot.

Because manifests are partition-spec-specific:

- when partition spec changes, old manifests do not need to be rewritten immediately
- new files can be written into manifests using the new spec
- the table can evolve while retaining readable older state

## 4. What A Manifest Entry Represents

Each manifest entry typically tells the planner:

- whether the file is `ADDED`, `EXISTING`, or `DELETED`
- which snapshot added or deleted it
- sequence information where relevant
- the nested `data_file` structure containing file-level stats

That means manifests do two jobs at once:

- file inventory
- file lifecycle tracking

## 5. Why Manifests Exist Instead Of One Giant File List

Without manifests, large tables would be much more expensive to plan.

Manifests create smaller planning units so the engine can:

- skip whole groups of files
- preserve immutability of metadata units
- avoid rewriting the entire file inventory on every commit

So manifests are not merely organizational. They are a scaling mechanism.

## 6. What A Manifest List Is

A manifest list is one level above manifests.

Each snapshot points to exactly one manifest list.

That manifest list says, in effect:

- these are the manifests that define this snapshot
- here is summary information about each manifest

The planner can often prune at manifest-list level before even opening all manifests.

## 7. What Lives In A Manifest List Entry

A manifest list entry typically includes fields such as:

- manifest path
- manifest length
- partition spec ID
- content type: data or deletes
- sequence number metadata
- minimum data sequence number
- counts of added, existing, and deleted files
- counts of added, existing, and deleted rows
- field summaries for partition values

This is why manifest lists are so powerful.

They let planning happen one level above raw file inventory.

## 8. Why Manifest Lists Matter More In V2

In modern Iceberg thinking, especially with `v2` semantics, manifest lists are central because they carry sequence and content information needed for correct planning.

This is one reason the spec tightened around them.

The manifest list is not just a convenience index.

It is part of the correctness and efficiency model.

## 9. Data Manifest Versus Delete Manifest

Not every manifest tracks the same thing.

A manifest can track either:

- data files
- delete files

but not both mixed together.

That separation helps planning because delete application has different semantics from normal data scanning.

## 10. How Planning Uses The Layers

A simplified read-planning path looks like this:

1. load current metadata JSON
2. locate current snapshot
3. load manifest list for that snapshot
4. use manifest-level summaries to skip irrelevant manifests
5. read only the necessary manifests
6. use file-level metrics inside manifests to prune data files
7. produce final scan tasks

This explains why Iceberg can outperform naive parquet-lake reads even when the underlying files are similar.

## 11. Concrete Mental Example

Imagine a table with 50,000 parquet files.

You do not want every query to:

- list all files from object storage
- open file footers for all files
- discover relevant partitions by path parsing

Instead, Iceberg may allow the engine to:

- read one metadata JSON
- read one manifest list
- open only a fraction of manifests
- scan only the final selected files

That is the point of the hierarchy.

## 12. What Changes On Commit

When a writer commits, it does not normally rebuild everything from scratch.

Instead it often:

- creates new data files or delete files
- writes new manifests for newly produced files
- reuses existing manifests where possible
- writes a new manifest list for the new snapshot
- writes a new metadata JSON root pointing at that snapshot

That selective rebuild behavior is one of the core reasons Iceberg scales.

## 13. Why Old Manifests Can Survive New Commits

Because metadata files are immutable, old manifests can remain valid as long as they are still referenced by newer snapshots.

That means a commit often reuses large parts of prior metadata state instead of rewriting the full metadata tree.

Architecturally this gives:

- better scalability
- easier retries
- cleaner snapshot isolation

## 14. The Failure Pattern To Avoid

Do not teach Iceberg as if the hierarchy were:

- table -> files

That erases the real design.

The correct operational hierarchy is:

- table -> metadata root -> snapshot -> manifest list -> manifests -> data or delete files

If a learner does not clearly see those layers, they will struggle with:

- mutation semantics
- commit retries
- scan planning
- compaction reasoning
- catalog troubleshooting

## 15. Architect Rule

Manifest lists are snapshot-level indexes.

Manifests are file-group indexes.

Data files hold rows.

If you keep those three responsibilities separate in your head, most of Iceberg becomes much easier to reason about.