#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd "$script_dir/.." && pwd)"

output_dir_input="${OUTPUT_DIR:-output}"
archive_dir_input="${ARCHIVE_DIR:-archive}"

if [[ "$output_dir_input" = /* ]]; then
  output_dir="$output_dir_input"
else
  output_dir="$project_root/$output_dir_input"
fi

if [[ "$archive_dir_input" = /* ]]; then
  archive_dir="$archive_dir_input"
else
  archive_dir="$project_root/$archive_dir_input"
fi

mkdir -p "$archive_dir"

if [[ -d "$output_dir" ]]; then
  timestamp="$(date +%Y%m%d_%H%M%S)"
  mv "$output_dir" "${archive_dir}/output_${timestamp}"
  echo "Archived ${output_dir} into ${archive_dir}/output_${timestamp}"
else
  echo "No output directory found at ${output_dir}"
fi