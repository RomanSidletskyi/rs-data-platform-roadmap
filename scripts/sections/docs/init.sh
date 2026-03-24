#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="docs-init"
REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
SECTION_ROOT="$REPO_ROOT/docs"

log "Creating docs structure..."

ensure_dir "$SECTION_ROOT"

ensure_dir "$SECTION_ROOT/ai-templates_for_new_chat"
ensure_dir "$SECTION_ROOT/datasets/raw/json"
ensure_dir "$SECTION_ROOT/datasets/raw/parquet"
ensure_dir "$SECTION_ROOT/architecture"
ensure_dir "$SECTION_ROOT/architecture/01_foundations"
ensure_dir "$SECTION_ROOT/architecture/02_batch_architecture"
ensure_dir "$SECTION_ROOT/architecture/03_streaming_architecture"
ensure_dir "$SECTION_ROOT/architecture/04_lakehouse_architecture"
ensure_dir "$SECTION_ROOT/architecture/05_serving_and_bi_architecture"
ensure_dir "$SECTION_ROOT/architecture/06_data_governance_security"
ensure_dir "$SECTION_ROOT/architecture/07_scalability_reliability"
ensure_dir "$SECTION_ROOT/architecture/08_cost_performance_tradeoffs"
ensure_dir "$SECTION_ROOT/architecture/09_architecture_case_studies"
ensure_dir "$SECTION_ROOT/architecture/adr"
ensure_dir "$SECTION_ROOT/case-studies"
ensure_dir "$SECTION_ROOT/system-design"
ensure_dir "$SECTION_ROOT/trade-offs"


ensure_gitkeep "$SECTION_ROOT/ai-templates_for_new_chat"
ensure_gitkeep "$SECTION_ROOT/datasets/raw/json"
ensure_gitkeep "$SECTION_ROOT/datasets/raw/parquet"
ensure_gitkeep "$SECTION_ROOT/architecture"
ensure_gitkeep "$SECTION_ROOT/architecture/01_foundations"
ensure_gitkeep "$SECTION_ROOT/architecture/02_batch_architecture"
ensure_gitkeep "$SECTION_ROOT/architecture/03_streaming_architecture"
ensure_gitkeep "$SECTION_ROOT/architecture/04_lakehouse_architecture"
ensure_gitkeep "$SECTION_ROOT/architecture/05_serving_and_bi_architecture"
ensure_gitkeep "$SECTION_ROOT/architecture/06_data_governance_security"
ensure_gitkeep "$SECTION_ROOT/architecture/07_scalability_reliability"
ensure_gitkeep "$SECTION_ROOT/architecture/08_cost_performance_tradeoffs"
ensure_gitkeep "$SECTION_ROOT/architecture/09_architecture_case_studies"
ensure_gitkeep "$SECTION_ROOT/architecture/adr"
ensure_gitkeep "$SECTION_ROOT/case-studies"
ensure_gitkeep "$SECTION_ROOT/system-design"
ensure_gitkeep "$SECTION_ROOT/trade-offs"


log "Docs structure initialized."