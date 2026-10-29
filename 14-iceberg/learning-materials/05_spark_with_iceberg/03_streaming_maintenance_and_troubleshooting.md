# Streaming, Maintenance, And Troubleshooting

## 1. Streaming Changes The Operational Story

When Spark is used with streaming or micro-batch patterns, Iceberg tables can change frequently.

That makes these more important:

- commit frequency
- small-file control
- maintenance cadence
- consumer freshness expectations

## 2. Maintenance Jobs Matter

Healthy Iceberg operation usually needs maintenance such as:

- file compaction
- manifest cleanup or consolidation
- snapshot expiration
- orphan-file cleanup depending on engine and platform model

If teams skip this, they often get:

- slower scans
- heavier planning
- more expensive writes
- harder recovery reasoning

## 3. Common Spark Troubleshooting Questions

When Spark + Iceberg behaves badly, ask:

1. Is the catalog resolving the correct table state?
2. Are manifests and snapshots growing too fast?
3. Are small files dominating?
4. Are writers conflicting?
5. Is this an engine-support issue rather than a table-design issue?

## 4. Anti-Pattern

Do not treat maintenance as a cleanup job that can be added later.

For production Iceberg tables, maintenance is part of table design from day one.

## 5. Practical Rule

The more frequent the writes and the more engines involved, the more intentionally you need to operate the table.