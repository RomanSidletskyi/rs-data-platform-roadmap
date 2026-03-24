#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd "$script_dir/.." && pwd)"

log_file_input="${1:-${LOG_FILE:-data/sample_incident.log}}"
max_lines="${MAX_ERROR_LINES:-20}"

if [[ "$log_file_input" = /* ]]; then
	log_file="$log_file_input"
else
	log_file="$project_root/$log_file_input"
fi

echo "== Error and warning lines =="
grep -niE 'error|warn|timeout|exception' "$log_file" | head -n "$max_lines" || true

echo
echo "== Frequent failing components =="
grep -oE 'api|worker|scheduler|database' "$log_file" | sort | uniq -c | sort -nr || true