#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="ai-learning-fill-tools"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/ai-learning/tools"

write_file_safe "$SECTION_ROOT/README.md" <<'EOF'
# AI Tools

Use this directory as a tool catalog for learning, development, research, and writing.
EOF

write_file_safe "$SECTION_ROOT/github-copilot.md" <<'EOF'
# GitHub Copilot
EOF

write_file_safe "$SECTION_ROOT/chatgpt.md" <<'EOF'
# ChatGPT
EOF

write_file_safe "$SECTION_ROOT/cursor-ide.md" <<'EOF'
# Cursor IDE
EOF

write_file_safe "$SECTION_ROOT/codeium.md" <<'EOF'
# Codeium
EOF

write_file_safe "$SECTION_ROOT/ai-data-tools.md" <<'EOF'
# AI Data Tools
EOF

write_file_safe "$SECTION_ROOT/claude.md" <<'EOF'
# Claude
EOF

write_file_safe "$SECTION_ROOT/perplexity.md" <<'EOF'
# Perplexity
EOF

write_file_safe "$SECTION_ROOT/gemini.md" <<'EOF'
# Gemini
EOF

write_file_safe "$SECTION_ROOT/notebooklm.md" <<'EOF'
# NotebookLM
EOF

write_file_safe "$SECTION_ROOT/deepl.md" <<'EOF'
# DeepL
EOF

write_file_safe "$SECTION_ROOT/grammarly.md" <<'EOF'
# Grammarly And Similar Writing Tools
EOF

write_file_safe "$SECTION_ROOT/reverso-context.md" <<'EOF'
# Reverso Context
EOF

write_file_safe "$SECTION_ROOT/language-reactor.md" <<'EOF'
# Language Reactor
EOF

write_file_safe "$SECTION_ROOT/anki.md" <<'EOF'
# Anki
EOF

write_file_safe "$SECTION_ROOT/elsa-speak.md" <<'EOF'
# ELSA Speak
EOF
