# Validation Notes

Use this folder for:

- schema stability checks for the publish contract
- row-count or reconciliation checks between internal mart and published output
- checks that raw lineage columns exist in the native raw layer
- notes proving that external tables are not being treated as the final semantic layer

The test logic should defend architectural boundaries, not only SQL syntax.