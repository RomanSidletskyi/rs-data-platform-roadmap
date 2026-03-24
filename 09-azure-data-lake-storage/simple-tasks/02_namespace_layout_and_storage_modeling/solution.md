# Solutions: Namespace Layout And Storage Modeling

## Task 1

Use a new storage account only for stronger isolation requirements such as networking, compliance, region, or administrative separation.

Use a new container when you need a clear large-scale boundary for access, lifecycle, or platform management.

Use a new top-level path when the dataset belongs inside an existing broad boundary but still needs its own stable namespace.

## Task 2

If ownership is unclear, nobody can safely approve schema change, retention, replay, or publish behavior.

If dataset grain is unclear, the path may mix several contracts into one location and become hard to govern.

## Task 3

A healthy pattern might be `curated/sales/orders/v1/order_date=2025-01-15/` under an environment-specific boundary.

A weak pattern is something vague like `data/final/new_orders_latest/` because it hides ownership, semantic stability, and lifecycle expectations.

## Task 4

Stable paths support reliable consumers.

Healthy file layout supports efficient operation.

If the path is stable but files are chaotic, the dataset is still operationally weak.

## Task 5

The path is weak because it mixes informal naming like `final` and `latest` with a consumer-facing use case while still living in a curated internal area.

A stronger strategy would make ownership, publish intent, dataset meaning, and stability explicit through a deliberate publish boundary.
