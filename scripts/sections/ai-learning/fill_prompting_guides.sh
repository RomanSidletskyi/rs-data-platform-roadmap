#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="ai-learning-fill-prompting-guides"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/ai-learning/prompting-guides"

write_file_safe "$SECTION_ROOT/README.md" <<'EOF'
# Prompting Guides
EOF

write_file_safe "$SECTION_ROOT/learning-prompts.md" <<'EOF'
# Learning Prompts
EOF

write_file_safe "$SECTION_ROOT/debugging-prompts.md" <<'EOF'
# Debugging Prompts
EOF

write_file_safe "$SECTION_ROOT/code-review-prompts.md" <<'EOF'
# Code Review Prompts
EOF

write_file_safe "$SECTION_ROOT/architecture-prompts.md" <<'EOF'
# Architecture Prompts
EOF
