# 05 Error Handling And Logging - Solution

This file gives reference patterns for making small Python data scripts safer and easier to debug.

## Pattern 1 - Handle File Errors Clearly

```python
try:
    with open("missing_file.csv", encoding="utf-8") as file:
        content = file.read()
except FileNotFoundError:
    print("File not found: missing_file.csv")
except OSError as exc:
    print(f"Unexpected file error: {exc}")
```

## Pattern 2 - Basic Pipeline Logging

```python
import logging
from time import perf_counter


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

start_time = perf_counter()
logger.info("Pipeline started")

# pipeline work here

duration = perf_counter() - start_time
logger.info("Pipeline finished successfully in %.2f seconds", duration)
```

## Pattern 3 - Separate Invalid Records

```python
valid_records = []
invalid_records = []

for record in records:
    missing_fields = [field for field in ["id", "name", "email"] if field not in record]
    if missing_fields:
        invalid_records.append({"record": record, "missing_fields": missing_fields})
    else:
        valid_records.append(record)
```

## Pattern 4 - Retry Wrapper With Logging

```python
def retry(operation, retries: int = 3):
    for attempt in range(1, retries + 1):
        try:
            return operation()
        except Exception as exc:
            logger.warning("Attempt %s failed: %s", attempt, exc)
            if attempt == retries:
                raise
```

## Pattern 5 - Custom Validation Exception

```python
class ValidationError(Exception):
    pass


def validate_record(record: dict, required_fields: list[str]) -> None:
    missing_fields = [field for field in required_fields if field not in record]
    if missing_fields:
        raise ValidationError(f"Missing required fields: {missing_fields}")
```

## Key Point

The target habit here is not just catching exceptions.

It is making failures observable and understandable.