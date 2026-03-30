# 06 Troubleshooting And Failure Modes

## Overview

These tasks train the learner to debug Iceberg as a layered system.

The possible failure point may be in:

- catalog configuration
- metadata state
- object-store layout
- engine behavior
- maintenance neglect

The goal is not only to say that something is broken.

The goal is to localize which layer is most likely wrong.

---

## Task 1 - Debug Different Row Counts Across Two Engines

### Goal

Propose a first debugging path.

### Input

Scenario:

- Spark and another engine return different row counts for the same Iceberg table

### Requirements

- list the first 4 things you would compare
- explain why this is not automatically a storage corruption problem

### Expected Output

- one ordered debugging list
- one short explanation

### Extra Challenge

Explain why checking the current snapshot is usually more useful than checking random parquet files first.

---

## Task 2 - Diagnose A Small-File Problem

### Goal

Recognize the symptom pattern.

### Input

Scenario:

- table query latency is rising
- planning time is high
- many tiny files are produced by frequent micro-batches

### Requirements

- identify the likely problem
- propose one maintenance action
- explain why the issue is more than raw storage cost

### Expected Output

- one diagnosis
- one action
- one short explanation

### Extra Challenge

Explain why producing many tiny files can also stress manifests and planning metadata.

---

## Task 3 - Recognize A Commit-Conflict Scenario

### Goal

Explain a likely concurrency issue.

### Input

Scenario:

- two Spark jobs try to update the same table at nearly the same time
- one succeeds and one fails on commit

### Requirements

- explain the likely reason at metadata level
- explain why optimistic concurrency can reject one writer safely

### Expected Output

- one short explanation

### Extra Challenge

Explain why this failure can be a sign of correctness rather than platform weakness.

---

## Task 4 - Find The Most Likely Misconfiguration Layer

### Goal

Localize a setup issue.

### Input

Scenario:

- `CREATE TABLE` works in Spark
- reads fail in another engine

### Requirements

- name 3 likely layers to inspect
- explain why catalog configuration is a prime suspect

### Expected Output

- one 3-layer list
- one short explanation

### Extra Challenge

Explain why successful Spark writes do not prove all readers are configured correctly.

---

## Task 5 - Choose A Better Failure Analysis Question

### Goal

Replace a vague debugging habit.

### Input

Weak question:

- “why is Iceberg broken?”

### Requirements

- rewrite it into 3 stronger layer-specific questions
- make at least one question about metadata state and one about engine compatibility

### Expected Output

- three better questions

### Extra Challenge

Explain why layer-specific questions shorten debugging time.

---

## Task 6 - Plan A Minimal Incident Response

### Goal

Write a small response plan.

### Input

Scenario:

- delete-heavy table became slow after weeks without maintenance

### Requirements

- propose 3 immediate investigation or response steps
- include one metadata/inspection step and one maintenance step

### Expected Output

- one 3-step incident response

### Extra Challenge

Explain why jumping straight to full table rebuild is often a poor first move.