# 04 Schema Partition And Compatibility

## Overview

These tasks focus on one of the biggest Iceberg advantages and one of its biggest risk areas:

- schema evolution
- partition evolution
- engine compatibility

The goal is not only to write `ALTER TABLE` statements.

The goal is to understand when an evolution is safe, when it changes the consumer contract, and when it creates cross-engine risk.

---

## Task 1 - Add A Column Without Breaking The Table Contract

### Goal

Propose a safe schema evolution.

### Input

Current table:

- `orders`

Need to add:

- `sales_channel STRING`

### Requirements

- write one `ALTER TABLE` statement
- explain why adding a nullable column is usually safer than changing an existing one
- explain one downstream compatibility question you would ask first

### Expected Output

- one schema change statement
- one short explanation

### Extra Challenge

Explain why field IDs matter more than column position in Iceberg evolution.

---

## Task 2 - Decide Whether A Rename Is Safe

### Goal

Evaluate a rename request.

### Input

Current column:

- `customer_tier`

Requested new name:

- `loyalty_tier`

### Requirements

- explain whether Iceberg metadata can represent the rename safely
- explain why the rename can still be risky operationally
- list 3 checks you would perform before approving it

### Expected Output

- one decision paragraph
- one 3-item check list

### Extra Challenge

Explain why renaming a column is different from changing the business meaning of the field.

---

## Task 3 - Change Partition Strategy For A Growing Table

### Goal

Choose a better partition spec.

### Input

Current table:

- partitioned only by `days(order_ts)`

New workload:

- frequent filtering by `status`
- table volume growing rapidly

### Requirements

- propose one new partition strategy
- explain why this is partition evolution rather than a full table rebuild
- explain what happens to older files after the spec changes

### Expected Output

- one partition decision
- one short explanation

### Extra Challenge

Explain why changing partition spec does not mean old files are instantly rewritten.

---

## Task 4 - Choose A Safer Consumer Contract

### Goal

Pick the safer evolution strategy.

### Input

Scenario A:

- add a nullable descriptive column

Scenario B:

- change `amount` from gross amount semantics to net amount semantics but keep the same column name

### Requirements

- identify which scenario is the real contract risk
- explain why one is metadata-friendly but the other is consumer-hostile

### Expected Output

- one comparison paragraph

### Extra Challenge

Explain how you would publish Scenario B safely instead.

---

## Task 5 - Evaluate Cross-Engine Compatibility Risk

### Goal

Assess a change before rollout.

### Input

Table characteristics:

- `format-version = 2`
- Spark writes it
- Athena and another query engine read it
- team wants to introduce delete-heavy `MERGE`

### Requirements

- explain why engine compatibility must be checked before enabling the new workload
- list 3 concrete compatibility questions

### Expected Output

- one short explanation
- one 3-item question list

### Extra Challenge

Explain why “it is all Iceberg, so every engine will behave the same” is a weak assumption.

---

## Task 6 - Decide When To Avoid Evolution Altogether

### Goal

Choose between evolving a table and publishing a new contract.

### Input

Scenario:

- curated finance table is widely consumed
- business wants to redefine several core metrics and dimensions at once

### Requirements

- choose either evolve the existing table or publish a new versioned table
- justify the choice in 4 to 6 bullets

### Expected Output

- one decision
- one short justification

### Extra Challenge

Explain why technical schema evolution and semantic contract evolution are not the same thing.