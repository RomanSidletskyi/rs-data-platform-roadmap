# Simple Tasks: Ingestion Access And Operating Patterns

## Task 1: Raw Curated Publish

Explain the difference between raw, curated, and publish zones in ADLS.

Then explain why a publish path is more than a naming convenience.

## Task 2: Batch Versus Streaming Paths

Explain why a path structure that works for daily batch can be weak for streaming-style ingestion.

## Task 3: Replay And Backfill Safety

A team says they can always overwrite a folder and rerun later.

Explain why that is often too shallow.

## Task 4: Access Patterns

Explain how Spark, SQL engines, and applications can place different demands on the same ADLS storage layout.

## Task 5: Edge Case Replay Decision

A team fixes a bad load by deleting the current folder and rewriting all files from scratch without keeping the failed version or documenting the replay scope.

Explain why this is risky.

Then explain what safer replay behavior would include.
