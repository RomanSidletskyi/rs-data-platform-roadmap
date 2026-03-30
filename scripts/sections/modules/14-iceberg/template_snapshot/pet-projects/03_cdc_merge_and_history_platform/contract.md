# Contract

## Contract Boundaries

- raw CDC table is not a business-serving table
- current-state table contains one accepted row per business key at serving grain
- Type 2 table contains many rows per business key with validity semantics

## Review Questions

- which consumers need current truth only
- which consumers need historical validity windows
- which deletes should remain visible in raw history but not in serving tables