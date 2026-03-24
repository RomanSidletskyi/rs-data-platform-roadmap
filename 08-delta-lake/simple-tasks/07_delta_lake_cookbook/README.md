# Simple Tasks: Delta Lake Cookbook

## Task 1: Merge Recipe

Write a short checklist for deciding whether a table really needs `MERGE`.

## Task 2: Partitioning Recipe

You are publishing a fast-growing table mainly filtered by `order_date` and sometimes by `store_id`.

List the main questions you should ask before locking in partitioning.

## Task 3: Repair Recipe

A table has one bad version and two possible fixes: restore or bounded rewrite.

List the main checks you would do before choosing.

## Task 4: Schema Evolution Recipe

A new upstream column appears in silver.

List the main checks you would do before allowing it to flow further downstream.
