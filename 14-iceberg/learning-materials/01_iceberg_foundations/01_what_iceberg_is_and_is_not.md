# What Iceberg Is And Is Not

## 1. First Mental Model

Apache Iceberg is an open table format.

Its job is to turn a set of files in object storage into a table with stable metadata, snapshots, evolution rules, and transactional semantics.

The important distinction is:

- Parquet gives you files
- Iceberg gives you a table abstraction above files

That abstraction is what makes it possible for engines to agree on table state without guessing by scanning folders.

## 2. What Iceberg Gives You

Iceberg gives a table:

- snapshots
- schema evolution
- partition evolution
- explicit table metadata
- transactional commit semantics
- engine-independent metadata representation

This means readers do not need to infer state from directory structure alone.

They read metadata that says:

- which snapshot is current
- which manifests belong to that snapshot
- which data files are visible
- how the schema and partition spec should be interpreted

## 3. What Iceberg Is Not

Iceberg is not:

- a storage engine by itself
- a query engine
- a scheduler
- a governance strategy by itself
- a magical fix for bad data modeling

If a team has weak ownership, unstable schemas, random file layout, or no clear contracts, Iceberg does not remove those problems.

It only gives a better table layer above the files.

## 4. Why Teams Adopt It

Teams usually adopt Iceberg because plain file layouts become painful.

Common pain points are:

- schema changes breaking downstream readers
- partition directory conventions becoming brittle
- readers disagreeing on current table state
- overwrite operations being unsafe or hard to reason about
- multi-engine sharing becoming inconsistent

Iceberg is valuable when those are real platform problems, not only theoretical ones.

## 5. Architect View

At architect level, Iceberg is best understood as three layers:

1. data files in object storage
2. metadata files that define table state
3. a catalog that points engines to the current table metadata

That is why Iceberg design is not only about file format.

It is about metadata and control-plane ownership.