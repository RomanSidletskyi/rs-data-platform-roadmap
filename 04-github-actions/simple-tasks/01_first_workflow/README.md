# 01 First Workflow

## Task 1 — First Manual Workflow

### Goal

Create the smallest useful GitHub Actions workflow.

### Input

A repository with one `README.md` file.

### Requirements

- trigger on `workflow_dispatch`
- run on `ubuntu-latest`
- checkout the repository
- print a short confirmation message

### Expected Output

A workflow YAML that can be run manually from GitHub.

### Extra Challenge

Add the current branch name to the output using the `github` context.

## Task 2 — Pull Request Check

### Goal

Turn the first workflow into a pull-request quality gate.

### Input

A repo where changes should be validated before merge.

### Requirements

- trigger on `pull_request`
- limit to `main`
- keep the job narrow and validation-oriented

### Expected Output

A small PR workflow that is safe to run frequently.

### Extra Challenge

Also allow `workflow_dispatch` so the same workflow can be rerun manually.