# Architecture

## Components

- device event producer
- Kafka topic such as `iot.device_events`
- operational monitoring consumer
- analytical landing consumer
- optional DLQ for malformed telemetry

## Data Flow

1. devices publish telemetry events keyed by `device_id`
2. Kafka stores the stream and preserves partition-local order
3. monitoring consumer checks threshold breaches
4. analytics consumer lands data into downstream storage
5. malformed events move to DLQ or validation path

## Trade-Offs

- `device_id` is strong for per-device ordering
- one very noisy device can still create skew
- replay is valuable for analytics rebuilds and incident review