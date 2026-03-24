# Merge Decision Recipe

## Goal

Choose when `MERGE` is the right Delta Lake pattern instead of defaulting to it for every table change.

## Why This Recipe Exists

`MERGE` is one of the first Delta Lake features teams learn.

It is also one of the first features teams overuse.

The goal of this recipe is not to make `MERGE` feel advanced.

The goal is to decide whether the table truly needs row-level state change semantics or whether a simpler write pattern would be safer.

## Recipe

1. Confirm the business key.
2. Decide whether late updates and inserts both exist.
3. Check whether the workload must be idempotent.
4. Use `MERGE` when row-level state changes are real.
5. Avoid `MERGE` when append-only behavior is enough.

## When This Recipe Applies

Use this recipe when:

- a table receives late corrections
- a CDC feed contains inserts and updates
- a dimension or current-state table needs upserts
- the team is unsure whether plain append is still safe

## Example

```python
(target.alias("t")
    .merge(source.alias("s"), "t.order_id = s.order_id")
    .whenMatchedUpdateAll()
    .whenNotMatchedInsertAll()
    .execute())
```

## Real Scenario

Scenario:

- a customer profile table receives late corrections from a CRM export
- the platform wants one latest-state row per customer
- the source can contain inserts and updates for the same key

Healthy reasoning:

- the table represents current entity state
- the business key is stable enough to match on
- replay must preserve the same final table version for the same source slice

That is a natural `MERGE` use case.

Weak reasoning:

- a raw event table receives append-only facts
- the team still uses `MERGE` because it sounds safer than append

That often creates unnecessary complexity.

More realistic version with update precedence:

```python
(target.alias("t")
    .merge(source.alias("s"), "t.order_id = s.order_id")
    .whenMatchedUpdate(
        condition="s.updated_at >= t.updated_at",
        set={
            "status": "s.status",
            "updated_at": "s.updated_at",
            "net_amount": "s.net_amount",
        },
    )
    .whenNotMatchedInsertAll()
    .execute())
```

## Good Fit

- one row represents latest entity state
- updates and inserts both happen in the source
- business keys are stable enough to match reliably
- reruns must preserve the same final table state

It is especially strong when the business truth is stateful: customer status, order latest state, account profile, inventory position.

## Bad Fit

- the table is naturally append-only
- the match key is unclear or low-quality
- source duplicates are not cleaned or prioritized
- the merge logic hides a broader modeling problem

It is also a weak fit when the team is really trying to compensate for poor upstream event modeling rather than maintain a clear Delta table contract.

## Decision Questions

1. Is this table latest-state, historical-state, or append-only?
2. What exactly is the match key?
3. What happens if source duplicates arrive for the same key?
4. Do we need delete handling too?
5. Would a bounded overwrite or append pattern be simpler and safer?

Two more useful questions:

6. Does the source describe current state or event history?
7. If the same source file is processed twice, will the result stay correct?

## Good Response Versus Weak Response

Good response:

- define the table role first
- define the match key and winner logic explicitly
- use `MERGE` only when the contract truly needs it

Weak response:

- start from `MERGE` syntax first
- discover semantics later
- let replay and duplicates be handled accidentally

## Rule

Use `MERGE` because the table semantics require it, not because it is the most famous Delta command.
