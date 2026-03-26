# 02 Events, Conditions, And Matrix

## Task 1 — Branch-Scoped Workflow

### Goal

Run a workflow only for selected branches.

### Input

A repository with `main`, `develop`, and feature branches.

### Requirements

- trigger on `push`
- include only `main` and `develop`
- print which branch was used

### Expected Output

A workflow with branch filtering at the trigger layer.

### Extra Challenge

Add a step that runs only when the branch is `main`.

## Task 2 — Conditional Job Execution

### Goal

Run one job only when a pull request targets `main`.

### Requirements

- define two jobs
- keep one always-on validation job
- add a second job with `if:` logic

### Expected Output

A workflow that makes the graph boundary visible.

## Task 3 — Matrix Testing

### Goal

Test the same pipeline across multiple Python versions.

### Requirements

- use a strategy matrix
- include at least two Python versions
- pass the matrix value into `actions/setup-python`

### Expected Output

A workflow that expands into multiple test executions.