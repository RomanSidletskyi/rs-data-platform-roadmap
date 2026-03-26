# 03 Python CI Pipeline — Solution

## Reference Workflow

```yaml
name: Python CI

on:
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
          cache: 'pip'

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Lint
        run: python -m py_compile src/*.py

      - name: Run tests
        run: pytest
```

## Why This Shape Is Better

- install, lint, and test are separate failure boundaries
- cache is for dependency speed-up, not for business outputs
- the workflow remains a validation pipeline, not a deploy pipeline