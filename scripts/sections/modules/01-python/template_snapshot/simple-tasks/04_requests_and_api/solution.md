# 04 Requests And API Work - Solution

This file gives reference patterns for API-oriented Python tasks.

## Pattern 1 - Fetch And Save JSON

```python
import json
from pathlib import Path

import requests


url = "https://jsonplaceholder.typicode.com/users"
response = requests.get(url, timeout=30)
response.raise_for_status()
payload = response.json()

Path("data/raw").mkdir(parents=True, exist_ok=True)
Path("data/raw/users.json").write_text(json.dumps(payload, indent=2), encoding="utf-8")
```

## Pattern 2 - Keep Selected Fields

```python
selected = [
    {
        "id": record["id"],
        "name": record["name"],
        "email": record["email"],
        "city": record.get("address", {}).get("city"),
    }
    for record in payload
]
```

## Pattern 3 - Query Parameters

```python
response = requests.get(
    "https://jsonplaceholder.typicode.com/comments",
    params={"postId": 1},
    timeout=30,
)
response.raise_for_status()
comments = response.json()
```

## Pattern 4 - Handle Request Failure

```python
try:
    response = requests.get(url, timeout=5)
    response.raise_for_status()
except requests.Timeout:
    print("Request timed out")
except requests.ConnectionError:
    print("Connection failed")
except requests.HTTPError as exc:
    print(f"HTTP error: {exc}")
```

## Pattern 5 - Retry Wrapper

```python
import time


def fetch_with_retry(url: str, retries: int = 3) -> list[dict]:
    for attempt in range(1, retries + 1):
        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            return response.json()
        except requests.RequestException as exc:
            if attempt == retries:
                raise
            print(f"Attempt {attempt} failed: {exc}")
            time.sleep(attempt * 2)

    raise RuntimeError("Unreachable")
```

## Pattern 6 - Snapshot Naming

```python
from datetime import datetime


snapshot_name = f"users_{datetime.now().strftime('%Y-%m-%d')}.json"
```

## Key Point

The correct lesson here is not only how to call an API.

It is how to make API extraction recoverable, inspectable, and reusable.