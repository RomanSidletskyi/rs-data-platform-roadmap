# Commits, Concurrency, And Row-Level Changes

## 1. Commit Model

Iceberg typically uses optimistic concurrency.

That means a writer:

1. reads current table state
2. plans new metadata and file changes
3. attempts to publish a new metadata root
4. succeeds only if the expected base state is still valid

This avoids lock-heavy table behavior in many common cases.

## 2. Why The Metadata Pointer Matters

The real commit is not “write one parquet file.”

The real commit is:

- publish a new metadata pointer that defines the next valid table state

That is why catalog behavior is crucial.

The catalog is often the place where the current table version becomes official.

## 3. Concurrency Reality

Optimistic concurrency is powerful, but it is not free.

At scale, teams must still handle:

- commit retries
- conflicting writers
- long-running plans based on stale table state
- maintenance jobs interacting with data writers

If teams ignore these, Iceberg becomes “transactional” only in presentation, not in operations.

## 4. Row-Level Changes

Iceberg can represent row-level change behavior through data files and delete files.

The important architect distinction is:

- physical storage operations are still file-oriented
- row-level semantics are represented through metadata and delete logic

That means row-level updates are not the same thing as updating one row in an OLTP database page.

## 5. Why Deletes And Updates Are Harder Than Append

Append is easiest because it adds new table state.

Updates and deletes are harder because the engine must:

- track changed row sets
- publish consistent new metadata
- ensure readers interpret delete semantics correctly

This is one reason engine compatibility matters a lot more for mutation-heavy workloads than for append-only tables.

## 6. Architect Rule

If the business workload is highly mutation-heavy and low-latency transactional behavior is required, do not pretend Iceberg behaves like an OLTP system.

It is a strong analytical table format, not a replacement for transactional application databases.