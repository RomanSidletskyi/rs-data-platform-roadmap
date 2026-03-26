#!/usr/bin/env bash

set -euo pipefail

remote_host="${1:-${REMOTE_HOST:-example-host}}"
remote_user="${REMOTE_USER:-ubuntu}"

echo "Audit target: ${remote_user}@${remote_host}"
echo
echo "Suggested checks:"
echo "1. ssh ${remote_user}@${remote_host} 'hostname && uptime'"
echo "2. ssh ${remote_user}@${remote_host} 'id && whoami'"
echo "3. ssh ${remote_user}@${remote_host} 'df -h && free -m'"
echo "4. ssh ${remote_user}@${remote_host} 'ss -tulpn | head -n 20'"
echo "5. ssh ${remote_user}@${remote_host} 'find /var/log -maxdepth 1 -type f | sort'"