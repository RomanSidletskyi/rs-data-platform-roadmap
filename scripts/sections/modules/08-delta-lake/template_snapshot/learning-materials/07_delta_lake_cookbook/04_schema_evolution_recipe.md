# Schema Evolution Recipe

## Goal

Allow intentional schema change without turning every upstream surprise into consumer risk.

## Why This Recipe Exists

Schema evolution looks deceptively easy in Delta Lake.

The code to allow it is often one option flag.

The hard part is not the flag.

The hard part is deciding whether the table should change at all, in which layer it should change, and how consumers will experience that change.

## Recipe

1. decide whether the change is technical, semantic, or both
2. identify which consumers are affected
3. evolve the schema only when the contract impact is understood
4. prefer explicit rollout over silent drift

## When This Recipe Applies

Use this recipe when:

- a new upstream column arrives
- a type or nullability assumption changes
- one team wants to evolve a table that other teams already consume
- technical schema change may imply semantic contract change

## Example

```python
(incoming_df.write
    .format("delta")
    .mode("append")
    .option("mergeSchema", "true")
    .saveAsTable("silver.orders"))
```

Safer review mindset:

- ask whether consumers can ignore the change safely
- check whether dashboards, views, or downstream joins assume the old shape
- decide whether the change belongs in silver only or is safe for gold too

## Real Scenario

Scenario:

- an upstream source adds a new nullable field used only by engineering logic

Healthy reasoning:

- the field may evolve safely in silver first
- gold exposure may wait until semantics are agreed and consumers are ready

Another scenario:

- a field type changes from integer to string because the upstream system changed identifier format

That is not just a technical schema tweak.

It may break joins, BI models, and assumptions across the platform.

## Good Fit

- the change is intentional and reviewed
- consumer impact is known
- the new schema still matches the intended table role

## Bad Fit

- mergeSchema is used as the default answer to upstream drift
- the team cannot explain whether the change is technical or semantic
- downstream contracts are expected to absorb all changes automatically

## Decision Questions

1. Is this change purely additive, or does it alter meaning too?
2. Which consumers will notice it first?
3. Should the schema evolve in this layer, or should the change be normalized earlier?
4. Does the table still represent the same business contract after the change?
5. Is silent evolution safer than an explicit rollout here?

Two more useful questions:

6. If this write succeeds silently, who will notice the downstream breakage first?
7. Should the platform block the change until a contract review happens?

## Good Response Versus Weak Response

Good response:

- separate technical compatibility from semantic compatibility
- evolve schema deliberately by layer
- keep consumer-facing contracts more conservative

Weak response:

- let `mergeSchema` become the default response to drift
- rely on consumers to absorb all changes themselves
- treat successful write completion as proof that the change was safe

## Rule

Just because Delta Lake can evolve a schema does not mean the platform should accept every change automatically.
