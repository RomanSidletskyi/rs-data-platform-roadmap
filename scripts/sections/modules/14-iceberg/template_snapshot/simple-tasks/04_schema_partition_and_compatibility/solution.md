# 04 Schema Partition And Compatibility Solution

## Task 1 - Add A Column Without Breaking The Table Contract

```sql
ALTER TABLE glue_prod.analytics.orders
ADD COLUMN sales_channel STRING;
```

Key point: adding a nullable column is usually low risk because existing rows remain readable without redefining the meaning of old fields.

## Task 2 - Decide Whether A Rename Is Safe

One strong answer:

- Iceberg metadata can represent a rename safely because field identity is metadata-driven rather than position-driven
- the operational risk is that downstream consumers may depend on the old name, generated schemas, or semantic meaning tied to that label

Checks before approval:

1. which engines and jobs reference the old column name
2. whether BI models or contracts expose the old name externally
3. whether the rename is only a naming cleanup or a semantic redefinition in disguise

## Task 3 - Change Partition Strategy For A Growing Table

One strong answer: evolve to `PARTITIONED BY (days(order_ts), status)` for new writes.

Key point: Iceberg can track multiple partition specs over time, so the table can evolve without forcing a full rewrite of existing files.

Old files remain under the older partition spec until maintenance or rewrites change physical layout later.

## Task 4 - Choose A Safer Consumer Contract

Scenario B is the real contract risk.

Adding a nullable descriptive column is metadata-friendly. Quietly changing `amount` from gross to net while keeping the same column name breaks consumer expectations even if the physical schema barely changes.

## Task 5 - Evaluate Cross-Engine Compatibility Risk

Key point: a `v2` table with delete-heavy `MERGE` creates reader expectations that may not be handled equally by every engine.

Questions:

1. can each reader understand the specific `v2` mutation features being used
2. can each writer preserve consistent delete-aware semantics
3. are there query patterns or optimizations in one engine that behave differently after heavy mutation

## Task 6 - Decide When To Avoid Evolution Altogether

Recommended answer: publish a new versioned table.

- finance contract is widely consumed
- multiple core metrics are being redefined at once
- this is semantic contract change, not only technical schema change
- versioned publish reduces accidental silent breakage
- old and new contracts can coexist during migration