# Snapshots, Manifests, Sequence Numbers, And Specs

## 1. Snapshot

A snapshot represents a point-in-time version of the table.

Each snapshot identifies the file set that belongs to the table state at that moment.

This is the foundation of:

- time travel
- rollback reasoning
- consistent reads

It is useful to think of a snapshot as:

- the official statement of which logical table version is current at a given moment

## 2. Manifest List

A snapshot usually points to a manifest list.

The manifest list is the layer that groups manifest files for that snapshot.

Think of it as:

- the index of indexes for the snapshot

It lets an engine find the right manifests for one snapshot without mixing them with another snapshot.

## 3. Manifest File

A manifest file contains entries about data files or delete files.

It stores useful planning information such as:

- partition values
- file-level stats
- file status for the snapshot

This is why readers can prune work without touching every data file.

In practical terms, manifests are one of the main reasons Iceberg query planning can remain efficient even when the table has many data files.

## 4. Sequence Numbers

Sequence numbers help order table changes.

They matter because:

- row-level changes and delete semantics need ordering
- readers and writers need a consistent way to understand which changes are newer

Sequence numbers are part of why Iceberg can support more advanced change semantics than simple append-only file layouts.

They help engines reason about order of change application, especially when delete semantics and multiple write operations interact.

## 5. Schema, Partition Spec, And Sort Order

Iceberg separates important concerns that weak lake layouts often mix together.

### Schema

Schema defines columns and field identities.

The important detail is:

- Iceberg tracks fields by IDs, not only by names

That makes rename and evolution safer than naive file-based assumptions.

Architect takeaway:

- name changes are not automatically harmless in every engine, but field IDs are the reason Iceberg even has a chance to make them safer across engines

### Partition spec

Partition spec defines how values are transformed into partitioning logic.

Examples include:

- identity
- day
- month
- bucket
- truncate

The key idea is that partition logic is metadata, not only path convention.

This is why teams can evolve from one partition strategy to another over time instead of being trapped forever by one folder layout decision.

### Sort order

Sort order is separate from partitioning.

That means:

- you can optimize locality and scan behavior without pretending sort is the same thing as partitioning

## 6. Why Snapshots And Specs Together Matter

Snapshots alone are not enough.

Readers also need to understand which schema, partition spec, and sort assumptions were active for the table state they are reading.

That is one reason Iceberg metadata is layered and explicit.

It is not only file indexing.

It is interpretation logic for the table over time.

## 7. Why This Is Architecturally Important

This metadata model allows evolution over time.

You are not locking the table forever into:

- one schema shape
- one partition layout
- one interpretation of table history

That is one of the deepest reasons Iceberg exists.

## 8. Concrete Mental Model

When someone asks, "What is really inside Iceberg metadata?", a strong short answer is:

> Iceberg stores table versions as snapshots. Each snapshot points to a manifest list, which points to manifests, which point to concrete data and delete files. Around that, the table metadata tracks schemas by field IDs, partition specs, sort orders, snapshot history, and properties. That is what makes evolution, pruning, and multi-engine interpretation possible.