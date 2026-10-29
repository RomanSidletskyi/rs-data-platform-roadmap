# Architecture

## Target Shape

One strong target design is:

1. MinIO as the object store for warehouse files
2. Nessie as the catalog and reference control plane
3. Spark as the main writer and validation engine
4. `main` branch for accepted publish state
5. short-lived `dev_<change>` branches for experimental writes
6. explicit compare-and-promote step before merging to main

## Why This Shape Works

- storage stays cheap and simple
- branch semantics stay in the catalog instead of being faked with path names
- Spark can validate the same logical tables on different references
- promotion logic is visible instead of implicit

## Anti-Patterns This Design Avoids

1. simulating branches with separate bucket prefixes only
2. letting every engineer write straight to main
3. hiding publish review inside ad hoc manual checks
4. confusing time travel with a controlled promotion workflow