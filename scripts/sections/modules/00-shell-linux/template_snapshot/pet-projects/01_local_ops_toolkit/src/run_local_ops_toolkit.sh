#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd "$script_dir/.." && pwd)"

target_dir="${1:-${TARGET_DIR:-$project_root}}"
log_file_input="${LOG_FILE:-data/sample_app.log}"
process_filter="${PROCESS_FILTER:-python|bash|zsh}"
top_n="${TOP_N:-10}"

if [[ "$log_file_input" = /* ]]; then
	log_file="$log_file_input"
else
	log_file="$project_root/$log_file_input"
fi

echo "== Largest files under ${target_dir} =="
find "$target_dir" -maxdepth 2 -type f -exec du -h {} + 2>/dev/null | sort -h | tail -n "$top_n" || true

echo
echo "== Recent warnings and errors from ${log_file} =="
grep -niE 'warn|error|timeout|exception' "$log_file" || true

echo
echo "== Matching processes =="
ps aux | grep -E "$process_filter" | grep -v grep || true