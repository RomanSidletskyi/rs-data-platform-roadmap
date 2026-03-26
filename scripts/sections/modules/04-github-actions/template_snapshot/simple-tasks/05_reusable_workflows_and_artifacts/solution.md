# 05 Reusable Workflows And Artifacts — Solution

## Artifact Example

```yaml
jobs:
  build-report:
    runs-on: ubuntu-latest
    steps:
      - run: echo '{"status":"ok"}' > report.json
      - uses: actions/upload-artifact@v4
        with:
          name: report
          path: report.json

  consume-report:
    needs: build-report
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: report
      - run: cat report.json
```

## Reusable Workflow Decision

Use a reusable workflow when the whole job graph repeats.

Example:

- checkout
- setup Python
- install deps
- lint
- test

That is larger than a step bundle and has job-level meaning.

## Composite Action Decision

Use a composite action for a small repeated step package.

Example:

- prepare Docker tags
- write metadata file
- normalize environment values