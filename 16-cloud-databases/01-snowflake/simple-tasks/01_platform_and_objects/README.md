# Task Set 01: Platform and Objects

These account-free exercises check the first Snowflake mental models. Write your assumptions before consulting `solution.md`.

## Task 1: Trace a Query

For a user who selects `ANALYTICS.CURATED.ORDERS` with role `ANALYST` and warehouse `BI_WH`, explain which parts control identity, authorization, compute, namespace, and durable storage.

## Task 2: Choose a Table Type

Choose permanent, transient, or temporary for (a) a durable curated dimension, (b) a rebuildable intermediate stage, and (c) a one-session debugging result. State the recovery consequence of each choice.

## Task 3: Make Context Explicit

Write the session setup statements needed to query `PROD_DB.REPORTING.DAILY_SALES` using role `BI_READER` and warehouse `BI_WH`. Explain why fully qualifying the object can still be useful.

## Task 4: Diagnose a Missing-Access Error

A user can see a database but cannot query one view. List the namespace and object privileges, active role, and ownership or policy details you would verify.

## Task 5: Boundary Sketch

Draw a simple environment layout for one development team and one production team. Label account, database, schema, role, and warehouse boundaries. Name one risk your design does not eliminate.