# Branching, Tagging, And Snapshot References

## 1. Why Snapshot References Matter

Many learners understand snapshots only as history.

That is incomplete.

Iceberg can also attach named references to snapshots.

These references are how the table can support concepts such as:

- branches
- tags

without turning the table into an unstructured pile of historical states.

## 2. The Main Branch Mental Model

Even when people do not talk about branches explicitly, they are usually operating on the main line of table history.

Conceptually:

- the main branch points to the current production snapshot

That is already a reference model.

## 3. What A Tag Is

A tag is a stable name for a specific snapshot.

Mental model:

- mark snapshot X as `quarter_close_2026_q1`

Tags are useful when you want a durable named checkpoint without advancing it through new commits.

## 4. What A Branch Is

A branch is a mutable named reference that can advance through new commits.

Mental model:

- create an isolated line of table changes for validation, staging, or controlled publish

That is why branching is more operationally powerful than tagging.

## 5. Why This Matters Architecturally

Snapshot references matter because they allow workflows such as:

- write-audit-publish patterns
- isolated test writes
- controlled promotion
- stable regulatory checkpoints

This is where Iceberg starts to feel less like a plain file table and more like a controlled table state system.

## 6. Retention Changes When References Exist

Retention is no longer just:

- keep snapshots for N days

It becomes:

- which snapshots are still reachable through active branches or tags
- which references protect snapshots from expiration

So snapshot expiration policy must be designed with reference semantics in mind.

## 7. Operational Consequence

If teams use tags or branches but operate cleanup as if only the latest snapshot matters, they risk breaking the workflows they intended to protect.

## 8. Catalog And Metadata View

Snapshot references live in the metadata model of the table.

That means the catalog still points to the current metadata root, and that metadata root contains the reference map that explains:

- which snapshot is current for main
- which snapshots are named by other references

## 9. When To Use This And When Not To

Use branching or tagging when the platform really needs:

- controlled promotion
- named historical checkpoints
- isolated validation paths

Do not introduce it only because it sounds advanced.

It adds operating-model complexity.

## 10. Architect Rule

Snapshot references are powerful because they move the table from “history exists” to “history is intentionally addressable.”

That is useful, but only when the organization is ready to operate it deliberately.