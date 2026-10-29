# Architecture

## Target Shape

One strong target design is:

1. raw CDC append-only table for replay and debugging
2. current-state orders table maintained with merge semantics
3. Type 2 customer table for historical attribute changes
4. scheduled compaction and snapshot cleanup after mutation-heavy cycles

## Why This Shape Works

- replay and serving concerns are separated
- current truth is modeled explicitly
- Type 2 logic only exists where time-aware attributes matter
- maintenance is aligned to write behavior instead of guessed later

## Anti-Patterns This Design Avoids

1. deleting source history after merge
2. mixing current-state rows and historical rows in one consumer-facing contract
3. assuming merge-heavy tables do not need compaction or retention review