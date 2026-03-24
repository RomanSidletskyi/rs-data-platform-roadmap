# Functions, Exceptions, Files, Pathlib, And Datetime Cookbook

## Why This File Exists

The first cookbook file makes the learner comfortable with the most common Python data structures.

This second cookbook covers the next set of building blocks that appear in real scripts almost immediately:

- functions
- exceptions
- file handling
- `pathlib`
- `datetime`
- list and generator patterns that appear in everyday pipeline code

The goal is to reduce friction before the learner reaches heavier ingestion, validation, and orchestration topics.

## 1. Functions

### What Good Functions Usually Do

Good Python functions usually have one clear responsibility.

Examples:

- normalize one record
- load one file
- validate one row
- build one output path

### Important Function Parameters

#### Positional Parameters

```python
def build_output_name(prefix: str, extension: str) -> str:
    return f"{prefix}.{extension}"
```

#### Default Values

```python
def normalize_status(value: str, default: str = "unknown") -> str:
    cleaned = value.strip().lower()
    return cleaned or default
```

#### Keyword Arguments

```python
def fetch_with_timeout(url: str, timeout: int = 30, retries: int = 3) -> dict | list:
    ...


fetch_with_timeout(url="https://example.com", timeout=10, retries=5)
```

#### `*args` And `**kwargs`

These appear often in Python code, especially in wrappers, decorators, and flexible helper APIs.

`*args` collects extra positional arguments.

`**kwargs` collects extra keyword arguments.

Example:

```python
def log_values(*args, **kwargs) -> None:
    print("args:", args)
    print("kwargs:", kwargs)


log_values(1, 2, 3, source="api", status="ok")
```

Why this matters:

- decorators often need `*args, **kwargs` so they can wrap many function signatures safely
- some utility functions use them for flexible forwarding of parameters

Important caution:

- do not use `*args` and `**kwargs` everywhere by default
- explicit parameters are usually clearer when the function interface is stable

### Return Shapes That Matter In Real Work

#### Return One Value

```python
def normalize_email(email: str) -> str:
    return email.strip().lower()
```

#### Return Multiple Related Values

```python
def split_valid_and_invalid(records: list[dict]) -> tuple[list[dict], list[dict]]:
    valid_records = []
    invalid_records = []

    for record in records:
        if record.get("id") is None:
            invalid_records.append(record)
        else:
            valid_records.append(record)

    return valid_records, invalid_records
```

#### Return Metadata With Data

```python
def summarize_records(records: list[dict]) -> dict:
    return {
        "record_count": len(records),
        "has_null_amounts": any(record.get("amount") is None for record in records),
    }
```

## 2. Exceptions

### Common Exception Types

```python
try:
    Path("missing.json").read_text(encoding="utf-8")
except FileNotFoundError:
    print("Input file is missing")
```

```python
try:
    int("abc")
except ValueError:
    print("Could not convert value to int")
```

```python
record = {"id": 1}
try:
    print(record["email"])
except KeyError:
    print("Missing required key: email")
```

### Raise Your Own Error Intentionally

```python
def validate_record(record: dict) -> None:
    if record.get("id") is None:
        raise ValueError("Record must contain id")
```

### Custom Exception Example

```python
class ValidationError(Exception):
    pass


def require_fields(record: dict, required_fields: list[str]) -> None:
    missing = [field for field in required_fields if record.get(field) in (None, "")]
    if missing:
        raise ValidationError(f"Missing required fields: {missing}")
```

## 3. Files And `pathlib`

### Create Paths

```python
from pathlib import Path


raw_dir = Path("data/raw")
processed_dir = Path("data/processed")
input_file = raw_dir / "users.json"
```

### Create Directories

```python
processed_dir.mkdir(parents=True, exist_ok=True)
```

### Read And Write Text Files

```python
content = input_file.read_text(encoding="utf-8")

output_file = processed_dir / "summary.txt"
output_file.write_text("run completed", encoding="utf-8")
```

### Find Files

```python
for file_path in Path("data/raw").glob("*.json"):
    print(file_path.name)
```

## 4. JSON And CSV Helpers

```python
import json


with Path("data/raw/users.json").open("r", encoding="utf-8") as file:
    records = json.load(file)
```

```python
import csv


rows = [
    {"id": 1, "name": "Alice"},
    {"id": 2, "name": "Bob"},
]

with Path("data/processed/users.csv").open("w", encoding="utf-8", newline="") as file:
    writer = csv.DictWriter(file, fieldnames=["id", "name"])
    writer.writeheader()
    writer.writerows(rows)
```

## 5. Datetime

```python
from datetime import datetime, timezone, timedelta


now_utc = datetime.now(timezone.utc)
timestamp = now_utc.strftime("%Y%m%d_%H%M%S")
retry_time = now_utc + timedelta(minutes=5)
```

## 6. Comprehensions And Generator Expressions

```python
emails = [record["email"].strip().lower() for record in records if record.get("email")]
```

```python
users_by_id = {record["id"]: record for record in records if record.get("id") is not None}
```

```python
unique_statuses = {record.get("status", "unknown") for record in records}
```

```python
has_null_amount = any(record.get("amount") is None for record in records)
```

## 7. Useful Standard Library Helpers

```python
from collections import Counter


event_counts = Counter(record["event_type"] for record in records)
```

```python
from collections import defaultdict


amounts_by_status: defaultdict[str, list[int]] = defaultdict(list)
for record in records:
    amounts_by_status[record["status"]].append(record["amount"])
```

## 8. Real Mini Pipeline Example

```python
from datetime import datetime, timezone
from pathlib import Path
import json


def load_records(file_path: Path) -> list[dict]:
    with file_path.open("r", encoding="utf-8") as file:
        return json.load(file)


def normalize_records(records: list[dict]) -> list[dict]:
    normalized = []
    for record in records:
        if record.get("id") is None:
            raise ValueError("Missing id in record")
        normalized.append(
            {
                "id": record["id"],
                "email": record.get("email", "").strip().lower(),
            }
        )
    return normalized


def build_output_path(output_dir: Path) -> Path:
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
    return output_dir / f"users_{timestamp}.json"
```

## Final Takeaway

The standard library and small Python helpers are already enough to build credible mini-pipelines.

The key is not knowing every function by heart.

The key is recognizing which tool matches which responsibility.