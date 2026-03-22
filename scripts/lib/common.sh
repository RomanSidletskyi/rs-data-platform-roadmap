#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${SCRIPT_NAME:-}" ]]; then
  SCRIPT_NAME="$(basename "${BASH_SOURCE[0]:-script}")"
fi

log() {
  printf '[%s] INFO  %s\n' "$SCRIPT_NAME" "$1"
}

warn() {
  printf '[%s] WARN  %s\n' "$SCRIPT_NAME" "$1"
}

error() {
  printf '[%s] ERROR %s\n' "$SCRIPT_NAME" "$1" >&2
}

die() {
  error "$1"
  exit 1
}