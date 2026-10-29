# Iceberg Format Versions: V1, V2, And V3

## 1. Why Format Version Exists At All

Iceberg format version is not the same thing as:

- engine version
- library version
- Spark version

Format version tells you what metadata and table semantics are allowed for the table.

This matters because an engine may support Iceberg generally, but not every table feature allowed by a newer format version.

## 2. The Practical Mental Model

Think about format versions like this:

- `v1` = strong analytic table format for immutable data files and snapshot metadata
- `v2` = `v1` plus row-level delete semantics and stricter metadata model
- `v3` = extends the model further with newer capabilities such as deletion vectors and row lineage features

For most real platform design conversations today, the key architect split is still:

- `v1` tables
- `v2` tables

because many production write paths and interoperability decisions still revolve around that boundary.

## 3. What V1 Gives You

`v1` already gives you a lot:

- snapshot-based table state
- metadata-driven reads instead of directory scans
- schema evolution
- partition evolution
- time travel
- optimistic commit model
- manifest-based planning

So `v1` is not primitive. It is already a serious lakehouse table format.

## 4. What V2 Adds

The most important practical `v2` addition is row-level delete support.

That means the table can represent change semantics without rewriting every affected data file immediately.

Important `v2` shifts include:

- delete files become part of the table model
- sequence numbers become central
- manifest lists become required
- metadata requirements become stricter for writers
- snapshot and manifest structures carry richer planning information

This is why `v2` is not just “same thing but newer.”

It changes how mutations and planning work.

## 5. What V1 Metadata Typically Looks Like

In `v1` style thinking:

- table metadata is simpler
- snapshot `sequence-number` is not part of the original required model
- manifest list fields are less expressive
- `data_file.content` is effectively data only
- row-level delete semantics are not supported

So a `v1` table is usually best aligned with:

- append-heavy data
- batch-oriented pipelines
- low mutation workloads
- broad reader compatibility requirements

## 6. What Changes In V2 Metadata

In `v2`, the metadata model becomes more explicit and more disciplined.

Examples of practical changes:

- table metadata has `last-sequence-number`
- snapshots include `sequence-number`
- manifest lists become required rather than optional convenience
- manifest list records include content type and sequence information
- manifest entries can inherit sequence-related values
- `data_file.content` distinguishes data from delete file categories

That richer model is what allows the planner to answer more complex questions safely.

## 7. Why Sequence Numbers Matter So Much In V2

Many people first think sequence numbers are just another ID.

That is wrong.

Sequence numbers are important because they help determine:

- relative age of file content
- whether delete files apply to particular data files
- how retries can preserve correctness while avoiding full manifest rewrites

This is one reason `v2` is operationally more subtle than `v1`.

## 8. V1 Versus V2 By Workload Shape

Use `v1` thinking when the workload is mainly:

- append-only ingestion
- periodic batch replacement at coarse grain
- low mutation pressure
- wide engine compatibility across older readers

Use `v2` thinking when the workload needs:

- row-level deletes or updates
- more advanced write semantics
- stronger mutation support in supported engines
- more sophisticated planning behavior

## 9. Read, Write, Merge: What Actually Changes

This is the practical question many engineers really mean:

- what can I read on `v1`
- what can I write on `v1`
- what usually needs `v2`

The simplified answer is:

- `v1` is fully usable for reads
- `v1` is fully usable for append and many overwrite-style writes
- `v2` is the normal requirement for row-level mutation semantics such as delete and merge-style updates

More operationally:

```text
Operation / Expectation              V1                              V2
----------------------------------   ------------------------------  --------------------------------------------
Read current snapshot                Yes                             Yes
Time travel read                     Yes                             Yes
Append write                         Yes                             Yes
Partition-scoped overwrite           Yes                             Yes
Compaction / file rewrite            Yes                             Yes
Row-level delete semantics           No                              Yes
Merge-driven row updates             Generally no                    Yes, when supported by engine implementation
Delete-file planning                 No                              Yes
```

Important nuance:

- `v2` does not magically guarantee every engine supports every mutation equally well
- `v1` does not mean read-only; it still supports real write workloads, especially append-heavy analytics

So the correct short version is not:

- `v1` read only, `v2` write

The correct short version is:

- `v1` = read plus standard analytic writes
- `v2` = read plus standard analytic writes plus row-level mutation model

## 10. A Simple Comparison Table

```text
Concern                           V1                                V2
-------------------------------   --------------------------------  -------------------------------------------
Core analytic snapshots           Yes                               Yes
Schema evolution                  Yes                               Yes
Partition evolution               Yes                               Yes
Manifest list required            No                                Yes
Row-level delete semantics        No                                Yes
Sequence-number model             Minimal/defaulted                 Central to planning and mutation semantics
Delete files                      No                                Yes
Best fit                          Append-heavy analytics            Append + mutation-aware analytics
```

## 11. Reader And Writer Compatibility Reality

Another important detail:

- a newer engine can often read older `v1` metadata
- a `v2` table may still contain older metadata artifacts where the spec allows compatibility defaults

That is why upgrades do not always require rewriting the full metadata tree.

But the reverse is not safe as a general assumption:

- an older `v1`-only reader cannot be expected to correctly understand `v2` mutation semantics

So for platform architecture, the real compatibility question is always:

- what is the minimum feature set every important engine in the estate can read and write safely

## 12. Where V3 Fits

`v3` extends the spec again.

Representative capabilities in the spec include:

- additional type support
- default values
- row lineage support
- binary deletion vectors
- encryption-related extensions

Architecturally, `v3` means the table format keeps evolving beyond the original `v1/v2` mental model.

But for most platform teams the practical first question is still:

- do we need `v1` simplicity and compatibility
- or do we need `v2` mutation semantics

## 13. Upgrade Reality

Upgrading the table format does not mean rewriting every old file immediately.

One of Iceberg's strengths is that newer tables can still contain older metadata artifacts where compatible.

That is why the ecosystem can support upgrades without a total table rebuild.

But do not confuse that with universal engine support.

The real question is always:

- does every important writer and reader in the platform support the specific table features we intend to use

## 14. Architect Rule

Do not choose `v2` because it sounds more advanced.

Choose `v2` because the platform genuinely needs the semantics and the engines can support them.

Do not choose `v1` because it feels safer.

Choose `v1` when the workload is truly append-oriented and broad compatibility matters more than mutation richness.