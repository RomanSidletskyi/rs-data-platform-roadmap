# Architecture

## Reference Shape

1. MinIO stores all table metadata and data files
2. Nessie stores branch and commit lineage for catalog objects
3. Spark uses one catalog name with branch-aware operations
4. `main` remains the accepted shared reference
5. each change uses one temporary `dev_<change>` branch

## Why This Shape Is Used

- logical isolation happens in the control plane
- promotion is reviewable
- storage layout does not explode into fake environment branches