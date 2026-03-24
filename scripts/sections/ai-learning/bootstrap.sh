#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"

SCRIPT_NAME="ai-learning-bootstrap"

log "Starting ai-learning bootstrap..."

bash "$SCRIPT_DIR/init.sh"
bash "$SCRIPT_DIR/fill_readme.sh"
bash "$SCRIPT_DIR/fill_tools.sh"
bash "$SCRIPT_DIR/fill_workflows.sh"
bash "$SCRIPT_DIR/fill_prompting_guides.sh"
bash "$SCRIPT_DIR/fill_practical_exercises.sh"
bash "$SCRIPT_DIR/fill_comparisons.sh"
bash "$SCRIPT_DIR/fill_language_learning.sh"
bash "$SCRIPT_DIR/fill_anti_patterns.sh"
bash "$SCRIPT_DIR/fill_developer_communication.sh"

log "AI-learning bootstrap finished successfully."
