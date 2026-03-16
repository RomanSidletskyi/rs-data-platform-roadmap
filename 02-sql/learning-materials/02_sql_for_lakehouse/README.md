# 02 SQL for Lakehouse

This section focuses on SQL patterns specific to modern data platforms built on Delta Lake and Databricks-style architectures.

## Why This Matters

SQL in a lakehouse is not the same as SQL in OLTP systems.

Here SQL is used for:

- large-scale analytics
- file-backed transactional tables
- merge/upsert workflows
- schema evolution
- incremental pipelines
- historical snapshots

## Files

- delta_tables.md
- merge_operations.md
- partitioning.md
- time_travel.md
- schema_evolution.md
- optimization_patterns.md
- practice_queries.md
