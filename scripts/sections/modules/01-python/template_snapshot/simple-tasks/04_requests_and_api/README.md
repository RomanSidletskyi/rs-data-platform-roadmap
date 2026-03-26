# Requests and API Work

This section introduces API data collection for ingestion pipelines.

---

## Task 1 — Fetch Data From a Public API

### Goal
Call a public API and save the response.

### Input

    https://jsonplaceholder.typicode.com/users

### Requirements

- use the `requests` library
- retrieve JSON data
- save the response to a file

### Expected Output

A JSON file containing user records.

### Extra Challenge

- print the number of records returned
- save the response with a timestamped filename

---

## Task 2 — Extract Selected Fields

### Goal
Process only the fields you need.

### Input

Use this API:

    https://jsonplaceholder.typicode.com/users

Keep fields:

- id
- name
- email

### Requirements

- retrieve API data
- keep selected attributes only
- save processed results

### Expected Output

    [
        {"id": 1, "name": "Leanne Graham", "email": "Sincere@april.biz"}
    ]

### Extra Challenge

- extract nested field `address.city`
- convert output to CSV

---

## Task 3 — Add Query Parameters

### Goal
Learn how to filter API responses.

### Input

    https://jsonplaceholder.typicode.com/comments?postId=1

### Requirements

- send query parameters in the request
- verify that the response changes
- document what each parameter does

### Expected Output

A filtered API response for one post.

### Extra Challenge

- make query parameters configurable
- compare results for two different parameter values

---

## Task 4 — Handle Request Failures

### Goal
Make API scripts more robust.

### Input

Use:
- one valid API URL
- one invalid API URL

### Requirements

- catch timeout errors
- catch connection errors
- print or log failure details

### Expected Output

Readable error messages without crashing unexpectedly.

### Extra Challenge

- handle non-200 status codes separately
- write failures to a log file

---

## Task 5 — Add Retry Logic

### Goal
Retry unstable API calls automatically.

### Input

Use any API URL and simulate failure with:
- wrong domain
- short timeout

### Requirements

- retry failed requests
- add delay between attempts
- stop after a fixed number of retries

### Expected Output

Several retry attempts followed by success or final failure message.

### Extra Challenge

- make retries configurable
- log attempt number and wait time

---

## Task 6 — Work With Pagination

### Goal
Collect data from multi-page APIs.

### Input

Use an API that supports pagination, or simulate pages with multiple URLs.

### Requirements

- request multiple pages
- combine all results
- save the final merged dataset

### Expected Output

A single combined output file.

### Extra Challenge

- stop automatically when no more pages exist
- count total records across all pages

---

## Task 7 — Save Daily Snapshots

### Goal
Simulate historical data collection.

### Input

Any public API response saved daily.

### Requirements

- save each API run with execution date in the filename
- keep previous outputs
- avoid overwriting past snapshots

### Expected Output

Files like:

    users_2025-03-11.json
    users_2025-03-12.json

### Extra Challenge

- store snapshots in date-based folders
- compare today's file with the previous snapshot

---

## Task 8 — Compare API Responses

### Goal
Detect data changes between runs.

### Input

Two JSON files:

    users_day_1.json
    users_day_2.json

### Requirements

- load two API snapshots
- compare records
- identify added, removed, or changed entries

### Expected Output

A summary of differences between the two files.

### Extra Challenge

- output the diff as JSON
- compare only selected fields
