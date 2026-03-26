# 06 Environments, Security, And Deploys

## Task 1 — Protected Deploy Job

### Goal

Design a deploy workflow that uses GitHub environments intentionally.

### Requirements

- define a deploy job
- attach it to an environment such as `prod`
- require prior validation job success

### Expected Output

A workflow shape that supports protected deployment.

## Task 2 — Secret Ownership

### Goal

Explain which values should be secrets and which should be variables.

### Requirements

- classify at least five example values
- justify each classification

### Expected Output

A short decision table.

## Task 3 — Debugging Failure Case

### Goal

Reason about a failed deploy workflow.

### Input

A deploy job fails after image publish but before runtime update.

### Requirements

- explain what should be inspected first
- explain why artifact traceability matters
- explain why one giant deploy step is harder to recover from

### Expected Output

A short incident-analysis note.