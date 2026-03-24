# 05 Reusable Workflows And Artifacts

## Task 1 — Artifact Hand-Off Between Jobs

### Goal

Pass a generated file from one job to another.

### Requirements

- generate a file in job 1
- upload it as an artifact
- download it in job 2

### Expected Output

A workflow with a traceable artifact boundary.

## Task 2 — Reusable Workflow Decision

### Goal

Decide when a repeated pattern should become a reusable workflow.

### Input

You have the same Python validation flow in multiple repositories.

### Requirements

- explain why a reusable workflow fits better than copy-paste
- explain why a composite action may be too small or too narrow for the full pattern

### Expected Output

A short architectural decision note.

## Task 3 — Composite Action Decision

### Goal

Decide when a repeated step bundle should become a composite action.

### Expected Output

A short note with one concrete example.