#!/usr/bin/env bash

set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo bash $0"
  exit 1
fi

PACKAGES=(
  tmux
  htop
  btop
  mc
  tree
  ncdu
  ripgrep
  fd-find
  bat
  vim
  jq
  rsync
  lsof
  net-tools
  dnsutils
  python3-venv
  sqlite3
)

echo "==> Updating package index"
apt update

echo "==> Installing extended headless apps"
DEBIAN_FRONTEND=noninteractive apt install -y "${PACKAGES[@]}"

echo
echo "Installed packages: ${PACKAGES[*]}"
echo
echo "Useful notes for Raspberry Pi OS:"
echo "- File search command is usually: fdfind"
echo "- Syntax-highlighted cat is usually: batcat"
echo "- Python virtual environments: python3 -m venv .venv"
echo "- Start a persistent shell session: tmux new -s lab"
echo "- Open the terminal file manager: mc"
echo "- Monitor the host: btop"