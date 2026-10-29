# 05 Branching Retention And Governance

## Overview

These tasks focus on the control-plane side of Iceberg operations:

- snapshot references
- branching and tagging
- retention choices
- governance boundaries

The goal is to understand when historical state is part of the platform contract and when it is just temporary operational support.

---

## Task 1 - Choose Branch Versus Tag

### Goal

Pick the right snapshot reference.

### Input

Scenario A:

- keep a fixed reference to the state used for quarter-close reporting

Scenario B:

- run isolated validation writes before publishing to main

### Requirements

- choose branch or tag for each scenario
- explain the difference in mutability model

### Expected Output

- two decisions
- one comparison paragraph

### Extra Challenge

Explain why a tag is not a good substitute for an active development branch.

---

## Task 2 - Set A Retention Policy By Use Case

### Goal

Assign retention windows deliberately.

### Input

Tables:

- raw event table used mainly for replay debugging
- curated finance table used for audits
- temporary experimentation table

### Requirements

- propose a different retention posture for each table
- explain why one-size-fits-all retention is weak

### Expected Output

- three retention decisions
- one short rationale paragraph

### Extra Challenge

Explain why aggressive retention on the wrong table can remove valuable debugging or audit state.

---

## Task 3 - Choose A Safer Governance Boundary

### Goal

Define ownership boundaries.

### Input

Scenario:

- platform team owns Glue catalog and S3 layout
- domain team owns curated orders table logic

### Requirements

- explain which team should own catalog-level guardrails
- explain which team should own table-level business contract
- explain why mixing those responsibilities creates confusion

### Expected Output

- one short ownership split

### Extra Challenge

Explain one case where platform team should block a domain request even if the domain team owns the table logic.

---

## Task 4 - Decide Whether A Snapshot Reference Should Be Permanent

### Goal

Evaluate the lifecycle of a reference.

### Input

Scenario:

- data science team wants a branch for a two-week experiment

### Requirements

- explain whether this should be a long-lived permanent branch
- explain one operational risk of leaving many old references behind

### Expected Output

- one lifecycle decision
- one risk explanation

### Extra Challenge

Explain how stale references can interfere with cleanup expectations.

---

## Task 5 - Protect An Audit Snapshot

### Goal

Design a safe freeze point.

### Input

Scenario:

- finance needs a reproducible quarter-close table state

### Requirements

- propose one reference strategy
- explain how it relates to retention and reproducibility

### Expected Output

- one short design answer

### Extra Challenge

Explain why “we can just hope time travel still has it later” is not a strong audit strategy.

---

## Task 6 - Explain Why Governance Is Not Only SQL Access

### Goal

Describe the control-plane idea.

### Input

Topics to cover:

- catalog ownership
- namespace boundaries
- retention policy
- allowed write patterns

### Requirements

- explain why governance is broader than query permissions
- connect at least 3 of the listed topics into one short architecture explanation

### Expected Output

- one short explanation paragraph

### Extra Challenge

Explain why an open table format still needs strong platform control.