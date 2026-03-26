# HTTP API Ingestion Patterns

## Why This Topic Matters

API ingestion is one of the most common entry points into data engineering work.

Python is often the first tool used for it because it is flexible and quick to ship.

## What Python Owns Here

In a simple ingestion workflow, Python usually owns:

- request construction
- response validation
- raw payload persistence
- transformation into internal shape
- run logging

It often also owns:

- authentication headers or tokens
- pagination state
- request parameter construction
- response schema checks
- snapshot naming and metadata capture

## What Python Should Not Pretend To Be

It should not pretend to be:

- a streaming platform
- a warehouse
- a long-term metadata system

## Good Strategy

- preserve raw response before aggressive transformation
- validate status code and response shape
- isolate API calling code from transformation code
- keep auth, retries, pagination, and transformation responsibilities separate
- capture enough metadata to explain what the run fetched

## Bad Strategy

- transform the response immediately and discard the raw payload
- assume API reliability without retries or timeouts
- hardcode tokens and endpoints in many places
- mix pagination loop, transformation, and file writing in one giant function

## Why Bad Is Bad

- recovery becomes harder
- debugging source issues becomes slower
- output correctness is harder to trust
- refactoring becomes risky because responsibilities are tangled

## Libraries Worth Knowing Here

### `requests`

Worth using when:

- the workflow is synchronous
- the team wants a very common and readable HTTP client
- the ingestion job is small or medium in scale

Why useful:

- simple API
- large community
- easy onboarding for beginners

### `httpx`

Worth using when:

- the team may want both sync and async clients
- a more modern HTTP client fits better than `requests`

Why useful:

- one mental model for sync and async styles
- clean client API

### `aiohttp`

Worth using when:

- the pipeline needs real async API ingestion
- many requests must be performed concurrently with control

Why useful:

- strong async support
- common choice for high-concurrency HTTP workflows

### `tenacity`

Worth using when:

- retry logic starts repeating across functions
- backoff and retry rules should be explicit and reusable

Why useful:

- cleaner retry decorators
- less handwritten retry boilerplate

### `pydantic`

Worth using when:

- API payloads are messy
- schema validation should be explicit and reusable
- type coercion and data contracts matter

Why useful:

- clearer validation errors
- code-level schema documentation

## Common Request Options Engineers Use

### `params=`

Used for query string parameters.

```python
response = requests.get(
	url,
	params={"page": 1, "limit": 100, "updated_after": "2026-03-01"},
	timeout=30,
)
```

### `headers=`

Used for auth and content negotiation.

```python
response = requests.get(
	url,
	headers={
		"Authorization": f"Bearer {token}",
		"Accept": "application/json",
		"User-Agent": "python-data-ingestion/1.0",
	},
	timeout=30,
)
```

### `json=`

Used when sending JSON payloads in POST or PUT requests.

```python
response = requests.post(
	url,
	json={"status": "active", "source": "data-platform"},
	headers={"Authorization": f"Bearer {token}"},
	timeout=30,
)
```

### `data=`

Used for form-like payloads.

```python
response = requests.post(
	token_url,
	data={"client_id": client_id, "client_secret": client_secret},
	timeout=30,
)
```

### `timeout=`

Used to prevent hanging calls.

```python
response = requests.get(url, timeout=30)
```

Important detail:

- engineers should almost never omit `timeout=` in production-style code

## Practical Engineering Patterns

### Pattern 1 - Reusable Session With Shared Headers

```python
session = requests.Session()
session.headers.update(
	{
		"Authorization": f"Bearer {token}",
		"Accept": "application/json",
	}
)

response = session.get(url, params={"page": 1}, timeout=30)
response.raise_for_status()
```

Why useful:

- shared headers stay in one place
- connection reuse is easier
- code is cleaner across multiple calls

### Pattern 2 - Validate Response Shape Before Transformation

```python
payload = response.json()

if not isinstance(payload, list):
	raise ValueError("Expected list response from users endpoint")

for record in payload:
	if not isinstance(record, dict):
		raise ValueError("Expected each user record to be a dictionary")
```

### Pattern 3 - Save Raw Snapshot And Metadata

```python
snapshot = {
	"endpoint": url,
	"fetched_at": fetched_at,
	"record_count": len(payload),
	"payload": payload,
}

write_json(raw_output_path, snapshot)
```

Why useful:

- later debugging becomes much easier
- the run has context, not only data

### Pattern 4 - Separate API Layer From Transformation Layer

```python
def fetch_users(session: requests.Session, page: int) -> list[dict]:
	response = session.get(url, params={"page": page}, timeout=30)
	response.raise_for_status()
	payload = response.json()
	if not isinstance(payload, list):
		raise ValueError("Expected list response")
	return payload


def normalize_users(records: list[dict]) -> list[dict]:
	return [
		{
			"id": record["id"],
			"name": record["name"].strip(),
			"email": record["email"].lower(),
		}
		for record in records
	]
```

### Pattern 5 - Handle 204 Or Empty Response Explicitly

```python
response = session.get(url, timeout=30)

if response.status_code == 204:
	return []

response.raise_for_status()
payload = response.json()
```

## Bigger Cookbook Example

```python
import requests


def fetch_page(session: requests.Session, url: str, page: int) -> list[dict]:
	response = session.get(
		url,
		params={"page": page, "limit": 100},
		timeout=30,
	)
	response.raise_for_status()

	payload = response.json()
	if not isinstance(payload, list):
		raise ValueError("Expected list response")

	return payload


def normalize_orders(records: list[dict]) -> list[dict]:
	normalized = []
	for record in records:
		normalized.append(
			{
				"order_id": record["id"],
				"status": record.get("status", "unknown").strip().lower(),
				"amount": record.get("amount"),
			}
		)
	return normalized


def run_ingestion(url: str, token: str) -> list[dict]:
	session = requests.Session()
	session.headers.update({"Authorization": f"Bearer {token}", "Accept": "application/json"})

	all_records: list[dict] = []
	page = 1

	while True:
		page_records = fetch_page(session, url, page)
		if not page_records:
			break

		all_records.extend(page_records)
		page += 1

	return normalize_orders(all_records)
```

## Key Architectural Takeaway

API ingestion is not only about calling `requests.get`.

It is about preserving source truth, validating contracts, and producing rerun-safe outputs.