# Pagination, Retries, And Rate Limits

## Why This Topic Matters

Real APIs are unstable, incomplete, and often paginated.

If the learner studies only the happy path, their first real ingestion job will break quickly.

## Pagination

Pagination means the full dataset is split across multiple requests.

Common patterns:

- page number
- offset and limit
- cursor or continuation token

### Page Number Example

```python
response = requests.get(url, params={"page": 3, "limit": 100}, timeout=30)
```

### Offset And Limit Example

```python
response = requests.get(url, params={"offset": 200, "limit": 100}, timeout=30)
```

### Cursor Example

```python
response = requests.get(url, params={"cursor": next_cursor}, timeout=30)
```

Important engineering question:

- how do you know the dataset is complete?

Possible stopping rules:

- empty page
- returned record count smaller than limit
- response field like `has_more = false`
- missing or null continuation token

## Retry Logic

Retries protect against temporary failures such as:

- transient network issues
- short service unavailability
- rate-limit windows

They should not blindly hide permanent failures such as:

- bad credentials
- invalid endpoint
- broken request payload
- schema mismatch in the business contract

## Rate Limits

Many APIs restrict:

- requests per minute
- requests per token
- burst size

## Good Strategy

- make retry count explicit
- sleep between attempts
- log attempt number and failure reason
- keep pagination logic readable
- separate retryable failures from non-retryable failures
- record the last successful page or cursor when runs are long

## Bad Strategy

- infinite retries
- ignore 429 responses
- assume pagination ends after a fixed number of pages
- retry on every 4xx response without thinking about cause
- swallow the final exception after the last retry

## Why Bad Is Bad

- jobs can hang forever
- providers can throttle or block the client
- partial datasets may be treated as complete
- real integration bugs can be hidden inside meaningless retries

## Example - Retryable vs Non-Retryable Failure

```python
response = requests.get(url, timeout=30)

if response.status_code == 401:
    raise RuntimeError("Authentication failed; do not retry blindly")

if response.status_code == 429:
    raise RuntimeError("Rate limited; retry with backoff")
```

## Pattern - Exponential Backoff

```python
import time


for attempt in range(1, 5):
    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        break
    except requests.RequestException as exc:
        if attempt == 4:
            raise
        sleep_seconds = 2 ** attempt
        logger.warning("Attempt %s failed: %s | sleeping %s seconds", attempt, exc, sleep_seconds)
        time.sleep(sleep_seconds)
```

## Pattern - Cursor Pagination Loop

```python
all_records: list[dict] = []
next_cursor: str | None = None

while True:
    params = {"limit": 100}
    if next_cursor is not None:
        params["cursor"] = next_cursor

    response = requests.get(url, params=params, timeout=30)
    response.raise_for_status()
    payload = response.json()

    page_records = payload["data"]
    next_cursor = payload.get("next_cursor")

    all_records.extend(page_records)

    if not next_cursor:
        break
```

## Pattern - Respect `Retry-After`

```python
if response.status_code == 429:
    retry_after = int(response.headers.get("Retry-After", "5"))
    logger.warning("Rate limited; sleeping %s seconds", retry_after)
    time.sleep(retry_after)
```

## Pattern - Partial Progress Metadata

When ingestion is long-running, store metadata such as:

- current page number
- last successful cursor
- total records fetched so far
- last API timestamp seen

This does not always mean true resumability, but it improves debugging and rerun design.

## Combined Example

```python
import time
import requests


def fetch_all_pages(url: str) -> list[dict]:
    page = 1
    all_records: list[dict] = []

    while True:
        for attempt in range(1, 5):
            try:
                response = requests.get(url, params={"page": page, "limit": 100}, timeout=30)

                if response.status_code == 429:
                    retry_after = int(response.headers.get("Retry-After", "5"))
                    time.sleep(retry_after)
                    continue

                response.raise_for_status()
                payload = response.json()
                if not isinstance(payload, list):
                    raise ValueError("Expected list response")
                break
            except (requests.RequestException, ValueError) as exc:
                if attempt == 4:
                    raise
                time.sleep(2 ** attempt)
        else:
            raise RuntimeError("Unreachable retry loop state")

        if not payload:
            break

        all_records.extend(payload)
        page += 1

    return all_records
```

## Key Architectural Takeaway

Stable ingestion is often less about business logic and more about defensive interaction with unreliable external systems.