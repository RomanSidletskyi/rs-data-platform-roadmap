# Python Runtime And Data Flow

## Why This Topic Matters

Many people first meet Python through tiny exercises:

- print something
- loop through a list
- write an `if`
- call a function

That is necessary, but it is not enough for data engineering.

In real work, Python is not just a language for small instructions. It is the runtime glue between systems, files, records, validation rules, logging, and outputs.

If the learner does not understand runtime flow, they often build scripts that technically work once but are hard to rerun, test, debug, or extend.

## The Main Mental Model

For this module, use one canonical mini-pipeline:

`API -> raw JSON snapshot -> validation -> normalized records -> processed CSV -> run summary`

That single example is enough to explain most of the runtime ideas that appear again later in SQL, Spark, Airflow, dbt, and full data-platform projects.

## What Runtime Means In Practice

When a Python script runs, it usually moves through a sequence like this:

1. load configuration
2. initialize paths, clients, or sessions
3. request or read input data
4. validate that the input has the expected structure
5. transform records into a better shape
6. write outputs
7. record metadata about the run

That sequence is the runtime story of the script.

The code is not just a list of statements. It is a controlled movement of data and decisions through a pipeline.

## A Concrete Example

Imagine an ingestion script that downloads users from an HTTP API.

The runtime flow might be:

1. read `config.yaml`
2. call `GET /users`
3. save the raw response to `data/raw/users_20250101_090000.json`
4. parse the JSON body
5. reject records with missing required fields
6. normalize names and emails
7. write `data/processed/users.csv`
8. write `data/processed/run_summary.json`

This is much closer to real engineering than a random isolated syntax exercise.

## Data Flow Is More Important Than Syntax Memorization

Beginners often focus on remembering syntax details.

In practice, the more important questions are:

- where does data enter the script
- what assumptions are made about shape and types
- where is validation performed
- where are records transformed
- what gets written as raw output versus processed output
- what evidence exists for debugging the run later

If these answers are unclear, the script may still run, but it is weak engineering.

## Runtime Layers In A Simple Pipeline

The same mini-pipeline can be divided into layers.

### 1. Configuration Layer

This decides how the run behaves.

Examples:

- base URL
- timeout
- output directory
- required fields
- whether to overwrite existing outputs

### 2. Input Layer

This is where data enters the workflow.

Examples:

- API response
- JSON file
- CSV export
- command-line arguments
- environment variables

### 3. Validation Layer

This checks whether the input is safe enough to use.

Examples:

- required keys exist
- numeric fields are actually numeric
- timestamps can be parsed
- records are not empty

### 4. Transformation Layer

This converts input shape into output shape.

Examples:

- rename columns
- standardize case
- cast types
- flatten nested JSON
- derive new fields

### 5. Output Layer

This writes the results.

Examples:

- raw snapshot
- processed CSV
- quarantine file for bad rows
- summary metadata

### 6. Observability Layer

This explains what happened during the run.

Examples:

- logs
- counts
- output paths
- error messages
- timestamps

## Good Runtime Design

Good runtime design makes the flow visible.

That usually means:

- input stage is obvious
- transformation code is separate from file and network side effects
- validation rules are explicit
- outputs are predictable
- run metadata is easy to inspect

## Bad Runtime Design

Bad runtime design hides the flow in a single giant block.

Typical symptoms:

- API calls, parsing, validation, and writing all happen inside one long function
- records are modified in place many times with no clear contract
- output file names are hard-coded in random places
- error handling is inconsistent
- there is no record of what the script processed

## Why This Becomes A Problem Fast

If a script is hard to reason about, several problems appear quickly:

- reruns can overwrite useful data accidentally
- debugging becomes slow because no raw evidence was saved
- tests become difficult because business logic is mixed with side effects
- future contributors cannot tell which step is responsible for a bug

## Example: A Weak Version

```python
import requests
import csv


response = requests.get("https://example.com/users")
records = response.json()

with open("users.csv", "w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["id", "name", "email"])
    for record in records:
        writer.writerow([
            record["id"],
            record["name"].strip(),
            record["email"].lower(),
        ])
```

This works for a demo, but almost every engineering concern is hidden:

- no timeout
- no raw snapshot
- no validation
- no logging
- no separation between network, transformation, and output logic

## Example: A Better Runtime Shape

```python
from pathlib import Path
import csv
import json
import requests


def fetch_users(url: str, timeout: int) -> list[dict]:
    response = requests.get(url, timeout=timeout)
    response.raise_for_status()
    return response.json()


def save_raw_snapshot(records: list[dict], output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(records, indent=2), encoding="utf-8")


def normalize_user(record: dict) -> dict:
    return {
        "id": record["id"],
        "name": record["name"].strip(),
        "email": record["email"].strip().lower(),
    }


def write_csv(records: list[dict], output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=["id", "name", "email"])
        writer.writeheader()
        writer.writerows(records)
```

This version is still small, but the runtime responsibilities are already clearer.

## Data Shape Should Be Explicit

Every step should make the record shape more obvious.

For example:

- raw API record might contain 20 fields
- validated record might guarantee `id`, `name`, and `email`
- processed CSV row might only keep 3 fields in the right order

That progression is the essence of controlled data flow.

## Pure Logic Versus Side Effects

One of the most useful runtime distinctions is this:

- pure logic transforms data
- side effects touch the outside world

Pure logic examples:

- trim whitespace
- lowercase emails
- map status codes
- flatten JSON fields

Side effects examples:

- send an HTTP request
- read a file
- write a CSV
- log to stdout or a file

When these are separated, testing becomes much easier.

## Why Raw Snapshots Matter

In data engineering, raw snapshots are often worth the storage cost.

If a downstream transformation looks wrong, the raw snapshot helps answer:

- was the API wrong
- was the parser wrong
- was the normalization wrong
- did the schema change unexpectedly

Without a raw snapshot, you are often debugging from memory.

## Why Run Summaries Matter

Even small scripts benefit from a summary artifact.

A run summary might contain:

- start time
- end time
- source URL
- raw record count
- valid record count
- invalid record count
- output file paths

This is a simple bridge from beginner scripting to real observability.

## The Beginner Mistake To Avoid

The common beginner mistake is to think the script is the same thing as the transformation logic.

It is not.

The script is the coordinator.
The transformation logic is only one part of the runtime story.

## Connection To Later Modules

This topic prepares the learner for later ideas:

- SQL transformations as controlled data flow
- Airflow DAGs as runtime orchestration
- Spark jobs as distributed transformation flow
- dbt models as explicit transformation layers

The core pattern does not disappear.
Only the scale and tooling change.

## Final Takeaway

Python runtime thinking starts when the learner sees a script as a sequence of visible stages with clear boundaries.

If the learner can explain:

- where data entered
- how it was validated
- how it was transformed
- what was written
- what evidence the run produced

then they are already thinking more like a data engineer than a syntax-only beginner.