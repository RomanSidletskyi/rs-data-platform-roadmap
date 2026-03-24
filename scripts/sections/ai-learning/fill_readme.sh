#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="ai-learning-fill-readme"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/ai-learning"

write_file_safe "$SECTION_ROOT/README.md" <<'EOF'
# AI Learning

This section is a structured system for accelerated learning, AI-assisted development, research, writing, and English-for-developers.
EOF