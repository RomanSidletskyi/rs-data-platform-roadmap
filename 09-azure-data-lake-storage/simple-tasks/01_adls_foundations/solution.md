# Solutions: ADLS Foundations

## Task 1

ADLS Gen2 is a cloud storage service optimized for analytical data workloads and directory-style navigation.

It is not the compute engine, not the orchestration layer, not the catalog, and not the full platform architecture.

## Task 2

Hierarchical namespace improves directory operations, path organization, and analytics-oriented access patterns.

It does not solve ownership, schema quality, governance, lineage, or consumer contracts.

## Task 3

The storage account is the broad administrative and security boundary.

The container or file system is a major storage boundary used for separation and management.

The path expresses domain, dataset, zone, version, and partition decisions.

The file is the physical output unit shaped by write patterns and compaction behavior.

## Task 4

A platform can still be weak if paths are unclear, ownership is mixed, retention is inconsistent, and consumers depend on unstable locations.

Good storage does not remove the need for architecture discipline.

## Task 5

Moving files into ADLS improves the storage layer, but it does not automatically solve ownership, data contracts, schema governance, orchestration, observability, lineage, or consumer-boundary design.

The weak assumption is treating better storage as if it were the whole platform.
