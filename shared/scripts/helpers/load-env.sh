#!/usr/bin/env zsh

is_sourced=false

if [[ -n "${ZSH_EVAL_CONTEXT:-}" && "${ZSH_EVAL_CONTEXT}" == *:file ]]; then
  is_sourced=true
elif [[ -n "${BASH_SOURCE[0]:-}" && "${BASH_SOURCE[0]}" != "$0" ]]; then
  is_sourced=true
fi

if [[ "$is_sourced" != true ]]; then
  echo "This script must be sourced, not executed."
  echo "Usage: source shared/scripts/helpers/load-env.sh <env-name> [<env-name> ...]"
  return 1 2>/dev/null || exit 1
fi

env_root="${RS_DATA_PLATFORM_ENV_ROOT:-$HOME/.config/rs-data-platform}"

if [[ $# -eq 0 ]]; then
  echo "Usage: source shared/scripts/helpers/load-env.sh <env-name> [<env-name> ...]"
  echo "Example: source shared/scripts/helpers/load-env.sh github postgres"
  return 1
fi

typeset -a loaded_files

for env_name in "$@"; do
  env_file="$env_root/${env_name}.env"

  if [[ ! -f "$env_file" ]]; then
    echo "Env file not found: $env_file"
    return 1
  fi

  set -a
  source "$env_file"
  set +a
  loaded_files+=("$env_file")
done

echo "Loaded env files:"
for env_file in "${loaded_files[@]}"; do
  echo "- $env_file"
done