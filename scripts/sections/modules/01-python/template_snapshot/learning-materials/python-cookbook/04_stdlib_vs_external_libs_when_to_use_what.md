# Standard Library Vs External Libraries: When To Use What

## Why This File Exists

One of the most important practical skills in Python is knowing when the standard library is enough and when an external package is justified.

This matters because bad decisions appear in both directions:

- some beginners avoid external libraries even when the code becomes repetitive and fragile
- some beginners install many packages before they understand the actual problem

The goal is to make library choice intentional.

## Short Rule Of Thumb

Start with the standard library when:

- the task is small and clear
- the built-in solution is readable
- the responsibility is already solved well by Python itself
- adding a dependency would create more weight than value

Move to an external library when:

- boilerplate keeps repeating
- validation or retry logic becomes error-prone
- an established package is clearly the normal tool for the job
- the external package improves safety, readability, or interoperability

## Use The Standard Library First For These Areas

### Files And Paths

Use:

- `pathlib`
- `json`
- `csv`
- `gzip`
- `tempfile`

Why:

- these tools are already strong for small and medium scripts
- they teach core concepts clearly
- they avoid unnecessary dependencies early

Example:

```python
from pathlib import Path
import json


records = json.loads(Path("data/raw/users.json").read_text(encoding="utf-8"))
```

### Datetime And Simple Time Math

Use:

- `datetime`

Why:

- timestamps, formatting, and UTC handling are already covered well enough for early pipeline work

Example:

```python
from datetime import datetime, timezone


run_ts = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
```

### Basic Counters And Grouping Helpers

Use:

- `collections.Counter`
- `collections.defaultdict`

Why:

- fast, clear, already built in

## Reach For External Libraries In These Cases

### HTTP Work Beyond Tiny Demos

Prefer:

- `requests`
- `httpx`
- `aiohttp`

Why:

- HTTP is a major responsibility and external libraries make request building, auth, retries, sessions, and async work much cleaner than low-level alternatives

Do not use only stdlib `urllib` just because it is built in if the code becomes harder to read and maintain.

### Schema Validation That Starts Hurting

Prefer:

- `pydantic`

Why:

- once payload validation becomes repetitive, explicit models and strong error messages are worth the dependency

Example:

```python
from pydantic import BaseModel


class OrderRecord(BaseModel):
    id: int
    status: str
    amount: float
```

### Tabular Data Manipulation

Prefer:

- `pandas`

Why:

- for local CSV cleanup, deduplication, profiling, and reshaping, `pandas` is usually much more productive than hand-writing everything with `csv`

But keep the limit in mind:

- `pandas` is not a distributed engine

### Parquet And Columnar Formats

Prefer:

- `pyarrow`

Why:

- modern data platforms often depend on parquet and Arrow-compatible tooling

### Retry Logic Used More Than Once

Prefer:

- `tenacity`

Why:

- repeated manual retry code becomes noisy and inconsistent quickly

### Real Command-Line Interfaces

Prefer:

- `typer`

Why:

- CLI arguments, help text, and typed commands become much cleaner

### Environment Loading For Local Development

Prefer:

- `python-dotenv`

Why:

- small projects often benefit from easy local environment loading

## Comparison By Responsibility

### Reading JSON Files

Use stdlib first:

```python
import json
from pathlib import Path


records = json.loads(Path("data/raw/users.json").read_text(encoding="utf-8"))
```

Why no external library yet:

- built-in solution is already clear and strong

### Calling APIs

External library usually wins:

```python
import requests


response = requests.get("https://api.example.com/users", timeout=30)
response.raise_for_status()
records = response.json()
```

Why external library wins here:

- much better ergonomics for HTTP work

### CSV Cleanup

Stdlib can be enough for small deterministic exports:

```python
import csv


with open("users.csv", "w", newline="", encoding="utf-8") as file:
    writer = csv.DictWriter(file, fieldnames=["id", "email"])
    writer.writeheader()
    writer.writerows(rows)
```

But if transformation becomes column-heavy, `pandas` becomes the better choice:

```python
import pandas as pd


df = pd.read_csv("users.csv")
df["email"] = df["email"].str.strip().str.lower()
df.to_csv("users_clean.csv", index=False)
```

## Questions To Ask Before Adding A Dependency

Ask:

- what exact responsibility am I trying to solve
- is the stdlib solution still clear
- will this dependency reduce repeated boilerplate
- is this library common and stable enough for the task
- does the team or project already use it

If the answer is vague, adding the dependency may be premature.

## Questions To Ask Before Avoiding A Dependency

Ask:

- am I refusing the dependency only because “built-in feels purer”
- is my custom code now more complex than the popular library
- am I recreating functionality that the ecosystem already solved well

If yes, the external library may be the better engineering choice.

## Recommended Early Decision Pattern

For this roadmap, a practical pattern is:

1. learn the standard library baseline first
2. use external packages where the responsibility is already mature in the ecosystem
3. prefer a small number of strong dependencies over many shallow ones
4. keep the reason for each dependency explicit

## Final Takeaway

The best Python engineers are not the ones who avoid libraries or the ones who install everything.

They are the ones who can justify each dependency choice clearly.