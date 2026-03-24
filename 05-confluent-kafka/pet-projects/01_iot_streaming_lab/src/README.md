# Source Assets

Provided starter scripts:

- `telemetry_event_generator.py` emits deterministic JSONL telemetry events
- `build_site_temperature_summary.py` simulates an analytical consumer that aggregates site-level temperature summaries

Suggested next additions:

- Kafka producer wrapper around the generated events
- monitoring consumer for threshold breaches
- DLQ or validation helper for malformed telemetry