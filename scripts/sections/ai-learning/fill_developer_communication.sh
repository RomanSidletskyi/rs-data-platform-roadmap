#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="ai-learning-fill-developer-communication"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/ai-learning/developer-communication"

write_file_safe "$SECTION_ROOT/README.md" <<'EOF'
# Developer Communication
EOF

write_file_safe "$SECTION_ROOT/writing-better-issues.md" <<'EOF'
# Writing Better Issues
EOF

write_file_safe "$SECTION_ROOT/writing-pr-descriptions.md" <<'EOF'
# Writing PR Descriptions
EOF

write_file_safe "$SECTION_ROOT/architecture-notes.md" <<'EOF'
# Architecture Notes
EOF

write_file_safe "$SECTION_ROOT/design-review-communication.md" <<'EOF'
# Design Review Communication
EOF

write_file_safe "$SECTION_ROOT/speaking-about-systems.md" <<'EOF'
# Speaking About Systems
EOF

write_file_safe "$SECTION_ROOT/issue-writing-comparison.md" <<'EOF'
# Issue Writing Comparison
EOF

write_file_safe "$SECTION_ROOT/pr-description-comparison.md" <<'EOF'
# PR Description Comparison
EOF

write_file_safe "$SECTION_ROOT/adr-comparison.md" <<'EOF'
# ADR Comparison
EOF

write_file_safe "$SECTION_ROOT/review-communication-comparison.md" <<'EOF'
# Review Communication Comparison
EOF

write_file_safe "$SECTION_ROOT/speaking-explanation-comparison.md" <<'EOF'
# Speaking Explanation Comparison
EOF

write_file_safe "$SECTION_ROOT/comparisons-by-context.md" <<'EOF'
# Communication By Context
EOF

write_file_safe "$SECTION_ROOT/practice/README.md" <<'EOF'
# Developer Communication Practice
EOF

write_file_safe "$SECTION_ROOT/practice/issue-writing-exercise.md" <<'EOF'
# Issue Writing Exercise
EOF

write_file_safe "$SECTION_ROOT/practice/pr-description-exercise.md" <<'EOF'
# PR Description Exercise
EOF

write_file_safe "$SECTION_ROOT/practice/adr-exercise.md" <<'EOF'
# ADR Exercise
EOF

write_file_safe "$SECTION_ROOT/practice/review-reply-exercise.md" <<'EOF'
# Review Reply Exercise
EOF

write_file_safe "$SECTION_ROOT/practice/speaking-about-systems-exercise.md" <<'EOF'
# Speaking About Systems Exercise
EOF

write_file_safe "$SECTION_ROOT/practice/examples/README.md" <<'EOF'
# Developer Communication Examples
EOF

write_file_safe "$SECTION_ROOT/practice/examples/issue-writing-example.md" <<'EOF'
# Issue Writing Example
EOF

write_file_safe "$SECTION_ROOT/practice/examples/pr-description-example.md" <<'EOF'
# PR Description Example
EOF

write_file_safe "$SECTION_ROOT/practice/examples/adr-example.md" <<'EOF'
# ADR Example
EOF

write_file_safe "$SECTION_ROOT/practice/examples/review-reply-example.md" <<'EOF'
# Review Reply Example
EOF

write_file_safe "$SECTION_ROOT/practice/examples/speaking-about-systems-example.md" <<'EOF'
# Speaking About Systems Example
EOF