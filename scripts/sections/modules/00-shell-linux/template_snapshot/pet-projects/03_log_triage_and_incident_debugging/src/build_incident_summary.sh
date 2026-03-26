#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd "$script_dir/.." && pwd)"

log_file_input="${1:-${LOG_FILE:-data/sample_incident.log}}"

if [[ "$log_file_input" = /* ]]; then
	log_file="$log_file_input"
else
	log_file="$project_root/$log_file_input"
fi

error_count="$(grep -ci 'error' "$log_file" || true)"
warn_count="$(grep -ci 'warn' "$log_file" || true)"
timeout_count="$(grep -ci 'timeout' "$log_file" || true)"

printf 'errors=%s\nwarnings=%s\ntimeouts=%s\n' "$error_count" "$warn_count" "$timeout_count"