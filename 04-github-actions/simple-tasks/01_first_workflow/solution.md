# 01 First Workflow — Solution

## Task 1 — First Manual Workflow

```yaml
name: First workflow

on:
  workflow_dispatch:

jobs:
  hello:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Workflow started successfully"
```

## Task 2 — Pull Request Check

```yaml
name: PR sanity check

on:
  pull_request:
    branches: [main]
  workflow_dispatch:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "PR validation for ${{ github.head_ref || github.ref_name }}"
```

## Notes

- the workflow stays intentionally narrow
- `workflow_dispatch` is useful for safe manual reruns