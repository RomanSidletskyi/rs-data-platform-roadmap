# Repository Scripts

Learning materials, tasks, and projects are maintained directly in their live directories. Scripts provide a small set of one-time and validation tools; they do not generate or synchronize module content.

## Commands

Run commands from the repository root.

### Create a module scaffold

```sh
./scripts/create_module.sh 16-some-new-module
./scripts/create_module.sh 16-cloud-databases/02-bigquery
```

The command creates `README.md`, `PROGRESS.md`, `learning-materials/`, `simple-tasks/`, and `pet-projects/` once. It refuses to overwrite an existing target. After creation, edit the live files directly.

### Validate repository structure

```sh
./scripts/check_repo.sh structure
```

This checks top-level module layout and required repository entrypoints. It is read-only and does not create, copy, or regenerate learning content.

### Validate foundational starter assets

```sh
./scripts/check_repo.sh foundational
```

This smoke-tests the shell and Git practice assets in a temporary directory. It does not change global Git configuration or repository files.

### Export a learner copy

```sh
./scripts/export_learner_pack.sh --output ../rs-data-platform-roadmap-learner --dry-run
./scripts/export_learner_pack.sh --output ../rs-data-platform-roadmap-learner
```

The output path must not already exist and must be outside the repository. The exporter reads the current working tree, omits Git-ignored files, secrets, task `solution.md` files, solved `reference_example_*` directories, and completed project names listed in `learner_export_excludes.txt`. Project briefs remain; implementation code under `real-projects/` is excluded. Omitted content is represented by notices while the directory structure is retained.

## Source Of Truth

The checked-in module and section directories are the source of truth. Do not duplicate module content or add automation that overwrites live learning files. If repeated structure becomes inconvenient, improve the one-time scaffold command instead.

## Script Layout

```text
scripts/
  create_module.sh
  check_repo.sh
  export_learner_pack.sh
  learner_export_excludes.txt
  README.md
  structure.md
```

Keep new automation narrow, non-destructive, and explicit about its input and output paths.
