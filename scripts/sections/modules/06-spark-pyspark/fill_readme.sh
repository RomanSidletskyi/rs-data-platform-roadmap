#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="06-spark-pyspark-fill-readme"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "06-spark-pyspark")"
TEMPLATE_FILE="$SCRIPT_DIR/template_snapshot/README.md"

log "Creating 06-spark-pyspark README..."

if [[ ! -f "$TEMPLATE_FILE" ]]; then
  fail "Missing README template snapshot at $TEMPLATE_FILE"
fi

cp "$TEMPLATE_FILE" "$MODULE/README.md"

log "06-spark-pyspark README created."