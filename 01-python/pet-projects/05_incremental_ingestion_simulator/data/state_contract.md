# State Contract

Your first implementation can track state with a simple JSON file.

## Minimum Fields

- last successful run timestamp
- processed record IDs or a hash map keyed by `record_id`
- source high-watermark if you choose timestamp-based detection

## Required Behaviors

- first run initializes state cleanly
- no-change run should not emit duplicate outputs
- changed records should be reprocessed deterministically
- state must be updated only after successful output write