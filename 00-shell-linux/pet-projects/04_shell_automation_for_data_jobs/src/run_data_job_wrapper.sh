#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd "$script_dir/.." && pwd)"

job_name="${JOB_NAME:-daily_orders_sync}"
log_file_input="${LOG_FILE:-data/sample_job_run.log}"
run_id="manual-$(date +%Y%m%d%H%M%S)"

if [[ "$log_file_input" = /* ]]; then
	log_file="$log_file_input"
else
	log_file="$project_root/$log_file_input"
fi

echo "job=${job_name}"
echo "run_id=${run_id}"
echo "log_file=${log_file}"
echo
tail -n 20 "$log_file"