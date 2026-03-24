#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/common.sh"

SCRIPT_NAME="bootstrap-all"

SPECIAL_SECTIONS=(
	docs
	shared
	ai-learning
	real-projects
)

log "Bootstrapping repository sections..."

for section in "${SPECIAL_SECTIONS[@]}"; do
	bash "$SCRIPT_DIR/bootstrap_section.sh" "$section"
done

log "Bootstrapping all script-backed modules..."

shopt -s nullglob
for module_dir in "$SCRIPT_DIR"/sections/modules/*; do
	if [[ -d "$module_dir" ]]; then
		bash "$SCRIPT_DIR/bootstrap_section.sh" modules "$(basename "$module_dir")"
	fi
done
shopt -u nullglob

log "Repository bootstrap finished successfully."