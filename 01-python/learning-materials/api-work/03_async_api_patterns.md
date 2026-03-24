# Async API Patterns

## Why This Topic Matters

Many engineers eventually meet workloads where synchronous HTTP calls are too slow.

Examples:

- fetching many small endpoints
- enriching records from multiple APIs
- calling the same API for many IDs

Async Python is not required for every data script.

But the learner should understand when it becomes useful and what shape it takes.

## What Async Helps With

Async helps most when the work is:

- I/O-bound
- waiting-heavy
- made of many independent HTTP requests

It does not automatically help CPU-heavy transformation logic.

## Core Concepts

### `async def`

Defines an asynchronous function.

```python
async def fetch_one_user(user_id: int) -> dict:
    ...
```

### `await`

Waits for another async operation to finish.

```python
payload = await response.json()
```

### `asyncio.run()`

Starts the top-level async workflow.

```python
asyncio.run(main())
```

### `asyncio.gather()`

Runs several awaitable tasks together.

```python
results = await asyncio.gather(task1, task2, task3)
```

Important detail:

- it is useful when requests are independent and can run concurrently

## Common Library Choice

For async HTTP work, engineers often use `aiohttp` or `httpx`.

This file shows `aiohttp` style because it makes the async shape explicit.

## Basic Async Example

```python
import asyncio
import aiohttp


async def fetch_json(session: aiohttp.ClientSession, url: str) -> dict | list:
    async with session.get(url, timeout=30) as response:
        response.raise_for_status()
        return await response.json()


async def main() -> None:
    async with aiohttp.ClientSession() as session:
        payload = await fetch_json(session, "https://jsonplaceholder.typicode.com/users")
        print(payload)


asyncio.run(main())
```

## Example - Fetch Many Resources Concurrently

```python
import asyncio
import aiohttp


async def fetch_post(session: aiohttp.ClientSession, post_id: int) -> dict:
    url = f"https://jsonplaceholder.typicode.com/posts/{post_id}"
    async with session.get(url, timeout=30) as response:
        response.raise_for_status()
        return await response.json()


async def main() -> None:
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_post(session, post_id) for post_id in range(1, 11)]
        posts = await asyncio.gather(*tasks)
        print(f"Fetched {len(posts)} posts")


asyncio.run(main())
```

## Why Engineers Use This Pattern

- network waiting overlaps instead of happening one request at a time
- total run time can drop significantly for many small requests

## Important Operational Constraint - Concurrency Limits

Async does not mean “unlimited requests.”

You still need to control concurrency to avoid:

- API throttling
- connection overload
- unstable client behavior

## Example - Limit Concurrency With Semaphore

```python
import asyncio
import aiohttp


semaphore = asyncio.Semaphore(5)


async def fetch_user(session: aiohttp.ClientSession, user_id: int) -> dict:
    async with semaphore:
        url = f"https://jsonplaceholder.typicode.com/users/{user_id}"
        async with session.get(url, timeout=30) as response:
            response.raise_for_status()
            return await response.json()
```

Important detail:

- `Semaphore(5)` means at most 5 requests run at the same time in that protected block

## Example - Async Retry Shape

```python
import asyncio
import aiohttp


async def fetch_with_retry(session: aiohttp.ClientSession, url: str, retries: int = 3) -> dict | list:
    last_error: Exception | None = None

    for attempt in range(1, retries + 1):
        try:
            async with session.get(url, timeout=30) as response:
                response.raise_for_status()
                return await response.json()
        except (aiohttp.ClientError, asyncio.TimeoutError, ValueError) as exc:
            last_error = exc
            if attempt == retries:
                raise
            await asyncio.sleep(2 ** attempt)

    raise RuntimeError("Unreachable retry state") from last_error
```

## When Async Is A Good Fit

- many small HTTP requests
- enrichment of records from separate endpoints
- latency-heavy integrations where calls are independent

## When Async Is Not The First Tool To Reach For

- one or two API calls only
- CPU-heavy transformation work
- codebase where operational simplicity matters more than concurrency gains
- teams that are not yet comfortable debugging async flows

## Common Mistakes

- using async for work that is not waiting-heavy
- creating huge uncontrolled concurrency
- mixing synchronous blocking code into the middle of async workflows
- forgetting that async code still needs timeouts, retries, and validation

## Key Architectural Takeaway

Async is a useful tool for I/O-heavy ingestion and enrichment patterns.

But it does not replace sound engineering boundaries.

You still need:

- validation
- retry logic
- concurrency control
- raw snapshot thinking
- clear separation between fetching and transformation