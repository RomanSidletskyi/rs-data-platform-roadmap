# OOP Patterns For Data Engineering

## Why This File Exists

Object-oriented programming in Python is often misunderstood in data work.

Some people avoid classes too aggressively.
Others build class hierarchies everywhere because they think that feels more professional.

The practical question is simpler:

- which object patterns are actually useful in data engineering code

This file focuses on patterns that tend to pay off in real Python workflows.

## Pattern 1: API Client Object

This is one of the best class use cases in Python data engineering.

Why it works:

- the client has shared state
- base URL, token, timeout, and session belong together
- multiple related methods can reuse that state

Example:

```python
import requests


class OrdersApiClient:
    def __init__(self, base_url: str, token: str, timeout: int = 30) -> None:
        self.base_url = base_url
        self.timeout = timeout
        self.session = requests.Session()
        self.session.headers.update({"Authorization": f"Bearer {token}"})

    def fetch_orders(self, page: int = 1) -> list[dict]:
        response = self.session.get(
            f"{self.base_url}/orders",
            params={"page": page},
            timeout=self.timeout,
        )
        response.raise_for_status()
        return response.json()
```

## Pattern 2: Config Object

When config becomes more structured, a small config object can be clearer than passing loose dictionaries around.

Example:

```python
from dataclasses import dataclass


@dataclass
class ApiConfig:
    base_url: str
    timeout: int
    page_size: int
```

Why useful:

- related settings stay grouped
- type hints become clearer

## Pattern 3: State Tracker Object

This is another very practical pattern.

Good for:

- incremental file processing
- remembering processed partitions
- storing checkpoint-like metadata

Example:

```python
import json
from pathlib import Path


class ProcessedFilesState:
    def __init__(self, state_path: Path) -> None:
        self.state_path = state_path

    def load(self) -> set[str]:
        if not self.state_path.exists():
            return set()
        return set(json.loads(self.state_path.read_text(encoding="utf-8")))

    def save(self, processed_files: set[str]) -> None:
        self.state_path.parent.mkdir(parents=True, exist_ok=True)
        self.state_path.write_text(
            json.dumps(sorted(processed_files), indent=2),
            encoding="utf-8",
        )
```

## Pattern 4: Service Object That Coordinates One Responsibility

A service object can be useful when one responsibility has multiple steps and shared collaborators.

Example:

```python
class UsersIngestionService:
    def __init__(self, api_client, writer, validator) -> None:
        self.api_client = api_client
        self.writer = writer
        self.validator = validator

    def run(self) -> None:
        records = self.api_client.fetch_users()
        valid_records = [record for record in records if self.validator.is_valid(record)]
        self.writer.write(valid_records)
```

Why it can work:

- one service coordinates one workflow
- collaborators remain explicit

Important caution:

- do not turn service objects into giant “god classes”

## Pattern 5: Data Models

Small models can be useful when records need a clearer structure than plain dictionaries.

Example:

```python
from dataclasses import dataclass


@dataclass
class UserRecord:
    id: int
    name: str
    email: str
```

Why useful:

- clearer contracts
- easier typing and readability

## Pattern 6: Adapter Or Writer Object

This pattern is useful when multiple output targets may exist.

Example:

```python
class CsvWriter:
    def write(self, records: list[dict], output_path: str) -> None:
        ...


class JsonWriter:
    def write(self, records: list[dict], output_path: str) -> None:
        ...
```

Why it can help:

- output concerns are isolated
- behavior can be swapped more cleanly

## Pattern 7: Do Not Hide Pure Transformations In Classes Needlessly

This is one of the most important warnings.

Weak pattern:

```python
class UserTransformer:
    def normalize_email(self, email: str) -> str:
        return email.strip().lower()
```

Usually better:

```python
def normalize_email(email: str) -> str:
    return email.strip().lower()
```

Why:

- no object state is needed
- plain function is simpler

## Pattern 8: Prefer Composition Over Inheritance

For small and medium data projects, composition is usually safer than inheritance.

Prefer:

- one service object using one client and one writer

Over:

- deep base classes and subclasses for every variation

Why:

- inheritance becomes rigid quickly
- composition keeps responsibilities more explicit

## Pattern 9: Thin Entrypoint Still Matters

Even if classes are used, the entrypoint should remain thin.

Example:

```python
def main() -> None:
    api_client = OrdersApiClient(base_url, token)
    writer = CsvWriter()
    validator = OrderValidator()
    service = OrdersIngestionService(api_client, writer, validator)
    service.run()
```

Why:

- orchestration remains visible
- class usage does not erase the need for runtime clarity

## A Practical Default Pattern

For many early Python data projects, this hybrid structure is strong:

- class for API client
- class for state tracker
- maybe small config dataclass
- functions for validation and normalization
- thin main entrypoint

This usually gives better results than either extreme:

- everything in loose functions
- everything turned into classes

## External Sources For Deeper Reading

Useful resources:

- Python docs on classes and dataclasses
- Fluent Python by Luciano Ramalho
- Architecture Patterns with Python by Harry Percival and Bob Gregory
- Real Python articles on service objects, dataclasses, and composition in Python

Useful starting pages:

- https://docs.python.org/3/tutorial/classes.html
- https://docs.python.org/3/library/dataclasses.html

## Final Takeaway

The right OOP pattern in Python data engineering is usually small, explicit, and responsibility-driven.

If a class does not have meaningful state or a clear object responsibility, a plain function is usually better.