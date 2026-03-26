# Reference Example - Clickstream Session Pipeline

This folder contains a ready implementation kept as a reference example.

Its purpose is:

- self-checking after attempting the guided project
- comparing implementation decisions for raw clickstream transport and session summarization
- preserving a reusable Kafka analytics-ingestion pattern for future modules

You should attempt the guided project first:

- `05-confluent-kafka/pet-projects/02_clickstream_session_pipeline`

Only after that should you compare your implementation with this reference example.

## What This Reference Example Demonstrates

- deterministic clickstream sample events across multiple sessions
- a small session summary builder from replayable JSONL inputs
- fixture-driven validation of session-level aggregates
- explicit separation between raw transport data and downstream summary logic

## Folder Overview

- `.env.example` for local topic and keying values
- `src/generate_clickstream_events.py` for deterministic sample-event generation
- `src/build_session_summary.py` for session-level aggregation logic
- `data/sample_clickstream_events.jsonl` as replayable raw input
- `tests/fixture_expected_session_summary.json` and `tests/verify_session_summary.sh` for smoke validation
- `architecture.md` for target system reasoning

## How To Run

Generate sample clickstream events:

```bash
python3 src/generate_clickstream_events.py --count 6
```

Build a session summary:

```bash
python3 src/build_session_summary.py data/sample_clickstream_events.jsonl
```

Run the smoke check:

```bash
/bin/sh tests/verify_session_summary.sh
```

## What To Compare

When comparing this reference example with your own implementation, focus on:

- whether your event fields make session boundaries explicit
- whether your summary logic stays honest about Kafka being transport rather than a full session engine
- whether your validation approach checks structured outputs rather than brittle text output