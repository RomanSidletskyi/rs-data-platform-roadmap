# Source Assets

Provided starter scripts:

- `generate_clickstream_events.py` emits deterministic clickstream events across multiple sessions
- `build_session_summary.py` creates a compact session-level summary from raw clickstream JSONL data

Suggested next additions:

- Kafka producer wrapper around the generated events
- raw landing consumer for bronze-style persistence
- monitoring consumer for checkout spikes or abnormal click patterns