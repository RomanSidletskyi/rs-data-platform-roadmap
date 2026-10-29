# Architecture

## Target Shape

One strong target design is:

1. S3 raw landing zone for append-only source files
2. Glue catalog as metadata authority for Iceberg tables
3. Spark as primary writer for raw, curated, and history layers
4. append-only raw events table for replay and audit-style debugging
5. current-state orders fact table maintained through mutation-aware merges
6. Type 2 customer history table for business-valid attribute history
7. scheduled maintenance layer for compaction and retention

## Why This Shape Works

- raw history stays replayable
- current-state serving stays explicit
- history modeling is isolated to the table that truly needs it
- Glue centralizes metadata resolution across engines
- maintenance becomes part of the platform design instead of afterthought cleanup

## Layer Boundaries

Raw layer:

- append-only
- replayable
- not the final serving contract

Curated fact layer:

- one accepted current row per business fact grain
- updated by CDC-aware merge logic

Historical dimension layer:

- multiple rows per business key over time
- explicit validity model

## Anti-Patterns This Design Avoids

1. serving raw CDC directly to business consumers
2. using one table for event history, current truth, and Type 2 history simultaneously
3. treating Glue as just a config string instead of a control-plane dependency
4. ignoring maintenance until query latency becomes a crisis