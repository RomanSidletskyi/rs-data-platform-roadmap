# Practical Python Libraries For Data Work

## Why This File Exists

The first two cookbook files focus mostly on the Python standard library and core language tools.

That is the correct starting point.

But real data engineering work also depends on a small set of external libraries that save time, reduce boilerplate, and make code safer.

This file explains:

- which libraries are worth learning early
- why they matter
- when not to use them
- small examples of where they fit

## First Rule: Do Not Reach For A Library Too Early

Beginners often make one of two mistakes:

- they try to solve everything with the standard library even when the code becomes clumsy
- they install many libraries before understanding the underlying problem

The right habit is:

1. understand the responsibility first
2. know the standard-library baseline
3. adopt an external library when it clearly improves readability, safety, or productivity

## 1. `requests`

### Why It Is Worth Knowing

`requests` is the most common entry-level HTTP library in Python.

It is worth learning because it makes API work far simpler than building on low-level HTTP tooling.

Good for:

- REST API calls
- auth headers
- query params
- JSON request and response handling
- small and medium ingestion scripts

### Why Not Always Enough

`requests` is synchronous.

That is often fine, but it is not the best fit for async-heavy workloads.

### Example

```python
import requests


response = requests.get(
    "https://api.example.com/users",
    headers={"Authorization": f"Bearer {token}"},
    params={"page": 1, "limit": 100},
    timeout=30,
)
response.raise_for_status()
records = response.json()
```

## 2. `httpx`

### Why It Is Worth Knowing

`httpx` is a strong modern alternative to `requests`.

It is worth learning because it supports both sync and async usage with a similar API style.

Good for:

- teams that want one HTTP client style for both sync and async code
- async API ingestion
- cleaner transition from simple scripts to more advanced clients

### Example

```python
import httpx


with httpx.Client(timeout=30.0, headers={"Authorization": f"Bearer {token}"}) as client:
    response = client.get("https://api.example.com/users", params={"limit": 100})
    response.raise_for_status()
    records = response.json()
```

## 3. `aiohttp`

### Why It Is Worth Knowing

`aiohttp` is useful when the learner starts doing real async HTTP work.

Good for:

- concurrent API calls
- async ingestion scripts
- controlled concurrency with semaphores

### Example

```python
import aiohttp
import asyncio


async def fetch_users(url: str, token: str) -> list[dict]:
    async with aiohttp.ClientSession(
        headers={"Authorization": f"Bearer {token}"}
    ) as session:
        async with session.get(url, timeout=30) as response:
            response.raise_for_status()
            return await response.json()


records = asyncio.run(fetch_users("https://api.example.com/users", token))
```

## 4. `pydantic`

### Why It Is Worth Knowing

`pydantic` is valuable because it brings explicit schema validation into Python code.

This becomes very useful when raw JSON payloads are messy or when contracts matter.

Good for:

- validating API payloads
- coercing and checking types
- documenting expected schemas in code
- making failure points clearer

### Example

```python
from pydantic import BaseModel, EmailStr


class UserRecord(BaseModel):
    id: int
    name: str
    email: EmailStr


validated = UserRecord.model_validate({
    "id": 1,
    "name": "Alice",
    "email": "alice@example.com",
})
```

### When Not To Use It

Do not force `pydantic` into every tiny script.

For very small exercises, direct validation functions may still be better for learning.

## 5. `pandas`

### Why It Is Worth Knowing

`pandas` is still one of the most practical libraries for small and medium data manipulation tasks.

Good for:

- CSV exploration
- quick profiling
- column transforms
- deduplication
- local prototypes before warehouse or Spark work

### Example

```python
import pandas as pd


df = pd.read_csv("data/raw/orders.csv")
df["email"] = df["email"].str.strip().str.lower()
df = df.drop_duplicates(subset=["order_id"])
df.to_csv("data/processed/orders.csv", index=False)
```

### Important Caution

`pandas` is powerful, but beginners should not confuse it with a distributed engine.

It works in memory.

## 6. `pyarrow`

### Why It Is Worth Knowing

`pyarrow` matters because modern data platforms often use parquet and Arrow-based data interchange.

Good for:

- writing parquet files
- working with columnar data formats
- interfacing with modern analytics ecosystems

### Example

```python
import pandas as pd


df = pd.read_csv("data/raw/orders.csv")
df.to_parquet("data/processed/orders.parquet", index=False)
```

In many setups, `pandas` will use `pyarrow` under the hood for parquet support.

## 7. `tenacity`

### Why It Is Worth Knowing

Retry logic becomes ugly very quickly when handwritten repeatedly.

`tenacity` is useful because it makes retries explicit and reusable.

Good for:

- retrying flaky API calls
- backoff strategies
- clearer retry intent in ingestion code

### Example

```python
from tenacity import retry, stop_after_attempt, wait_exponential
import requests


@retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=1, max=10))
def fetch_users(url: str) -> list[dict]:
    response = requests.get(url, timeout=30)
    response.raise_for_status()
    return response.json()
```

## 8. `typer`

### Why It Is Worth Knowing

`typer` is excellent for turning scripts into clean command-line tools.

Good for:

- ingestion jobs with parameters
- developer-friendly CLI tooling
- reproducible local execution

### Example

```python
import typer


app = typer.Typer()


@app.command()
def run(input_path: str, output_path: str) -> None:
    print(f"Processing {input_path} -> {output_path}")


if __name__ == "__main__":
    app()
```

## 9. `PyYAML`

### Why It Is Worth Knowing

Many data projects keep configuration in YAML.

`PyYAML` is useful for:

- pipeline config files
- environment-specific settings
- readable structured configuration

### Example

```python
import yaml
from pathlib import Path


config = yaml.safe_load(Path("config/config.yaml").read_text(encoding="utf-8"))
timeout = config["api"]["timeout"]
```

## 10. `python-dotenv`

### Why It Is Worth Knowing

This library helps local development by loading environment variables from a `.env` file.

Good for:

- local tokens
- local configuration
- simpler onboarding for small projects

### Example

```python
from dotenv import load_dotenv
import os


load_dotenv()
token = os.environ["API_TOKEN"]
```

## 11. `pytest`

### Why It Is Worth Knowing

`pytest` is worth learning early because it makes testing much easier and cleaner than manual checks.

Good for:

- unit tests for validators and processors
- parameterized test cases
- readable failure output

### Example

```python
from src.processor import normalize_email


def test_normalize_email_trims_and_lowercases() -> None:
    assert normalize_email("  Alice@Example.COM  ") == "alice@example.com"
```

## A Practical Early Stack

For this roadmap, a very practical early stack is:

- standard library first
- `requests` for sync API ingestion
- `httpx` or `aiohttp` when async becomes necessary
- `pydantic` when schema validation starts hurting
- `pandas` for small and medium local tabular work
- `pyarrow` when parquet enters the picture
- `tenacity` for retry logic
- `typer` for CLI structure
- `PyYAML` and `python-dotenv` for configuration
- `pytest` for tests

## Final Takeaway

Libraries are worth using when they remove repetitive boilerplate, make contracts clearer, or reduce operational risk.

The right question is not "what library is popular?"

The right question is "what responsibility do I have, and does this library make that responsibility safer or clearer?"
