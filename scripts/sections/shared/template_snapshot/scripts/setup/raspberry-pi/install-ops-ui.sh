#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT_DEFAULT="/srv/rs-data-platform/repo/rs-data-platform-roadmap"
REPO_ROOT="${1:-$REPO_ROOT_DEFAULT}"
STACK_DIR="$REPO_ROOT/shared/docker/compose/raspberry-pi/ops-ui"

if [[ ! -d "$STACK_DIR" ]]; then
  echo "Ops UI stack not found: $STACK_DIR"
  exit 1
fi

echo "==> Preparing ops UI runtime directories"
mkdir -p /srv/rs-data-platform/runtime/portainer/data
mkdir -p /srv/rs-data-platform/runtime/filebrowser/config
mkdir -p /srv/rs-data-platform/runtime/uptime-kuma/data

echo "==> Ensuring compose environment file exists"
if [[ ! -f "$STACK_DIR/.env" ]]; then
  cp "$STACK_DIR/.env.example" "$STACK_DIR/.env"
fi

echo "==> Starting ops UI stack"
cd "$STACK_DIR"
docker compose up -d

echo
echo "Ops UI stack is starting. Default URLs:"
echo "- Portainer: http://pi5.local:9005"
echo "- Dozzle: http://pi5.local:9999"
echo "- File Browser: http://pi5.local:8089"
echo "- Uptime Kuma: http://pi5.local:3001"
echo
echo "Stack directory: $STACK_DIR"
