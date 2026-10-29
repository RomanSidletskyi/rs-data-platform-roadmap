# 01 Iceberg Metadata And Table State

## Overview

These tasks train the learner to think about an Iceberg table as explicit metadata state, not as a folder of parquet files.

The main goal is not only to memorize terms like snapshot or manifest.

The main goal is to learn how to reason from:

- metadata root
- current snapshot
- manifest list
- manifests
- data and delete files

---

## Task 1 - Identify The Current Table State From Metadata

### Goal

Explain how to identify the current state of an Iceberg table.

### Input

You are given a table with:

- current metadata file `000120-7f5c.metadata.json`
- `current-snapshot-id = 918273645546372820`
- snapshot entry pointing to `snap-918273645546372820-1-9c77.avro`

### Requirements

- explain which file you inspect first
- explain how you find the current snapshot
- explain what object you open next after the snapshot entry

### Expected Output

- one ordered explanation in 4 to 6 steps

### Extra Challenge

Explain why looking only at the newest parquet file in storage is not a reliable way to identify the current table state.

---

## Task 2 - Distinguish Manifest List Versus Manifest

### Goal

Explain the role of manifest list and manifest files.

### Input

You are told:

- `snap-701.avro` references two files
- `manifest-a1.avro` contains entries for data files
- `manifest-del-91.avro` contains entries for delete files

### Requirements

- describe what the manifest list does
- describe what each manifest does
- explain why these layers are separated instead of storing everything in one flat file

### Expected Output

- one comparison with 3 to 5 bullets per layer

### Extra Challenge

Explain which layer you would inspect first when debugging an unexpected delete-heavy snapshot.

---

## Task 3 - Choose V1 Versus V2 For A Table Contract

### Goal

Choose the right format version.

### Input

Scenario A:

- append-only event log
- no row-level corrections

Scenario B:

- current-state customer table
- late corrections and deletes by business key

### Requirements

- choose `v1` or `v2` for each scenario
- justify each choice in 3 to 5 bullets
- explain one risk of choosing `v2` without a real mutation need

### Expected Output

- two decisions
- two justifications

### Extra Challenge

Explain why `v1` is not the same thing as read-only.

---

## Task 4 - Explain What A Commit Rebuilds

### Goal

Describe the metadata artifacts created by a normal append commit.

### Input

One new parquet file is appended to an Iceberg table.

### Requirements

- list the main new artifacts created by the commit
- explain the order in which they conceptually appear
- explain what the catalog pointer changes to

### Expected Output

- one ordered list of commit artifacts
- one short pointer explanation

### Extra Challenge

Add one sentence explaining what stays reusable from older metadata after the commit.

---

## Task 5 - Explain Equality Delete Versus Position Delete

### Goal

Compare the two main delete styles.

### Input

Case 1:

- upstream sends delete tombstones by `order_id`

Case 2:

- engine knows exact file path and row position to delete

### Requirements

- choose equality delete or position delete for each case
- explain the difference in identity model
- explain why both still depend on metadata-driven planning

### Expected Output

- two choices
- one comparison paragraph

### Extra Challenge

Explain why a logical delete does not mean the original parquet file disappears immediately.

---

## Task 6 - Trace A Table State By Hand

### Goal

Write the shortest possible manual trace from catalog entry to data file.

### Input

Available information:

- catalog points to `000121-a9b4.metadata.json`
- current snapshot points to `snap-702.avro`
- manifest list points to `manifest-a2.avro`
- manifest entry points to `data/2026/03/27/00000-35-1e8d.parquet`

### Requirements

- write the exact trace chain in order
- explain in one sentence what each step contributes

### Expected Output

- one 4-step chain
- one short explanation sentence per step

### Extra Challenge

Explain which step you would compare first if two engines appear to see different row sets.