#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="docs-fill-case-studies"
REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
SECTION_ROOT="$REPO_ROOT/docs/case-studies"


log "Creating nested  files for case studies subdirectories..."

########################################
# docs/case-studies
########################################

cat <<'EOF' > "$SECTION_ROOT/README.md"
# Case Studies

This section contains architecture case studies and design breakdowns.

The goal is to learn architecture by analyzing real or realistic systems.

## Suggested Topics

- streaming event platform
- batch lakehouse platform
- analytics serving architecture
- startup data stack
- enterprise multi-team data platform
EOF

cat << 'EOF' > "$SECTION_ROOT/case-study-template.md"
# Case Study Title

## Background

Describe the business or technical context.

## Problem

Describe the data challenge.

## Architecture Overview

Describe the main components and data flow.

## Technologies Used

List the tools used in the system.

## Trade-Offs

Describe benefits and drawbacks.

## Lessons Learned

Summarize what this case study taught you.
EOF


log "Case studies docs created successfully."