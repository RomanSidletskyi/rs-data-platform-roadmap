#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

source "$REPO_ROOT/scripts/lib/fs.sh"

MODULE="$REPO_ROOT/02-sql"

ensure_dir "$MODULE"
ensure_dir "$MODULE/learning-materials"
ensure_dir "$MODULE/simple-tasks"
ensure_dir "$MODULE/pet-projects"