# Scripts Structure

```text
scripts/
├── README.md
├── check_repo.sh
├── create_module.sh
├── export_learner_pack.sh
└── learner_export_excludes.txt
```

## Responsibilities

- `create_module.sh` creates a one-time live folder scaffold for a numbered module or a nested database module under `16-cloud-databases/`.
- `check_repo.sh` validates repository structure or runs foundational starter checks; it does not regenerate content.
- `export_learner_pack.sh` creates an external learner copy without answers or solved implementations.
- `learner_export_excludes.txt` lists completed projects whose full directories should be omitted from learner copies.

The live module and section directories are the only content source of truth. No per-module snapshots or content-sync generators are used.
