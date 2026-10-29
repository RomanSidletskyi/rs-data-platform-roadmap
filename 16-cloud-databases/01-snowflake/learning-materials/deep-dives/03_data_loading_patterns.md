# Data Loading Patterns

## Start with the Delivery Contract

Select a loading feature only after defining source behavior. Record format, volume, cadence, freshness objective, replay window, duplicate semantics, late data, schema-change policy, and ownership of failure handling.

## Pattern 1: Scheduled Batch Files

```text
Source -> object storage landing path -> stage/file format -> COPY INTO raw
       -> validation and load history -> curated transformation
```

Use bulk loading when delivery can be grouped into files and operational simplicity or throughput matters more than very low latency. Keep a manifest or equivalent expected-file record, retain source files for replay, and reconcile expected deliveries against successful loads.

## Pattern 2: Continuous File Arrival

Snowpipe can automate ingestion of new files using supported notifications and integrations. It reduces custom polling, but the platform still needs to monitor file discovery, load outcomes, rejected records, freshness, and cost. It is not a guarantee that every upstream file arrived correctly.

## Pattern 3: Low-Latency Rows or Events

Snowpipe Streaming and other supported connector patterns can reduce latency for row-oriented ingestion. Evaluate producer behavior, ordering, offsets, retry semantics, schema evolution, client operation, and account availability. If end-to-end event processing is required, compare with a streaming backbone and downstream consumer rather than assuming the warehouse alone supplies event-platform semantics.

## Idempotency and Replay

Retries happen. A robust ingestion design gives each source delivery a stable identifier, records batch/file outcomes, and makes downstream transformations safe to rerun. Common strategies include staging plus deduplication, merge by stable business key, and recording source version or event offset. The correct strategy depends on whether source records are immutable events, snapshots, or corrections.

Do not treat load-history duplicate suppression as a complete business idempotency contract. A file can be renamed, restated, partially corrected, or delivered with changed content.

## Error Handling and Quarantine

Choose whether one bad file should fail a batch, whether bad rows can be isolated, and who resolves them. Quarantine requires a location, owner, alert, retention policy, and replay process. Silent skipping is especially risky when the completeness requirement is strict.

## External Storage Security

Prefer supported storage integrations and narrow cloud IAM trust over embedded credentials. Scope access to required paths, review network requirements, and monitor both Snowflake grants and cloud-side policy. An external stage is a trust boundary, not just a file path.

## Observability Contract

At minimum, capture:

- expected and discovered files or source batches
- successful and rejected rows/files
- source and target timestamps
- duplicate and late-record counts
- load failures and retry outcomes
- freshness against the agreed SLA

## Trade-Off Summary

| Pattern | Strength | Cost or limitation |
| --- | --- | --- |
| Scheduled `COPY INTO` | Simple, explicit batch boundary, replay-friendly | Latency follows schedule and file availability |
| Snowpipe | Managed file-arrival ingestion | Notification and load behavior still needs observability and reconciliation |
| Snowpipe Streaming | Lower-latency row ingestion for supported scenarios | Producer, retry, offset, and availability constraints need deeper validation |
| External ingestion platform | Can centralize source connectivity and event semantics | More components, cost, and operational ownership |

## Decision Checklist

- What is the freshness SLA, and which part of the end-to-end path consumes it?
- What source identifier makes retry and correction behavior deterministic?
- Can every input be reconciled, quarantined, and replayed?
- Which service owns schema evolution and source outages?
- What cloud permissions and data copies are introduced?