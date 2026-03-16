#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/bootstrap_section.sh" docs
bash "$SCRIPT_DIR/bootstrap_section.sh" shared
bash "$SCRIPT_DIR/bootstrap_section.sh" ai-learning
bash "$SCRIPT_DIR/bootstrap_section.sh" modules 01-python
bash "$SCRIPT_DIR/bootstrap_section.sh" modules 02-sql
bash "$SCRIPT_DIR/bootstrap_section.sh" real-projects