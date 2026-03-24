# Idempotency, Incremental Processing, And Data Quality

## Why This Topic Matters

This is one of the most important files in module 1.

Without these ideas, a learner can write scripts that appear correct in a one-time demo but behave badly in real usage.

Real pipelines must survive reruns, partial failures, late-arriving data, and bad inputs.

That is why these three topics belong in the first Python module, not much later.

## Continue Using The Same Mini-Pipeline

Use the same reference workflow:

`API -> raw JSON snapshot -> validation -> normalized records -> processed CSV -> run summary`

Now add realistic operational questions:

- what happens if the job runs twice
- what happens if the source returns duplicate records
- what happens if 5 records are invalid
- what happens if the script crashes after writing half the output

Those questions are the beginning of pipeline engineering.

## 1. Idempotency

Idempotency means that rerunning the same logical work should not corrupt the result.

In plain language:

- one retry should not produce duplicate output
- one rerun should not silently append the same records again
- one recovery run should produce the same intended state for the same input

## Good Idempotent Patterns

### Deterministic Output Paths

If one logical input batch always maps to one output path, reruns are safer.

Example:

- input date: `2025-01-10`
- output file: `processed/users_2025-01-10.csv`

If the same batch is rerun, the script overwrites or rebuilds the same target, instead of creating duplicates.

### Save Raw Snapshot Separately

Keeping raw input separate from processed output helps recovery.

Example:

- raw snapshot saved once per run or partition
- processed output rebuilt from the raw snapshot if needed

### Use Stable Keys

If records have a reliable business key or source ID, duplicates are easier to detect.

Examples:

- user id
- order id
- event id

## Bad Idempotent Pattern

Bad example:

- every rerun appends transformed rows to the same CSV with no duplicate detection

This often looks fine in a quick demo and becomes a serious problem later.

## 2. Incremental Processing

Incremental processing means handling only new or changed data instead of rebuilding everything every time.

This matters because real systems grow.

Even in beginner projects, the learner should already see that “process everything forever” is not the only model.

## Simple Incremental Strategies For Module 1

### File-Based Incremental Pattern

1. discover files in `data/raw/`
2. read `processed_files.json`
3. process only unseen files
4. update state after successful processing

### Timestamp-Based Incremental Pattern

1. store last successful extraction timestamp
2. call API with `updated_after`
3. ingest only changed records

### High-Water-Mark Pattern

1. remember the largest processed ID or event time
2. request only newer data next run

These are simplified versions of patterns that show up later in production platforms.

## Why Incremental State Must Be Explicit

If incremental state only lives in memory, it disappears after the process exits.

State should be persisted in a clear place.

Examples:

- `state/processed_files.json`
- `state/last_seen_timestamp.json`
- metadata table in a database

Beginners do not need advanced state systems yet, but they do need the habit of making state explicit.

## 3. Data Quality

Data quality starts much earlier than many learners expect.

It does not begin only when the project reaches warehouses or dashboards.

It begins at the first place where raw input is trusted or rejected.

## Minimum Data Quality Checks For Module 1

Module 1 should already teach:

- required-field validation
- null checks
- simple type checks
- duplicate detection
- quarantine of invalid records
- run summary reporting

## Why Validation Should Happen Before Final Publish

If you validate only after publishing processed output, bad data has already moved downstream.

A safer sequence is:

1. load raw input
2. validate records
3. separate valid and invalid records
4. publish only valid output
5. keep invalid rows inspectable

## Quarantine Is Better Than Silent Deletion

One of the worst beginner habits is to silently drop bad rows.

That creates false confidence.

A better pattern is to quarantine invalid rows into a separate file.

Example outputs:

- `processed/users.csv`
- `quarantine/invalid_users.json`
- `run_summary.json`

Now the pipeline is more explainable.

## Example: Small Validation Split

```python
def split_valid_and_invalid(records: list[dict]) -> tuple[list[dict], list[dict]]:
	valid_records = []
	invalid_records = []

	for record in records:
		if record.get("id") is None or not record.get("email"):
			invalid_records.append(record)
		else:
			valid_records.append(record)

	return valid_records, invalid_records
```

This is simple, but it teaches a critical pipeline habit: invalid data should remain visible.

## Common Failure Scenarios To Think About

### Scenario 1: Rerun After Partial Failure

The job saved a raw snapshot but crashed before writing processed output.

Question:

- can the pipeline rebuild from the raw snapshot cleanly

### Scenario 2: Source Sends Duplicate Records

Question:

- is there a stable key to detect duplicates
- does the output append duplicates blindly

### Scenario 3: New Schema Field Appears

Question:

- does the pipeline ignore it safely
- fail loudly
- capture it in raw snapshot for inspection

### Scenario 4: Five Records Are Bad

Question:

- are they inspectable later
- do counts appear in the run summary
- does the pipeline fail or continue based on a clear rule

These are early architecture questions, not only code questions.

## Good Strategy

- validate before final publish
- persist incremental state clearly
- keep raw input recoverable
- keep invalid records inspectable
- make reruns predictable
- produce summary metadata for each run

## Bad Strategy

- silently drop bad rows
- append blindly on every rerun
- trust source data because it is “internal”
- keep no incremental state
- overwrite files unpredictably

## Why Bad Strategy Fails In Practice

If these habits are missing, several problems appear:

- duplicates accumulate
- errors cannot be explained later
- reprocessing becomes risky
- downstream consumers lose trust in outputs

That is exactly how simple scripts become operational liabilities.

## Connection To Later Modules

These ideas will reappear everywhere later:

- in Spark jobs through partition logic and overwrite strategies
- in Airflow through retries and task reruns
- in dbt through model materialization and tests
- in Kafka through delivery semantics and event deduplication
- in Delta or Iceberg through table-state management and incremental loads

So this file is not an advanced detour. It is foundational.

## Final Takeaway

Module 1 should already teach the learner to think like a pipeline engineer, not only like a script writer.

If the learner can ask:

- will this rerun safely
- how do I know what was processed
- where do bad records go
- how do I avoid duplicate output

then the module is doing real architectural work, not just syntax training.