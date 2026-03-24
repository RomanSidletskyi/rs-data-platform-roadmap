# 01 IoT Streaming Lab

## Project Goal

Build a small IoT telemetry ingestion lab with Kafka as the event backbone.

## Scenario

You operate a fleet of warehouse sensors that continuously publish temperature and humidity readings.

The platform must:

- ingest device events reliably
- preserve per-device ordering where it matters
- support replay for debugging or recomputation
- feed downstream monitoring and analytical consumers independently

## Project Type

This folder is a guided project, not a ready solution.

If you want a ready implementation afterwards for comparison, use the separate sibling reference project:

- `05-confluent-kafka/pet-projects/reference_example_iot_streaming_lab`

## Expected Deliverables

- local Kafka-based ingestion setup
- telemetry event contract design
- topic and partition-key strategy
- one producer and at least two consumer roles
- short note about lag, replay, and hot-partition risks

## Starter Assets Already Provided

- `.env.example`
- `src/telemetry_event_generator.py`
- `src/build_site_temperature_summary.py`
- `data/sample_telemetry_events.jsonl`
- `data/sample_bad_telemetry_events.jsonl`
- `tests/fixture_expected_site_summary.json`
- `src/README.md`
- `data/README.md`
- `tests/README.md`
- `config/README.md`
- `docker/README.md`
- `architecture.md`

## Definition Of Done

The lab demonstrates a realistic device-event ingestion flow and explains why `device_id`-centric ordering and replay matter in operational telemetry systems.