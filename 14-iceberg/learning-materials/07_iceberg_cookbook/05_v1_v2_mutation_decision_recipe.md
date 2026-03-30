# V1 Versus V2 Mutation Decision Recipe

## Goal

Choose whether a table should stay on `v1` or move to `v2` based on workload semantics, not fashion.

## Step 1. Ask What The Table Actually Needs

If the table mostly needs:

- append
- periodic partition replacement
- time travel
- schema evolution

then `v1` may already be enough.

If the table needs:

- row-level deletes
- merge-driven updates
- mutation-aware planning

then you are usually in `v2` territory.

## Step 2. Check Engine Reality

1. Can the primary writer support the needed `v2` operations?
2. Can important readers understand the table features we plan to use?
3. Are we choosing `v2` because we need mutations or only because it sounds newer?

## Quick Matrix

```text
Need / Workload                     Prefer V1                         Prefer V2
---------------------------------   --------------------------------  -----------------------------------------
Append-heavy analytics              Yes                               Possible but not required
Time travel and schema evolution    Yes                               Yes
Delete-file row mutations           No                                Yes
Merge-like upserts                  Usually no                        Yes, with engine support
Broad compatibility pressure        Strong reason                     Possible but must be checked carefully
```

## Example Decision

### Keep V1

Use when:

- table is fed by batch append jobs
- downstream systems mostly read aggregates
- no one truly needs row-level updates

### Move To V2

Use when:

- table is subject to late corrections
- CDC-like merges are required
- delete-aware semantics are part of the contract

## Anti-Pattern

Bad reason to adopt `v2`:

- because “modern lakehouse” sounds better in architecture slides

Good reason to adopt `v2`:

- because the table contract genuinely includes row-level mutation workflows