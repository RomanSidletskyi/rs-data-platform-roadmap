# Delete Files: Equality Deletes, Position Deletes, And Deletion Vectors

## 1. Why This Topic Exists

Many people hear:

- Iceberg supports deletes

and stop there.

That is not enough.

The real question is:

- how are deletes represented when the underlying data files are immutable

The answer is:

- through metadata and delete artifacts, not by editing rows in place inside parquet files

## 2. The Big Architectural Point

Iceberg is file-oriented storage with table-oriented semantics.

So when you delete rows, the platform must represent:

- which rows are no longer logically visible

without pretending parquet files behave like database pages.

That is why delete files exist.

## 3. Equality Deletes

Equality deletes identify rows by values of one or more fields.

Mental model:

- delete rows where key columns equal these values

This is useful when the writer knows row identity by business key and does not want to depend on physical row positions.

Conceptually:

```text
delete where order_id in {1001, 1002, 1003}
```

Architecturally, equality deletes are value-based logical delete instructions.

## 4. Position Deletes

Position deletes identify rows by:

- referenced data file path
- row position within that data file

Mental model:

- in file X, rows at positions 15 and 902 are logically deleted

This is more tightly coupled to physical file layout than equality deletes.

## 5. Deletion Vectors

Deletion vectors are a newer form of row-level delete representation.

Mental model:

- one compact binary structure marks deleted row positions for a referenced data file

Architecturally they improve execution characteristics compared with older position-delete style handling in newer format capabilities.

## 6. Why Deletes Need Planning Metadata

Delete artifacts are not useful unless the planner can decide:

- which delete files apply to which data files
- whether a delete artifact is older or newer relative to file content

This is why sequence numbers matter so much in mutation-aware Iceberg tables.

## 7. Equality Versus Position Deletes

Equality deletes are better when:

- business-key semantics are natural
- row identity is defined logically

Position deletes are better when:

- the engine has direct knowledge of exact file and row positions
- delete planning can exploit that physical precision

Neither one is “globally best.”

They solve different operational problems.

## 8. Why V1 And V2 Matter Here

This is one of the cleanest boundaries between `v1` and `v2` thinking.

- `v1` does not support row-level delete semantics through delete files
- `v2` introduces row-level delete modeling

So if a team wants merge-heavy or delete-heavy workflows, this is one of the main reasons they move from `v1` to `v2`.

## 9. Real Example: What Appears In A V1 Commit

Assume a `v1` table receives a normal append of one new parquet file.

A simplified file appearance looks like this:

```text
table_root/
	data/
		00000-31-a11f.parquet
	metadata/
		manifest-a1.avro
		snap-701.avro
		000007-9fa1.metadata.json
```

What happened:

1. a new data file was written
2. a new manifest was written to index that data file
3. a new manifest list was written for the snapshot
4. a new metadata root was written
5. the catalog pointer was updated to that new metadata root

What did not appear:

- no equality delete file
- no position delete file
- no delete manifest

So `v1` still creates real metadata layers on commit, but not delete-file mutation state.

## 10. Real Example: What Appears In A V2 Equality Delete Commit

Now assume a `v2` table already contains:

```text
data/00000-31-a11f.parquet
```

and we logically delete rows where `order_id in (1001, 1002)` using equality-delete semantics.

A simplified new commit may create:

```text
table_root/
	data/
		00000-31-a11f.parquet
	metadata/
		manifest-a1.avro
		delete-eq-77.parquet
		manifest-del-91.avro
		snap-702.avro
		000008-b8c2.metadata.json
```

What each new file represents:

- `delete-eq-77.parquet` = equality delete file containing values that identify rows to hide logically
- `manifest-del-91.avro` = manifest indexing that delete file
- `snap-702.avro` = manifest list for the new snapshot, now referencing reused data manifest(s) and new delete manifest(s)
- `000008-b8c2.metadata.json` = new metadata root describing the delete-aware snapshot as current

The original data file may remain physically present.

The rows become invisible because the current snapshot now includes delete semantics during planning.

## 11. Real Example: What Appears In A V2 Position Delete Commit

Assume the engine knows that rows at positions `15` and `902` in file `00000-31-a11f.parquet` must be deleted.

A simplified new commit may create:

```text
table_root/
	data/
		00000-31-a11f.parquet
	metadata/
		pos-delete-88.parquet
		manifest-del-92.avro
		snap-703.avro
		000009-c7d3.metadata.json
```

Here:

- `pos-delete-88.parquet` records referenced data file path plus row positions
- `manifest-del-92.avro` indexes the position delete file
- `snap-703.avro` records the new snapshot's manifest set
- `000009-c7d3.metadata.json` becomes the new root metadata file after commit

Again, the original data parquet file may still exist physically.

## 12. V1 Versus V2 Commit Difference In One Table

```text
Scenario                        New data file   New delete file   New manifest   New manifest list   New metadata root
-----------------------------   -------------   ---------------   ------------   -----------------   -----------------
V1 append                       Yes             No                Yes            Yes                 Yes
V2 append                       Yes             No                Yes            Yes                 Yes
V2 equality delete             No or maybe      Yes               Yes            Yes                 Yes
V2 position delete             No or maybe      Yes               Yes            Yes                 Yes
V2 merge/update                Often yes        Often yes         Yes            Yes                 Yes
```

The important difference is not only file count.

The important difference is that `v2` can create delete-aware metadata state that readers must interpret.

## 13. What A V2 Delete Commit Means Logically

After a `v2` delete commit:

- the current metadata root points to a new snapshot
- that snapshot points to a manifest list
- that manifest list includes delete manifest references
- delete manifests point to delete files
- readers use those delete files while planning and scanning

That is the real answer to:

- what happens on commit in `v2`

## 14. Why Deletes Do Not Mean Files Immediately Disappear

When a row is logically deleted, the original data file may still physically exist.

The current snapshot simply interprets visibility differently because delete artifacts are part of the planning model.

Later maintenance may:

- rewrite data files
- compact state
- physically remove obsolete artifacts after retention rules allow it

## 15. Why Merge Usually Means V2 Thinking

When people ask:

- can I do `MERGE`

they are usually asking for row-level mutation behavior.

That is why `MERGE` is generally associated with `v2` table semantics plus engine support that knows how to produce delete-aware snapshot state.

So the clean shorthand is:

- `v1` = read plus standard writes, but not delete-file mutation model
- `v2` = read plus standard writes plus mutation-aware commit model

## 16. Execution Consequence

Delete-aware reads are harder than append-only reads because the engine may need to:

- load data files
- load relevant delete files
- apply row filtering logic consistently

That is why mutation-heavy Iceberg workloads demand more from engines than append-only workloads.

## 17. Architect Rule

Delete semantics in Iceberg are metadata-driven visibility rules over immutable files.

If you remember that one sentence, most of the complexity becomes easier to place correctly.