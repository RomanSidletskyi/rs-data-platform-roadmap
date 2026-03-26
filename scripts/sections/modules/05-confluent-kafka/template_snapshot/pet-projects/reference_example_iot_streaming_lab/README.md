# Reference Example - IoT Streaming Lab

This folder contains a ready implementation kept as a reference example.

Its purpose is:

- self-checking after attempting the guided project
- comparing implementation decisions for telemetry ingestion and aggregation
- preserving a reusable Kafka learning pattern for future modules

You should attempt the guided project first:

- `05-confluent-kafka/pet-projects/01_iot_streaming_lab`

Only after that should you compare your implementation with this reference example.

## What This Reference Example Demonstrates

- deterministic telemetry event generation
- summary-building from replayable JSONL event samples
- fixture-based validation of analytical output
- a small but credible event-ingestion project shape

## Folder Overview

- `.env.example` for local topic and broker values
- `src/telemetry_event_generator.py` for deterministic event emission
- `src/build_site_temperature_summary.py` for site-level aggregation logic
- `data/sample_telemetry_events.jsonl` and `data/sample_bad_telemetry_events.jsonl` as valid and invalid samples
- `tests/fixture_expected_site_summary.json` and `tests/verify_site_summary.sh` for smoke validation
- `architecture.md` for target system reasoning

## How To Run

Generate sample telemetry:

```bash
python3 src/telemetry_event_generator.py --count 5
```

Build the site summary:

```bash
python3 src/build_site_temperature_summary.py data/sample_telemetry_events.jsonl
```

Run the smoke check:

```bash
/bin/sh tests/verify_site_summary.sh
```

## What To Compare

When comparing this reference example with your own implementation, focus on:

- whether your event fields are explicit and replay-safe
- whether your aggregation logic tolerates malformed records reasonably
- whether your tests validate outputs semantically instead of by fragile string matching