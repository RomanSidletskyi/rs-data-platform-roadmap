#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/create_module.sh <NN-module-name>
  ./scripts/create_module.sh 16-cloud-databases/<NN-database-name>

Creates a one-time folder scaffold. It does not create generator scripts or
snapshots, and it never overwrites an existing module.
EOF
}

fail() {
  printf '[create-module] ERROR: %s\n' "$1" >&2
  exit 1
}

[[ $# -eq 1 ]] || { usage >&2; exit 1; }
MODULE_PATH="$1"

if [[ ! "$MODULE_PATH" =~ ^[0-9]{2}-[a-z0-9]+(-[a-z0-9]+)*$ && ! "$MODULE_PATH" =~ ^16-cloud-databases/[0-9]{2}-[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  usage >&2
  fail "Module path must use NN-kebab-case; nested modules are allowed only under 16-cloud-databases/"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"

if [[ "$MODULE_PATH" == */* && ! -d "$REPO_ROOT/16-cloud-databases" ]]; then
  fail "The 16-cloud-databases container does not exist"
fi

TARGET="$REPO_ROOT/$MODULE_PATH"
[[ ! -e "$TARGET" && ! -L "$TARGET" ]] || fail "Target already exists: $MODULE_PATH"

MODULE_NAME="${MODULE_PATH##*/}"
DISPLAY_NAME="${MODULE_NAME//-/ }"
mkdir -p "$TARGET/learning-materials" "$TARGET/simple-tasks" "$TARGET/pet-projects"

cat > "$TARGET/README.md" <<EOF
# $DISPLAY_NAME

## Purpose

Describe what this module teaches and where it fits in the repository learning path.

## Learning Materials

Add an ordered route through the concepts, references, and architecture topics.

## Practice

Add focused tasks and guided projects after the learning material is ready.
EOF

cat > "$TARGET/learning-materials/README.md" <<'EOF'
# Learning Materials

Use this page to organize the module's concepts, practical references, detailed guides, and architecture material.
EOF

cat > "$TARGET/simple-tasks/README.md" <<'EOF'
# Simple Tasks

Create focused exercises here. Put self-check solutions in `solution.md` files; learner exports omit those answers.
EOF

cat > "$TARGET/pet-projects/README.md" <<'EOF'
# Pet Projects

Add guided projects here. Keep solved comparison implementations in `reference_example_*` folders so learner exports can identify them.
EOF

cat > "$TARGET/PROGRESS.md" <<'EOF'
# Module Progress

- overall: [x] not started | [ ] in progress | [ ] done
- total estimated: -
- total spent: 0h
- last updated: -
- current focus: -

Update this learner-managed file as study progresses.
EOF

printf '[create-module] Created scaffold: %s\n' "$MODULE_PATH"
printf '[create-module] Source of truth is the live module; no snapshots or generators were created.\n'