#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo "Inspecting current Docker state..."
docker ps -a || true
docker image ls || true
docker volume ls || true
docker network ls || true
docker system df || true

echo
echo "This script will remove old Docker/runtime state from the current host."
echo "It will delete old containers, old images, and prune old volumes."
echo "Use it only if you do not need the old Docker setup anymore."
echo
read -r -p "Type YES to continue: " confirmation

if [[ "$confirmation" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

echo "Stopping and removing Portainer if present..."
docker stop portainer 2>/dev/null || true
docker rm -f portainer 2>/dev/null || true
docker volume rm portainer_data 2>/dev/null || true

echo "Stopping and removing all remaining containers..."
container_ids="$(docker ps -aq 2>/dev/null || true)"
if [[ -n "$container_ids" ]]; then
  docker stop $container_ids 2>/dev/null || true
  docker rm -f $container_ids 2>/dev/null || true
fi

echo "Pruning Docker images and networks..."
docker system prune -a -f

echo "Pruning Docker volumes..."
docker volume prune -f

echo "Creating repository runtime layout..."
sudo mkdir -p /srv/rs-data-platform/{repo,runtime,data,logs,backups,configs}
sudo chown -R "$USER":"$USER" /srv/rs-data-platform
mkdir -p /srv/rs-data-platform/configs/shared

echo
echo "Cleanup complete. Current Docker state:"
docker ps -a || true
docker image ls || true
docker volume ls || true
docker network ls || true
docker system df || true

echo
echo "Next steps:"
echo "1. sudo apt update && sudo apt full-upgrade -y"
echo "2. sudo rpi-eeprom-update -a"
echo "3. sudo reboot"
echo "4. clone the repo under /srv/rs-data-platform/repo"