#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="ai-learning-init"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/ai-learning"

log "Creating ai-learning structure..."

ensure_dir "$SECTION_ROOT"
ensure_dir "$SECTION_ROOT/tools"
ensure_dir "$SECTION_ROOT/workflows"
ensure_dir "$SECTION_ROOT/prompting-guides"
ensure_dir "$SECTION_ROOT/practical-exercises"
ensure_dir "$SECTION_ROOT/comparisons"
ensure_dir "$SECTION_ROOT/language-learning"
ensure_dir "$SECTION_ROOT/anti-patterns"
ensure_dir "$SECTION_ROOT/developer-communication"
ensure_dir "$SECTION_ROOT/developer-communication/practice"
ensure_dir "$SECTION_ROOT/developer-communication/practice/examples"

ensure_dir "$SECTION_ROOT/practical-exercises/01_ai_python_refactor"
ensure_dir "$SECTION_ROOT/practical-exercises/02_ai_sql_generation"
ensure_dir "$SECTION_ROOT/practical-exercises/03_ai_pipeline_design"
ensure_dir "$SECTION_ROOT/practical-exercises/04_ai_code_review"
ensure_dir "$SECTION_ROOT/practical-exercises/05_ai_research_and_tool_comparison"
ensure_dir "$SECTION_ROOT/practical-exercises/06_ai_technical_writing"
ensure_dir "$SECTION_ROOT/practical-exercises/07_ai_english_for_developers"

log "AI-learning structure initialized."
