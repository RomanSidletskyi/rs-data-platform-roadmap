# 07 Maintenance Cost And Cleanup

## Overview

These tasks focus on the ongoing operating model of an Iceberg table after the first writes are already working.

The main goal is not only to know that maintenance exists.

The main goal is to reason about:

- rewrite pressure
- snapshot retention
- metadata growth
- cost control
- cleanup boundaries

---

## Task 1 - Decide When To Run Compaction

### Goal

Choose a reasonable trigger for data-file rewrite.

### Input

Scenario:

- micro-batch writes every 5 minutes
- query latency is rising
- many files are under 16 MB

### Requirements

- explain why compaction is needed
- propose one scheduling approach
- explain why every-write compaction is a weak operating model

### Expected Output

- one short operations note

### Extra Challenge

Explain why compaction policy should depend on workload shape rather than one universal cron.

---

## Task 2 - Choose A Snapshot Expiration Posture

### Goal

Set a basic retention approach.

### Input

Scenario:

- table is mutated daily
- debugging often needs recent history
- storage cost is being reviewed

### Requirements

- propose one reasonable snapshot-expiration posture
- explain the trade-off between cost and recoverability

### Expected Output

- one short retention answer

### Extra Challenge

Explain why expiring aggressively immediately after each mutation can be risky.

---

## Task 3 - Separate Business Delete From Maintenance Cleanup

### Goal

Explain two different meanings of deletion.

### Input

Scenario:

- rows are logically deleted by daily CDC merges
- obsolete snapshots and files are accumulating

### Requirements

- explain the difference between row-level delete semantics and physical cleanup
- name one maintenance action for cleanup

### Expected Output

- one short explanation

### Extra Challenge

Explain why a table can be logically correct but still operationally unhealthy.

---

## Task 4 - Diagnose Metadata Growth Cost

### Goal

Recognize a metadata-heavy cost pattern.

### Input

Scenario:

- manifest counts are growing quickly
- planning time is increasing
- business row volume is not growing at the same rate

### Requirements

- identify the likely problem pattern
- explain why cost is not only about object storage bytes

### Expected Output

- one diagnosis paragraph

### Extra Challenge

Explain why metadata growth can increase operational debugging cost too.

---

## Task 5 - Choose A Safer Cleanup Boundary

### Goal

Avoid over-cleaning.

### Input

Scenario:

- experimentation branch exists
- quarter-close tag exists
- main table also has routine snapshot cleanup

### Requirements

- explain why cleanup policy must account for references beyond main
- explain one risk of ignoring those references

### Expected Output

- one short governance explanation

### Extra Challenge

Explain why cleanup is a control-plane concern, not only a storage concern.

---

## Task 6 - Design A Minimal Maintenance Plan

### Goal

Write a small maintenance plan for a production table.

### Input

Table:

- `analytics.orders_curated`

Conditions:

- daily merges
- weekly spikes in user queries
- moderate need for rollback/debugging history

### Requirements

- propose one rewrite action cadence
- propose one snapshot-retention posture
- add one monitoring idea

### Expected Output

- one 3-part maintenance plan

### Extra Challenge

Explain why maintenance should be designed together with SLAs and cost targets.