# Architecture

## Components

- web event producer
- Kafka topic such as `web.clickstream_events`
- real-time monitoring consumer
- analytical landing consumer
- optional Spark or Flink sessionization stage

## Data Flow

1. application publishes raw clickstream events
2. Kafka stores the stream and fans out to multiple consumers
3. landing consumer persists raw events for analytics
4. processing engine can later sessionize and enrich the stream

## Trade-Offs

- `session_id` improves session-local ordering
- `user_id` may help broader user-level grouping
- Kafka is good at movement and replay, not complete user-behavior modeling by itself