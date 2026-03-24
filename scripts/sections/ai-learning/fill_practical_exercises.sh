#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="ai-learning-fill-practical-exercises"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/ai-learning/practical-exercises"

write_file_safe "$SECTION_ROOT/README.md" <<'EOF'
# AI Practical Exercises
EOF

write_file_safe "$SECTION_ROOT/01_ai_python_refactor/README.md" <<'EOF'
# AI Python Refactor
EOF

write_file_safe "$SECTION_ROOT/02_ai_sql_generation/README.md" <<'EOF'
# AI SQL Generation
EOF

write_file_safe "$SECTION_ROOT/03_ai_pipeline_design/README.md" <<'EOF'
# AI Pipeline Design
EOF

write_file_safe "$SECTION_ROOT/04_ai_code_review/README.md" <<'EOF'
# AI Code Review
EOF

write_file_safe "$SECTION_ROOT/05_ai_research_and_tool_comparison/README.md" <<'EOF'
# AI Research And Tool Comparison
EOF

write_file_safe "$SECTION_ROOT/06_ai_technical_writing/README.md" <<'EOF'
# AI Technical Writing
EOF

write_file_safe "$SECTION_ROOT/07_ai_english_for_developers/README.md" <<'EOF'
# AI English For Developers
EOF
