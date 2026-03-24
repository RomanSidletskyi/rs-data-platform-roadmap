# Repair And Restore Recipe

## Goal

Repair a bad Delta write safely without turning recovery into manual file surgery.

## Why This Recipe Exists

Recovery is one of the most practical reasons Delta Lake matters.

It is also a place where teams panic and make poor decisions.

This recipe exists to slow the decision down and force one important question first:

- what is the real scope of the damage?

## Recipe

1. Identify the bad table version or affected time window.
2. Decide whether bounded rewrite or full restore is safer.
3. Use time travel to inspect the previous correct state.
4. Restore or rerun with explicit scope.
5. Document why the failure happened and how to prevent it.

## When This Recipe Applies

Use this recipe when:

- a bad merge or overwrite changed the wrong rows
- a deployment introduced a broken table version
- only a specific window needs repair
- the team must choose between restore and bounded rewrite

## Example

```sql
RESTORE TABLE silver.orders TO VERSION AS OF 12;
```

Bounded rewrite alternative:

```python
(repair_df.write
	.format("delta")
	.mode("overwrite")
	.option("replaceWhere", "order_date >= '2026-03-20' AND order_date <= '2026-03-24'")
	.saveAsTable("silver.orders"))
```

## Real Scenario

Scenario:

- a bad merge changed the wrong records for three recent days
- newer valid writes also happened after that deployment

Healthy reasoning:

- full restore may roll back too much good work
- bounded rewrite of the affected days may be safer
- time travel should be used first to confirm which state is correct

Another scenario:

- a deployment produced a clearly broken whole-table version and no valid newer changes exist

That is a stronger restore candidate.

## Good Fit

- the failing version or affected window is clearly known
- recovery scope can be explained before action is taken
- consumers understand whether data may be restated

## Bad Fit

- engineers start editing underlying files manually
- the team restores blindly without checking consumer impact
- a full restore is used when a narrow repair would be safer

## Decision Questions

1. Is the problem tied to one bad version or one bounded slice?
2. Will restoring the whole table undo valid newer changes?
3. Can a narrow rewrite repair the issue more safely?
4. Which downstream consumers need to know that data was restated?
5. What operating control will prevent the same mistake next time?

Two more useful questions:

6. Is the table latest-state or historical-state, and does that change recovery safety?
7. Are we choosing the fastest-looking repair or the safest repair?

## Good Response Versus Weak Response

Good response:

- inspect history first
- choose recovery scope deliberately
- communicate restatement impact when needed

Weak response:

- restore blindly because the command exists
- rewrite too much healthy data out of convenience
- treat recovery as purely technical with no consumer implications

## Rule

Prefer explicit table-history recovery over ad hoc manipulation of underlying files.
