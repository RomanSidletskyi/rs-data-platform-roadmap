# Workflow Syntax, Contexts, And Expressions

## 1. Why Syntax Feels Hard

GitHub Actions syntax feels harder than normal YAML because it is not only structure.

It is also:

- a trigger definition language
- a graph control language
- a value interpolation system
- a bridge between GitHub metadata and shell execution

If you mix those layers mentally, workflows become confusing fast.

## 2. The Core Skeleton Of A Workflow

Most workflows have the same top-level shape:

```yaml
name: Example workflow

on:
  pull_request:
    branches: [main]

jobs:
  example-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "hello"
```

The important keys are:

- `name`: human-readable workflow name
- `on`: trigger definition
- `jobs`: execution graph

Inside each job, common keys are:

- `runs-on`
- `needs`
- `if`
- `strategy`
- `env`
- `steps`

## 3. Trigger Syntax With `on`

`on` defines what starts the workflow.

Examples:

```yaml
on:
  workflow_dispatch:
```

```yaml
on:
  push:
    branches: [main, develop]
```

```yaml
on:
  pull_request:
    branches: [main]
```

Architecturally, this is where you express intent.

Do not start with syntax.

Start with the question:

What event should own this automation?

## 4. Job-Level Keys

Inside a job, you usually decide:

- where it runs: `runs-on`
- whether it should run: `if`
- whether it depends on other jobs: `needs`
- whether it should expand into variants: `strategy.matrix`

Example:

```yaml
jobs:
  test:
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.10', '3.11']
```

## 5. Contexts: Where Values Come From

Contexts are structured sources of values exposed by GitHub Actions.

Common contexts:

- `github`
- `env`
- `vars`
- `secrets`
- `matrix`
- `job`
- `runner`

Examples:

- `github.ref_name`
- `github.event_name`
- `matrix.python-version`
- `vars.DEPLOY_REGION`
- `secrets.REGISTRY_PASSWORD`

The architectural rule is simple:

always know who owns the value you are reading.

## 6. Expressions

Expressions are written inside `${{ ... }}`.

They are evaluated by the GitHub Actions engine.

Examples:

```yaml
if: github.ref == 'refs/heads/main'
```

```yaml
python-version: ${{ matrix.python-version }}
```

```yaml
run: echo "Branch is ${{ github.ref_name }}"
```

Expressions are not shell syntax.

That is one of the most important beginner boundaries.

## 7. GitHub Expressions Versus Shell Variables

This distinction causes many failures.

GitHub expression:

```yaml
run: echo "${{ github.ref_name }}"
```

Shell variable:

```yaml
run: echo "$HOME"
```

These are evaluated by different systems.

- `${{ ... }}` is resolved by GitHub Actions before or during workflow processing
- `$HOME` is resolved by the shell running inside the step

Confusing these layers causes brittle workflows.

## 8. `if` Conditions

Use `if` to make workflow intent visible.

Good examples:

- run deploy only on `main`
- run release only on tags
- run extra checks only for production branch or environment

Bad use:

- complex unreadable logic spread across many places
- conditions so dense that no one can predict behavior safely

## 9. Matrix Strategy

Matrix strategy expands one job definition into several executions.

Example:

```yaml
strategy:
  matrix:
    python-version: ['3.10', '3.11', '3.12']
```

This is useful when you want the same validation across several environments or versions.

But use it for real coverage, not for decorative complexity.

## 10. `uses` Versus `run`

Use `uses` when you are calling an action.

Use `run` when you are executing commands directly in the runner shell.

This matters because actions create reusable capability while `run` is typically repository-specific behavior.

## 11. Readability Rules For Beginners

Prefer these habits:

- short conditions
- descriptive job names
- explicit step names when the command is not obvious
- small expressions instead of nested logic
- stable value sources

Avoid these habits:

- many hidden environment overrides
- huge shell scripts embedded inline
- unclear interpolation between GitHub and shell layers

## 12. A Healthy Example

```yaml
name: Python validation

on:
  pull_request:
    branches: [main]

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
      - name: Install dependencies
        run: pip install -r requirements.txt
      - name: Run tests
        run: pytest
```

Why this works:

- trigger is explicit
- matrix purpose is clear
- context usage is narrow and readable
- step boundaries are visible

## 13. Key Takeaway

Workflow syntax is not only YAML formatting. It is the language GitHub Actions uses to express triggers, graph flow, context resolution, and execution-time decisions.