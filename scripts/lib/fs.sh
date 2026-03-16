#!/usr/bin/env bash

ensure_dir() {
  local dir="$1"

  if [ -d "$dir" ]; then
    echo "[SKIP] dir exists: $dir"
  else
    mkdir -p "$dir"
    echo "[CREATE] dir: $dir"
  fi
}

ensure_file() {
  local file="$1"

  mkdir -p "$(dirname "$file")"

  if [ -f "$file" ]; then
    echo "[SKIP] file exists: $file"
  else
    : > "$file"
    echo "[CREATE] file: $file"
  fi
}

write_file_safe() {
  local file="$1"
  local tmp

  mkdir -p "$(dirname "$file")"

  if [ -s "$file" ]; then
    echo "[SKIP] file already has content: $file"
    return
  fi

  tmp="$(mktemp)"
  cat > "$tmp"
  mv "$tmp" "$file"

  echo "[WRITE] file: $file"
}