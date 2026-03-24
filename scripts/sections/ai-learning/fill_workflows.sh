#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="ai-learning-fill-workflows"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/ai-learning/workflows"

write_file_safe "$SECTION_ROOT/README.md" <<'EOF'
# AI Workflows
EOF

write_file_safe "$SECTION_ROOT/how-to-learn-faster.md" <<'EOF'
# How To Learn Faster
EOF

write_file_safe "$SECTION_ROOT/learn-a-module-with-ai.md" <<'EOF'
# Learn A Module With AI
EOF

write_file_safe "$SECTION_ROOT/ai-pair-programming.md" <<'EOF'
# AI Pair Programming
EOF

write_file_safe "$SECTION_ROOT/ai-for-debugging.md" <<'EOF'
# AI For Debugging
EOF

write_file_safe "$SECTION_ROOT/ai-for-project-design.md" <<'EOF'
# AI For Project Design
EOF

write_file_safe "$SECTION_ROOT/ai-for-research.md" <<'EOF'
# AI For Research
EOF

write_file_safe "$SECTION_ROOT/ai-for-technical-writing.md" <<'EOF'
# AI For Technical Writing
EOF

write_file_safe "$SECTION_ROOT/english-for-developers.md" <<'EOF'
# English For Developers
EOF

write_file_safe "$SECTION_ROOT/issue-triage-with-ai.md" <<'EOF'
# Issue Triage With AI
EOF

write_file_safe "$SECTION_ROOT/pr-review-replies-and-followups.md" <<'EOF'
# PR Review Replies And Follow-Ups
EOF

write_file_safe "$SECTION_ROOT/adr-writing-with-ai.md" <<'EOF'
# ADR Writing With AI
EOF

write_file_safe "$SECTION_ROOT/design-review-prep.md" <<'EOF'
# Design Review Prep
EOF

write_file_safe "$SECTION_ROOT/interview-speaking-practice.md" <<'EOF'
# Interview Speaking Practice
EOF
