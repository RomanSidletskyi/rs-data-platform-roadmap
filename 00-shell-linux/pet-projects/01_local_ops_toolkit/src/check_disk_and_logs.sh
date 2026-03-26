#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd "$script_dir/.." && pwd)"

target_dir="${1:-${TARGET_DIR:-$project_root}}"
log_file_input="${2:-${LOG_FILE:-data/sample_app.log}}"

if [[ "$log_file_input" = /* ]]; then
	log_file="$log_file_input"
else
	log_file="$project_root/$log_file_input"
fi

echo "== Disk usage summary =="
du -sh "$target_dir"/* 2>/dev/null | sort -h | tail -n 10 || true

echo
echo "== Log level counts =="
grep -oE 'INFO|WARN|ERROR' "$log_file" | sort | uniq -c | sort -nr || true