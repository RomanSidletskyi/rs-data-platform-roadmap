# Reference Solution Checklist

- Bronze keeps raw landed payloads without business reshaping.
- Silver applies deterministic cleanup and normalized country codes.
- Gold is rebuilt only for the affected business date during repair.
- `MERGE` is reserved for keyed corrections, not default daily replacement.
- Validation checks compare aggregates before the repaired slice is published.
