#!/usr/bin/env bash

set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo bash $0"
  exit 1
fi

REPO_ROOT_DEFAULT="/srv/rs-data-platform/repo/rs-data-platform-roadmap"
REPO_ROOT="${1:-$REPO_ROOT_DEFAULT}"

PACKAGES=(
  git
  curl
  wget
  tmux
  htop
  btop
  tree
  ncdu
  jq
  unzip
  ca-certificates
  gnupg
  lsb-release
  rsync
  mc
  ripgrep
  fd-find
  bat
  vim
  lsof
  net-tools
  dnsutils
  python3-venv
  sqlite3
)

echo "==> Updating package index"
apt update

echo "==> Upgrading installed packages"
DEBIAN_FRONTEND=noninteractive apt full-upgrade -y

echo "==> Installing baseline tools"
DEBIAN_FRONTEND=noninteractive apt install -y "${PACKAGES[@]}"

echo "==> Updating Raspberry Pi EEPROM if available"
if command -v rpi-eeprom-update >/dev/null 2>&1; then
  rpi-eeprom-update -a || true
fi

echo "==> Creating runtime layout"
install -d -m 755 /srv/rs-data-platform
install -d -m 755 /srv/rs-data-platform/repo
install -d -m 755 /srv/rs-data-platform/runtime
install -d -m 755 /srv/rs-data-platform/data
install -d -m 755 /srv/rs-data-platform/logs
install -d -m 755 /srv/rs-data-platform/backups
install -d -m 755 /srv/rs-data-platform/configs
install -d -m 755 /srv/rs-data-platform/configs/shared

echo "==> Current disk usage"
df -h /

echo "==> Current memory usage"
free -h

echo "==> Repository path hint"
if [[ -d "$REPO_ROOT" ]]; then
  echo "Repository already present: $REPO_ROOT"
else
  echo "Repository not found yet: $REPO_ROOT"
  echo "Clone it later into /srv/rs-data-platform/repo"
fi

echo
echo "Host baseline complete. Recommended next steps:"
echo "1. Reboot: sudo reboot"
echo "2. Configure SSH keys"
echo "3. Clone the repo into /srv/rs-data-platform/repo"
echo "4. Continue with module tasks without Docker for now"