# 08 Data Engineering Python Tasks - Solution

This file gives reference patterns for the most important engineering habits in the module.

The point is not only to clean data.

The point is to shape a small workflow that behaves more like a pipeline component.

## Pattern 1 - Mini ETL Shape

```python
from pathlib import Path
import json


def clean_user(record: dict) -> dict:
    return {
        "id": record["id"],
        "name": record["name"].strip(),
        "email": record["email"].strip().lower(),
    }


raw_users = [
    {"id": 1, "name": " Alice ", "email": "alice@example.com"},
    {"id": 2, "name": "Bob", "email": "bob@example.com"},
]

processed_users = [clean_user(user) for user in raw_users]

Path("data/raw").mkdir(parents=True, exist_ok=True)
Path("data/processed").mkdir(parents=True, exist_ok=True)

Path("data/raw/users.json").write_text(
    json.dumps(raw_users, indent=2),
    encoding="utf-8",
)
Path("data/processed/users.json").write_text(
    json.dumps(processed_users, indent=2),
    encoding="utf-8",
)
```

Why this matters:

- raw and processed zones are already separated
- transformation logic is isolated in a helper

## Pattern 2 - Schema Validation And Quarantine

```python
required_fields = {"id", "name", "email"}
valid_records = []
invalid_records = []

for record in records:
    missing_fields = sorted(required_fields.difference(record.keys()))
    if missing_fields:
        invalid_records.append(
            {
                "record": record,
                "validation_reason": "missing_required_fields",
                "missing_fields": missing_fields,
            }
        )
    else:
        valid_records.append(record)
```

Why this matters:

- invalid records remain inspectable
- the pipeline explains why records were rejected

## Pattern 3 - Save Quarantine Output Explicitly

```python
from pathlib import Path
import json


quarantine_path = Path("data/quarantine/users_invalid.json")
quarantine_path.parent.mkdir(parents=True, exist_ok=True)
quarantine_path.write_text(json.dumps(invalid_records, indent=2), encoding="utf-8")
```

Why this matters:

- bad data is not silently lost

## Pattern 4 - Process Only New Files

```python
import json
from pathlib import Path


state_path = Path("state/processed_files.json")
state_path.parent.mkdir(parents=True, exist_ok=True)

if state_path.exists():
    processed_files = set(json.loads(state_path.read_text(encoding="utf-8")))
else:
    processed_files = set()

for file_path in sorted(Path("input").glob("*.json")):
    if file_path.name in processed_files:
        print(f"Skipping already processed file: {file_path.name}")
        continue

    # process file here
    processed_files.add(file_path.name)

state_path.write_text(json.dumps(sorted(processed_files), indent=2), encoding="utf-8")
```

Why this matters:

- incremental state is explicit
- reruns are safer

## Pattern 5 - Execution Metadata

```python
from datetime import datetime, timezone


run_summary = {
    "run_id": datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S"),
    "input_file_count": 3,
    "valid_records": len(valid_records),
    "invalid_records": len(invalid_records),
    "processed_output": "data/processed/users.json",
    "quarantine_output": "data/quarantine/users_invalid.json",
    "status": "success",
}
```

Why this matters:

- the run produces evidence, not only data

## Pattern 6 - Save A Run Report

```python
from pathlib import Path
import json


report_path = Path("reports/run_summary.json")
report_path.parent.mkdir(parents=True, exist_ok=True)
report_path.write_text(json.dumps(run_summary, indent=2), encoding="utf-8")
```

Why this matters:

- outputs and run metadata become easier to inspect later

## Pattern 7 - Idempotent Output Thinking

```python
output_path = Path("data/processed/users.json")
output_path.write_text(json.dumps(valid_records, indent=2), encoding="utf-8")
```

Why this can be idempotent:

- rerunning the same logical input rewrites the same target instead of blindly appending duplicates

## Pattern 8 - One Strong Reference Shape

The strongest baseline shape for this block is:

- raw preserved
- valid output written
- invalid output quarantined
- run metadata emitted
- incremental state tracked explicitly
- reruns made predictable

## Pattern 9 - Generator-Based Record Processing

```python
def iter_valid_records(records: list[dict]):
    for record in records:
        if record.get("id") is not None:
            yield record


def normalize_records(records):
    for record in records:
        yield {
            "id": record["id"],
            "email": record["email"].strip().lower(),
        }
```

Why this matters:

- validation and normalization can happen lazily
- not every intermediate step needs to build a full list immediately

## Pattern 10 - Typed Record Contracts

```python
from typing import TypedDict


class RawUserRecord(TypedDict, total=False):
    id: int
    name: str
    email: str


class ProcessedUserRecord(TypedDict):
    id: int
    email: str


def normalize_user(record: RawUserRecord) -> ProcessedUserRecord:
    return {
        "id": record["id"],
        "email": record["email"].strip().lower(),
    }
```

Why this matters:

- raw and processed layers stop looking like one vague "dict"
- pipeline contracts become easier to explain and test

## Key Point

This topic is where Python stops looking like exercises and starts looking like pipeline engineering.