# Source Assets

Provided starter scripts:

- `order_sink_helpers.py` for validation, normalization, upsert preparation, and DLQ record construction
- `preview_sink_decisions.py` for quickly classifying input records as valid sink writes or DLQ candidates

Suggested next additions:

- real Kafka consumer wrapper
- real PostgreSQL write path
- retry and backoff loop around transient database failures