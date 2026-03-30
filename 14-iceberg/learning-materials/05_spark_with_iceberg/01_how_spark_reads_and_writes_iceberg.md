# How Spark Reads And Writes Iceberg

## 1. Why Spark Matters So Much

Spark is one of the most important engines in the Iceberg ecosystem.

It is often the main engine for:

- table creation
- heavy transforms
- mutation-heavy jobs
- maintenance operations

So understanding Iceberg without Spark is incomplete.

## 2. How Spark Reads An Iceberg Table

Spark does not treat a healthy Iceberg table like a random folder scan.

At a high level it:

1. resolves the table through a catalog
2. loads current metadata
3. plans files using manifests and stats
4. pushes pruning as early as possible
5. scans only selected files

That means query planning quality depends on metadata quality.

More concretely, Spark benefits from Iceberg metadata because it can use:

- partition pruning
- file-level statistics
- manifest-level filtering
- explicit snapshot state instead of directory guessing

That is what makes Spark + Iceberg much more disciplined than generic parquet-folder access.

## 3. How Spark Writes An Iceberg Table

Spark writes are not just “save parquet.”

Spark must:

- plan output files
- update manifests and metadata references
- attempt a safe commit against current table state

In practical terms, that means the Spark writer is coordinating with:

- object storage for new files
- metadata artifacts for new table version state
- catalog for publication of current state

That is why write behavior is tied closely to the catalog and commit model.

## 4. Typical Spark Write Shapes

Common write shapes include:

- append
- overwrite with explicit scope
- merge-like update flows through supported engines and APIs
- maintenance rewrites such as compaction

These are not equivalent operationally.

Append is usually the easiest.

Mutation-heavy flows require much stronger understanding of commit semantics and engine support.

## 5. Why Spark Is Often The Primary Iceberg Engine

Spark is often chosen as the primary writer because it combines:

- large-scale batch compute
- rich SQL and DataFrame APIs
- mature integration patterns with catalogs and object storage
- support for maintenance workflows

This is one reason many platforms treat Spark as the default authoring engine even when other engines consume the table.

## 6. Spark Strength With Iceberg

Spark is strong for Iceberg because it can handle:

- large batch writes
- transformations before commit
- metadata-aware planning
- maintenance and rewrite jobs

## 7. Spark Limits And Reality

Spark is not magic.

You still need to reason about:

- partition choices
- file sizing
- commit conflicts
- maintenance windows
- engine compatibility if other readers or writers exist

## 8. Architect Summary

Spark does not make Iceberg simple.

It makes Iceberg practical.

But the platform still succeeds or fails based on:

- metadata health
- catalog clarity
- write discipline
- maintenance ownership