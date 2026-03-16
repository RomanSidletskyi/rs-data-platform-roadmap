#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <section> [name]"
  exit 1
fi

SECTION="$1"
NAME="${2:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECTIONS_DIR="$SCRIPT_DIR/sections"

case "$SECTION" in
  modules)

    if [ -z "$NAME" ]; then
      echo "[ERROR] modules requires module name"
      exit 1
    fi

    MODULE_DIR="$SECTIONS_DIR/modules/$NAME"

    if [ ! -d "$MODULE_DIR" ]; then
      echo "[ERROR] module scripts not found: $MODULE_DIR"
      exit 1
    fi

    bash "$MODULE_DIR/bootstrap.sh"
    ;;

  docs|shared|real-projects|ai-learning)

    SECTION_DIR="$SECTIONS_DIR/$SECTION"

    if [ ! -d "$SECTION_DIR" ]; then
      echo "[ERROR] section scripts not found: $SECTION_DIR"
      exit 1
    fi

    bash "$SECTION_DIR/bootstrap.sh"
    ;;

  *)

    echo "[ERROR] unsupported section: $SECTION"
    exit 1

    ;;

esac