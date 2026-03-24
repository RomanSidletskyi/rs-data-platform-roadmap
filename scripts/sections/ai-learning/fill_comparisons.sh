#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="ai-learning-fill-comparisons"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/ai-learning/comparisons"

write_file_safe "$SECTION_ROOT/README.md" <<'EOF'
# AI Comparisons
EOF

write_file_safe "$SECTION_ROOT/ai-tools-by-task.md" <<'EOF'
# AI Tools By Task
EOF

write_file_safe "$SECTION_ROOT/language-tools-by-task.md" <<'EOF'
# Language Tools By Task
EOF

write_file_safe "$SECTION_ROOT/best-stacks-by-scenario.md" <<'EOF'
# Best Stacks By Scenario
EOF