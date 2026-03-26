# Cost And Cleanup Recipe

## Goal

Reduce ADLS waste and clutter without destroying replay, audit, or consumer guarantees that the platform still needs.

## Why This Recipe Exists

Storage cost and clutter become hard to control when temporary, duplicated, or badly partitioned data is allowed to grow without review.

## Use This Recipe When

Use this recipe when the lake is growing quickly, file counts are rising, or cleanup feels ad hoc.

## Recipe

1. Classify each path as raw, curated, publish, or temporary.
2. Identify which paths still serve replay, audit, or consumer needs.
3. Identify duplicated or temporary paths with no justified long-term purpose.
4. Review file-count and listing pressure alongside retained volume.
5. Clean or expire only after recovery and consumer impact are understood.

## Decision Questions

1. Which paths are temporary versus durable?
2. What retention rule does each zone actually need?
3. Which directories are creating listing or file-count pain?
4. Which duplicated datasets are still justified?
5. What can be cleaned safely without destroying recovery guarantees?

## Example Scenario

Imagine a platform where these are all true:

- raw source files are kept indefinitely
- curated outputs are rebuilt often but old slices are never cleaned
- temporary backfill folders remain after incidents
- streaming-style ingestion has produced very high file counts in hot directories

The bill rises, listing gets slower, and nobody knows which paths are safe to delete.

The immediate temptation is:

- delete old data quickly

That is the weak response.

The stronger response is to split the cleanup decision into classes:

- temporary and incident-only paths
- raw replay-critical paths
- curated rebuildable paths
- publish paths with consumer retention needs

Each class should have different cleanup discipline.

## Second Scenario

Suppose a large backfill created these leftover paths:

- `tmp/backfill/customer_history_fix/`
- `curated/customer_history_v2_validation/`
- `publish/customer_history_snapshot_test/`

Six weeks later, nobody remembers which of them were temporary and which became unofficial dependencies.

The cleanup recipe should force the team to answer:

- which of these paths still have real consumers?
- which only existed to validate a migration?
- which should be deleted, and which should be formalized or replaced?

Without that review, cleanup becomes guesswork.

## Storage Review Matrix

Use a simple matrix before cleanup:

| Path class | Keep longer when | Clean faster when |
| --- | --- | --- |
| raw landing | replay, audit, or forensic history matters | source can be re-landed cheaply and retention is explicitly limited |
| curated internal | rebuild cost is high or reuse is broad | the area is temporary, duplicated, or easily reproducible |
| publish | consumers rely on historical availability | snapshots are intentionally replace-in-place and contract allows that |
| temporary or incident-only | almost never | purpose is finished and no supported downstream use remains |

This matrix is not a universal law.

It is a forcing mechanism so teams stop treating all storage as one cleanup class.

## Practical Review Pattern

Review cost and cleanup in this order:

1. identify temporary paths with no justified long-term value
2. identify directories with unhealthy file-count growth
3. identify duplicated datasets that no longer serve replay, audit, or consumer needs
4. identify paths whose retention exists only because ownership is unclear
5. only then apply cleanup or lifecycle changes

This order helps avoid deleting useful recovery depth while still reducing waste.

## Real Failure Mode

A frequent failure mode looks like this:

- the team deletes old raw files to reduce cost
- an upstream bug is discovered later
- replay is now impossible without expensive manual re-extraction

The mistake was not deletion by itself.

The mistake was deleting without first checking which paths carried replay responsibility.

## Edge Case Scenario

Suppose storage cost spikes and the team proposes three fast actions in one meeting:

- delete raw files older than 30 days
- delete publish folders with no recent dashboard queries
- keep duplicated curated data because nobody is sure who owns it

This looks cost-conscious, but it mixes three very different problems:

- replay responsibility
- consumer retention promises
- ownership ambiguity

The dangerous part is not only possible data loss.

The dangerous part is that weak governance is being hidden behind a cleanup initiative.

The recipe should force the team to separate the decisions:

- raw retention must be reviewed against replay, audit, and compliance needs
- publish cleanup must be reviewed against consumer expectations, not only query logs
- duplicated curated data often exists because nobody has formally retired old paths

If the team cannot answer those questions, the cleanup plan is premature even if the bill is painful.

The right response may include ownership repair and contract clarification before deletion starts.

## Good Fit

This recipe fits when the team needs to reduce waste without weakening the platform.

## Bad Fit

This recipe is weak if cost reduction is attempted without understanding replay, audit, or consumer needs.

## Good Response Versus Weak Response

Weak response:

- delete old data until the bill looks better

Good response:

- reduce waste through path-aware retention, cleanup of temporary areas, and review of file-layout and duplication patterns while preserving required recovery depth

## Expected Output Of The Recipe

The expected output is a path-by-path decision such as:

- keep `raw/crm/salesforce/accounts/` for replay
- shorten lifecycle on `tmp/backfill/customer_history_fix/`
- remove deprecated duplicate curated path after consumers move
- review file-count reduction on one hot clickstream directory

If the output is only “delete old files,” the recipe is too weak.

## Final Review Questions

Before cleanup, ask:

1. what business or operational promise does this path still support?
2. is anyone consuming it unofficially?
3. is the retained data reducing real risk or only avoiding a decision?
4. will cleanup remove waste or only hide weak ownership temporarily?

## Good Versus Bad Cleanup Signal

Bad signal:

- storage cost is high, so everything old looks disposable

Healthy signal:

- storage cost is reviewed path by path, with retention, replay, compliance, and consumer impact understood before action is taken

## Final Sanity Check

Before deleting or expiring anything, ask:

- if this path disappeared tomorrow, which replay, audit, or consumer promise would fail?

If nobody can answer, ownership and observability need work before cleanup can be trusted.

One more useful question is:

- are we actually deleting waste, or are we using cleanup to postpone a harder conversation about ownership, contracts, and recovery expectations?

If the answer is the second one, the lake needs governance repair before aggressive cleanup.
