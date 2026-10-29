# Requirements

## Functional Requirements

- Spark must be able to create and write the Iceberg tables through Glue catalog
- raw order events must remain replayable
- current-state order table must support late corrections and deletes
- customer history must support Type 2 style historical analysis
- at least one additional engine should be able to read curated tables through the same catalog

## Non-Functional Requirements

- table grain and contract must be explicit
- maintenance and retention must be designed up front
- compatibility assumptions must be written down
- cost and small-file risks must be acknowledged

## Design Constraints

- do not hide business history and current-state semantics in one ambiguous table
- do not assume every engine supports every mutation feature equally well
- do not defer cleanup policy until after production slowdown appears