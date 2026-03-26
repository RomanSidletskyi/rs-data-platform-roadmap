# Functions, Modules, And Project Boundaries

## Why This Topic Matters

Most beginner Python code works by putting everything into one file and letting the script grow.

That is normal at the start, but it stops scaling almost immediately.

In data engineering, even a small workflow usually needs several kinds of logic:

- network access
- parsing
- validation
- transformation
- writing outputs
- logging and run summaries

If all of that lives in one place, the code becomes fragile. The first maintainability layer is boundary design.

In Python, that usually starts with:

- functions
- modules
- folders

## Continue Using The Canonical Pipeline

Use the same mini-pipeline as in the previous file:

`API -> raw JSON snapshot -> validation -> normalized records -> processed CSV -> run summary`

This helps the learner see that boundaries are not abstract style rules. They exist because each stage of the pipeline needs a different responsibility.

## Functions: The First Useful Boundary

A good function usually answers one small question or performs one clear action.

Examples:

- fetch records from an API
- validate one input record
- normalize one record
- build a dated output path
- write rows to CSV

### Good Function Design Usually Means

- one responsibility
- clear inputs
- clear return value
- little or no hidden global state
- a name that explains intent

### Weak Function Design Usually Means

- one function does five unrelated things
- the return value is inconsistent
- file paths and URLs are hard-coded inside helper functions
- the function silently mutates shared state

## Example: Too Much In One Function

```python
def run_pipeline() -> None:
	response = requests.get("https://example.com/users", timeout=30)
	response.raise_for_status()
	records = response.json()

	Path("data/raw").mkdir(parents=True, exist_ok=True)
	Path("data/raw/users.json").write_text(json.dumps(records), encoding="utf-8")

	clean_rows = []
	for record in records:
		if record.get("id") is None:
			continue
		clean_rows.append(
			{
				"id": record["id"],
				"name": record["name"].strip(),
				"email": record["email"].strip().lower(),
			}
		)

	with Path("data/processed/users.csv").open("w", newline="", encoding="utf-8") as file:
		writer = csv.DictWriter(file, fieldnames=["id", "name", "email"])
		writer.writeheader()
		writer.writerows(clean_rows)
```

This code is not terrible because it is short.

It is weak because all responsibilities are fused together.

## Example: Better Functional Split

```python
def fetch_users(base_url: str, timeout: int) -> list[dict]:
	response = requests.get(f"{base_url}/users", timeout=timeout)
	response.raise_for_status()
	return response.json()


def validate_user(record: dict) -> None:
	required_fields = ["id", "name", "email"]
	missing = [field for field in required_fields if record.get(field) in (None, "")]
	if missing:
		raise ValueError(f"Missing required fields: {missing}")


def normalize_user(record: dict) -> dict:
	return {
		"id": record["id"],
		"name": record["name"].strip(),
		"email": record["email"].strip().lower(),
	}
```

Now the responsibilities are visible.

Each function is easier to test and easier to reason about.

## Modules: The Next Boundary

Once functions start to separate responsibilities, modules can group related functions.

For a small ingestion project, a common split is:

- `main.py` or `cli.py`: coordinates the run
- `api_client.py`: handles HTTP requests
- `validator.py`: checks record quality
- `processor.py`: transforms records
- `writer.py`: writes files
- `config_loader.py`: reads config

This module split is useful because it mirrors runtime responsibilities.

## Example Project Shape

```text
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
```

This is already a meaningful step from toy scripts toward a maintainable project.

## The Thin Entrypoint Pattern

The main entrypoint should usually stay thin.

Its job is to coordinate, not to contain all business logic.

Example:

```python
def main() -> None:
	config = load_config("config/config.yaml")
	records = fetch_users(config["base_url"], config["timeout"])
	save_raw_snapshot(records, config["raw_output_path"])

	normalized_records = []
	for record in records:
		validate_user(record)
		normalized_records.append(normalize_user(record))

	write_csv(normalized_records, config["processed_output_path"])
```

This is a good pattern because the flow is easy to read top to bottom.

## Why Thin Entrypoints Matter

If `main.py` contains everything, several problems appear:

- testing requires running the full script
- logic cannot be reused
- small changes create larger regressions
- the file turns into an unstructured blob

Thin entrypoints make orchestration visible and keep detailed logic elsewhere.

## Project Boundaries Versus Function Boundaries

These are related, but not identical.

Function boundaries decide how one local responsibility is isolated.

Project boundaries decide where entire categories of responsibility belong.

Examples:

- validation logic belongs in validation-related code, not inside CSV writing helpers
- raw data belongs in `data/raw`, not mixed into source code folders
- config belongs in config files or environment variables, not scattered hard-coded values

## Good Project Boundary Habits

- keep source code in `src/`
- keep tests in `tests/`
- keep configuration outside business logic
- separate raw data from processed data
- keep example data small and explicit

## Boundary Mistakes Beginners Make

### 1. Global State Everywhere

```python
BASE_URL = "https://example.com"
OUTPUT_FILE = "users.csv"
TIMEOUT = 30
```

Small constants are fine, but when everything depends on global settings, testing and reuse get harder.

### 2. Hidden File Paths

If functions write to fixed file paths without receiving them as arguments, the caller loses control.

### 3. Validation Inside Writers

Writers should usually write.

If a writer silently cleans or filters bad rows, the data flow becomes harder to trust.

### 4. Processor Talks Directly To The Network

The transformation layer should usually receive records, not perform HTTP calls itself.

That keeps transformation logic easier to test and reuse.

## Pure Functions Are Especially Valuable

In data work, pure functions are powerful because they are easy to test.

Example:

```python
def normalize_email(email: str) -> str:
	return email.strip().lower()
```

This function does not touch files, network, or global state.

It is easy to test with a few assertions.

The more transformation logic you keep this simple, the easier the whole project becomes.

## Side-Effect Functions Still Matter

Not all useful functions are pure.

These are still necessary:

- `fetch_users()`
- `read_json_file()`
- `write_csv()`
- `save_raw_snapshot()`

The goal is not to eliminate side effects.

The goal is to isolate them.

## Where Tests Usually Start

The easiest early tests usually target:

- validators
- processors
- small helper functions

Those are the parts where clear function and module boundaries pay off first.

## How This Prepares The Learner For Bigger Systems

These ideas scale directly into later tools:

- in Spark, transformations and I/O still need boundaries
- in Airflow, orchestration is explicit at DAG level
- in dbt, model boundaries replace some code boundaries
- in larger Python services, module contracts become even more important

The names change, but the design logic stays the same.

## Final Takeaway

Functions, modules, and project boundaries are not just style preferences.

They are the first real maintainability system in Python.

If the learner can split a mini-pipeline into clear responsibilities, they are already building code that behaves more like engineering and less like a temporary script.