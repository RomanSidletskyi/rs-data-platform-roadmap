# Simple Tasks: Namespace Layout And Storage Modeling

## Task 1: Container Versus Path

A team wants a new dataset boundary.

Explain how you would decide between:

- new storage account
- new container
- new top-level path

## Task 2: Ownership And Dataset Grain

Explain why a well-named path is still weak if ownership and dataset grain are unclear.

## Task 3: Naming And Environment Isolation

Describe a healthy naming pattern for an ADLS path for curated orders data.

Then explain one weak naming pattern and why it creates future debt.

## Task 4: Path Stability And File Layout

Explain why path stability and file behavior should be considered together rather than as separate topics.

## Task 5: Edge Case Namespace Review

A team stores official dashboard data in `curated/analytics/final_orders/latest/` because the path already exists and is easy to find.

Explain what is weak in this design.

Then explain what a stronger path strategy would make explicit.
