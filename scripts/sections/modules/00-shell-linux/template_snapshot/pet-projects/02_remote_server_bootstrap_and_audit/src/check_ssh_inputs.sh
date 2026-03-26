#!/usr/bin/env bash

set -euo pipefail

ssh_config_path_input="${SSH_CONFIG_PATH:-$HOME/.ssh/config}"

ssh_config_path="${ssh_config_path_input/#\~/$HOME}"

echo "Using SSH config: ${ssh_config_path}"

if [[ -f "$ssh_config_path" ]]; then
  echo "SSH config found"
else
  echo "SSH config missing"
fi

echo "Remote host: ${REMOTE_HOST:-example-host}"
echo "Remote user: ${REMOTE_USER:-ubuntu}"