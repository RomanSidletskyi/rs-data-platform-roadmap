# 03 Python CI Pipeline

## Task 1 — Python Validation Workflow

### Goal

Create a practical Python CI workflow for a small project.

### Input

A Python repository with `requirements.txt` and tests.

### Requirements

- checkout code
- set up Python
- install dependencies
- run tests

### Expected Output

A narrow PR validation workflow for Python code.

### Extra Challenge

Add a linting step before tests.

## Task 2 — Fail Fast On Dependency Problems

### Goal

Make dependency installation an explicit step boundary.

### Requirements

- keep install and test as separate steps
- explain why mixing them into one large shell line weakens debugging

### Expected Output

A cleaner CI job structure.

## Task 3 — Cache Python Dependencies

### Goal

Speed up repeated runs safely.

### Requirements

- use built-in pip caching with `actions/setup-python`
- keep dependency source explicit

### Expected Output

A workflow with faster repeated runs and visible dependency ownership.