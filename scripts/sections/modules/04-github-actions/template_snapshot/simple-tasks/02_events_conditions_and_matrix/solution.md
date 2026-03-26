# 02 Events, Conditions, And Matrix — Solution

## Task 1 — Branch-Scoped Workflow

```yaml
on:
  push:
    branches: [main, develop]

jobs:
  branch-check:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Branch is ${{ github.ref_name }}"
      - if: github.ref == 'refs/heads/main'
        run: echo "Main-only step"
```

## Task 2 — Conditional Job Execution

```yaml
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - run: echo "always validate"

  only-main-pr:
    if: github.event.pull_request.base.ref == 'main'
    runs-on: ubuntu-latest
    needs: validate
    steps:
      - run: echo "extra checks for main-bound PR"
```

## Task 3 — Matrix Testing

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.10', '3.11']
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - run: python --version
```