#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="06-spark-pyspark-fill-pet-projects"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "06-spark-pyspark")"
TEMPLATE_DIR="$SCRIPT_DIR/template_snapshot/pet-projects"

log "Filling 06-spark-pyspark pet projects..."

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  fail "Missing pet projects template snapshot at $TEMPLATE_DIR"
fi

rm -rf "$MODULE/pet-projects"
cp -R "$TEMPLATE_DIR" "$MODULE/pet-projects"

log "06-spark-pyspark pet projects created."