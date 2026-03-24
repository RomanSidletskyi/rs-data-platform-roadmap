# 02 Functions And Modules - Solution

This file gives reference patterns for turning repeated script logic into reusable helpers.

## Pattern 1 - Reusable Cleaning Function

```python
def clean_name(value: str | None) -> str | None:
    if value is None:
        return None

    cleaned = " ".join(value.strip().split()).lower()
    return cleaned or None
```

## Pattern 2 - Safe Type Conversion

```python
def safe_to_int(value: str, default: int | None = None) -> int | None:
    try:
        return int(value)
    except (TypeError, ValueError):
        return default
```

## Pattern 3 - Required Field Validation

```python
def get_missing_fields(record: dict, required_fields: list[str]) -> list[str]:
    return [field for field in required_fields if field not in record or record[field] in (None, "")]
```

## Pattern 4 - Timestamped Filename Helper

```python
from datetime import datetime


def build_timestamped_filename(prefix: str, extension: str) -> str:
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return f"{prefix}_{timestamp}.{extension}"
```

## Pattern 5 - Split Script Into Modules

Good shape:

```text
src/
  main.py
  reader.py
  processor.py
  writer.py
```

Example entrypoint:

```python
from reader import load_json
from processor import transform_records
from writer import write_json


def main() -> None:
    records = load_json("data/raw/users.json")
    processed = transform_records(records)
    write_json("data/processed/users.json", processed)


if __name__ == "__main__":
    main()
```

## Pattern 6 - Small Logging Or Timing Decorator

```python
from functools import wraps
import time


def log_duration(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        started_at = time.perf_counter()
        result = func(*args, **kwargs)
        duration = time.perf_counter() - started_at
        print(f"{func.__name__} finished in {duration:.3f}s")
        return result

    return wrapper
```

Why this is a good example:

- it adds cross-cutting behavior
- it does not hide core business logic

## Pattern 7 - Small Closure

```python
def build_status_normalizer(default_status: str):
    def normalize(value: str | None) -> str:
        if value is None:
            return default_status
        cleaned = value.strip().lower()
        return cleaned or default_status

    return normalize
```

Why this is useful:

- one small configurable behavior
- less ceremony than introducing a class

## Pattern 8 - A Class Where Shared State Is Real

```python
class ApiClient:
    def __init__(self, base_url: str, token: str, timeout: int = 30) -> None:
        self.base_url = base_url
        self.token = token
        self.timeout = timeout

    def build_headers(self) -> dict[str, str]:
        return {"Authorization": f"Bearer {self.token}"}
```

Why this class makes sense:

- base URL, token, and timeout are shared state
- multiple related methods can reuse that state

## Pattern 9 - A Function Where State Is Not Needed

```python
def normalize_email(email: str) -> str:
    return email.strip().lower()
```

Why this should stay a function:

- it is pure and stateless
- turning it into a class adds no value

## Pattern 10 - `*args` And `**kwargs` In Wrappers

```python
def call_with_logging(func, *args, **kwargs):
    print(f"Calling {func.__name__} with args={args} kwargs={kwargs}")
    return func(*args, **kwargs)
```

Why this matters:

- wrappers and decorators often do not know the exact target signature in advance
- `*args` and `**kwargs` let them forward arguments safely

## Pattern 11 - A Small Data Contract With `TypedDict`

```python
from typing import TypedDict


class UserRecord(TypedDict):
    id: int
    name: str
    email: str


def normalize_user(record: UserRecord) -> UserRecord:
    return {
        "id": record["id"],
        "name": record["name"].strip(),
        "email": record["email"].strip().lower(),
    }
```

Why this helps:

- expected keys become explicit
- function boundaries become easier to reason about

## Key Point

The important outcome of this topic is not “I can define a function.”

It is:

- I can isolate repeated logic
- I can build helpers with one responsibility
- I can keep the entrypoint thin
- I can tell when a function is enough and when a class or decorator is justified
- I can use `*args`, `**kwargs`, and small data contracts intentionally rather than mechanically