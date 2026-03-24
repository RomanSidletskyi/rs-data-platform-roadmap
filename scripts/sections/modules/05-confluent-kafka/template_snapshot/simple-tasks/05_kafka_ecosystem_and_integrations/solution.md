# Solution

Connect vs custom example:

- good Connect case: standard sink from Kafka to Elasticsearch or object storage
- custom code case: consumer needs complex domain validation and side effects

CDC vs curated event example:

- raw CDC topic: `cdc.orders_raw`
- curated business topic: `sales.order_events`

Stack interpretation:

- Kafka transports and fans out events
- Spark or Flink performs processing or enrichment
- lakehouse or warehouse stores analytical models for long-term querying