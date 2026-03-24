# Solutions: Ingestion Access And Operating Patterns

## Task 1

Raw stores original landed data with minimal transformation.

Curated stores cleaned and modeled data for internal platform use.

Publish stores consumer-facing data with stronger stability expectations.

A publish path matters because it communicates contract intent, not only folder naming.

## Task 2

Daily batch paths often assume predictable arrival windows and larger file batches.

Streaming-style ingestion may require idempotent landing, late-arrival tolerance, and tighter replay controls.

## Task 3

Blind overwrite can destroy investigation context, break downstream readers, and remove the ability to compare runs.

Safe replay design should consider versioning, atomic publish behavior, backfill isolation, and consumer impact.

## Task 4

Spark may tolerate deep partitioned layouts and many files better than interactive SQL tools or applications.

Applications and BI consumers often need stable published paths and predictable data organization.

## Task 5

Blind delete-and-rewrite removes investigation context, can break active readers, and often hides whether the replay was bounded or excessive.

Safer replay behavior includes explicit scope, path stability, temporary isolation where needed, and a controlled publish step after validation.
