# Read Path, Write Path, And Planning

## 1. Read Path

An Iceberg read typically works like this:

1. resolve current table metadata through catalog
2. load current snapshot
3. load manifest list and relevant manifests
4. prune files using partition values and file-level stats
5. scan only the necessary data files

The key insight is that good planning happens before data scan begins.

## 2. Write Path

A write typically works like this:

1. read current table state
2. write new data files or delete files
3. prepare new manifests or manifest updates
4. prepare new snapshot and metadata references
5. atomically commit the new table state

So the write path is metadata-heavy, not only file-heavy.

## 3. Why Planning Quality Matters

Performance depends heavily on planning quality.

If metadata is healthy and file layout is good, readers can skip a lot of work.

If metadata is bloated or files are fragmented badly, planning becomes expensive and scans degrade.

## 4. Why Maintenance Exists

Iceberg tables need maintenance because over time they accumulate:

- too many small files
- too many manifests
- too much historical metadata
- delete-file complexity

This is not a bug.

It is a consequence of making table state explicit and versioned.

## 5. Architect View

Good Iceberg design is not only:

- can we create the table?

It is also:

- can the metadata and file layout stay healthy at production scale?