#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="ai-learning-fill-anti-patterns"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/ai-learning/anti-patterns"

write_file_safe "$SECTION_ROOT/README.md" <<'EOF'
# AI Anti-Patterns
EOF

write_file_safe "$SECTION_ROOT/common-ai-failures.md" <<'EOF'
# Common AI Failures
EOF