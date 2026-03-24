# Simple Tasks: ADLS Cookbook

## Task 1: Container And Path Decision

A team is onboarding a new dataset.

Explain how you would decide whether it belongs in:

- a new storage account
- a new container
- a new top-level path

## Task 2: Security Boundary Decision

A Databricks job needs write access to one raw subtree and analysts need read access to one publish subtree.

Explain the healthy access design.

## Task 3: Publish Path Decision

A dashboard currently reads from a temporary curated folder.

Explain why that is weak and what a stronger published storage boundary looks like.

## Task 4: Cost And Cleanup Decision

A lake contains old raw history, duplicated curated outputs, and leftover backfill paths.

Explain how you would review cleanup decisions without breaking replay or consumers.

## Task 5: Edge Case Cookbook Decision

A dashboard reads from `curated/sales/orders_working/`, analysts have broad read access, and the team plans to delete older raw paths to save money.

Describe the main architectural problems in this situation.

Then explain the order in which you would fix them.
