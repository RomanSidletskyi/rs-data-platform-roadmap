# Recommended Stack By Project Size

## Why This File Exists

Beginners often ask for the “right stack”, but there is no single answer without context.

The right stack depends on the size and maturity of the project.

This file shows how a practical Python stack can evolve through three stages:

1. single script
2. small pipeline project
3. growing project with stronger reliability needs

The goal is not to prescribe one perfect stack.

The goal is to show when each tool becomes justified.

## Stage 1: Single Script

### Typical Situation

At this stage, the learner is building one script that does one clear job.

Examples:

- fetch one API endpoint and save JSON
- clean one CSV file
- normalize one local dataset

### Recommended Stack

- Python standard library
- `venv`
- `requests` if HTTP is needed

### Why This Stack Is Enough

At this stage, simplicity matters more than architecture depth.

The learner should understand:

- inputs
- outputs
- paths
- validation basics
- clear function boundaries

Too many dependencies this early often hide the fundamentals.

### Typical Tools By Responsibility

- files and paths: `pathlib`, `json`, `csv`
- timestamps: `datetime`
- simple counters and grouping: `collections`
- HTTP: `requests`

### Example Shape

```text
project/
  main.py
  data/
    raw/
    processed/
  requirements.txt
```

### Example Use Case

```python
import requests
from pathlib import Path
import json


response = requests.get("https://api.example.com/users", timeout=30)
response.raise_for_status()

Path("data/raw").mkdir(parents=True, exist_ok=True)
Path("data/raw/users.json").write_text(
    json.dumps(response.json(), indent=2),
    encoding="utf-8",
)
```

### Main Risk At This Stage

The biggest risk is not missing a fancy library.

The biggest risk is letting one script become a messy blob.

## Stage 2: Small Pipeline Project

### Typical Situation

At this stage, the learner has more than one responsibility.

Examples:

- ingest API data
- validate rows
- normalize into CSV or parquet
- write a run summary
- add basic tests

Now the project is no longer “just one script”.

### Recommended Stack

- Python standard library
- `venv`
- `requests` or `httpx`
- `pytest`
- `PyYAML` or environment variables for config
- `python-dotenv` for local developer convenience
- `pandas` when tabular transformation starts to dominate

### Why These Tools Enter Here

At this stage, the codebase has enough moving parts that a few strong dependencies reduce friction significantly.

Examples:

- `pytest` makes testing realistic
- `PyYAML` keeps configuration readable
- `python-dotenv` simplifies local setup
- `pandas` can replace repetitive column-cleaning code

### Example Shape

```text
project/
  src/
    main.py
    api_client.py
    validator.py
    processor.py
    writer.py
    config_loader.py
  tests/
    test_processor.py
    test_validator.py
  config/
    config.yaml
  data/
    raw/
    processed/
    quarantine/
  requirements.txt
```

### Example Decision Logic

- stay with stdlib CSV helpers if output is simple and deterministic
- bring in `pandas` if many column operations are appearing
- stay with plain validation functions if rules are still small
- bring in `pydantic` when schema validation becomes repetitive or fragile

### Main Risk At This Stage

The biggest risk is under-structuring the project.

The project has already outgrown one-file thinking, but the codebase may still be pretending it is a tiny script.

## Stage 3: Growing Project

### Typical Situation

At this stage, the project is still not a huge platform component, but it clearly has operational weight.

Examples:

- multiple endpoints or multiple source files
- retry policies
- schema validation
- timestamped outputs
- CLI parameters
- better observability
- async HTTP needs in some cases

### Recommended Stack

- Python standard library
- `httpx` or `aiohttp` for more advanced HTTP needs
- `pytest`
- `pydantic`
- `tenacity`
- `typer`
- `PyYAML`
- `python-dotenv`
- `pandas`
- `pyarrow`

### Why These Tools Enter Here

At this stage, reliability and maintainability start mattering more than minimalism.

Examples:

- `pydantic` gives clearer schemas and validation errors
- `tenacity` makes retries reusable and explicit
- `typer` makes CLI entrypoints cleaner
- `pyarrow` becomes important when parquet is part of the workflow
- `httpx` or `aiohttp` helps when HTTP usage is more advanced

### Example Shape

```text
project/
  src/
    cli.py
    api_client.py
    models.py
    validator.py
    processor.py
    writer.py
    state_manager.py
    config_loader.py
    logging_setup.py
  tests/
    test_api_client.py
    test_processor.py
    test_validator.py
    test_state_manager.py
  config/
    config.yaml
  data/
    raw/
    processed/
    quarantine/
    state/
  requirements.txt
```

### Example Upgrade Triggers

Use this stage when you notice problems like:

- retry code repeated in several places
- schema assumptions breaking often
- CLI arguments becoming messy
- parquet now matters
- testing API code is painful

### Main Risk At This Stage

The biggest risk is adding tools without clarifying ownership.

Even good libraries become noise if responsibilities between modules are still unclear.

## What Not To Do

Do not jump directly to the stage 3 stack for every tiny exercise.

That usually causes two problems:

- the learner memorizes tools instead of responsibilities
- the project becomes dependency-heavy before the design is stable

Also do not stay forever in stage 1 once the project clearly outgrew it.

That leads to:

- weak tests
- hidden config
- repeated boilerplate
- poor project boundaries

## A Simple Upgrade Rule

Upgrade the stack when one of these becomes true:

- a responsibility is repeating often
- the stdlib solution is getting noisy
- the project has multiple modules and clear runtime stages
- tests, retries, validation, or config are now real concerns

If none of these are true, the simpler stack is usually better.

## Suggested Default For This Roadmap

For this roadmap, a strong default progression is:

1. learn stage 1 well
2. build most `01-python` practice work around stage 1 and early stage 2
3. introduce stage 3 only when the learner already feels the pain that those libraries solve

That way the tools feel earned, not arbitrary.

## Final Takeaway

The right Python stack is not chosen once.

It grows with the project.

Good engineers keep the stack as small as possible, but not smaller than the real responsibilities of the project.