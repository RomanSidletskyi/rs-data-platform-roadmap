#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="ai-learning-fill-language-learning"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/ai-learning/language-learning"

write_file_safe "$SECTION_ROOT/README.md" <<'EOF'
# Language Learning For Developers
EOF

write_file_safe "$SECTION_ROOT/english-for-developers-stack.md" <<'EOF'
# English For Developers Stack
EOF

write_file_safe "$SECTION_ROOT/daily-and-weekly-routine.md" <<'EOF'
# Daily And Weekly Routine
EOF

write_file_safe "$SECTION_ROOT/tool-catalog.md" <<'EOF'
# Language Tool Catalog
EOF