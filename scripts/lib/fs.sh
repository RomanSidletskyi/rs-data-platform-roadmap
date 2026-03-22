ensure_dir() {
  local dir="$1"

  if [[ -d "$dir" ]]; then
    log "Directory already exists: $dir"
  else
    mkdir -p "$dir"
    log "Created directory: $dir"
  fi
}

ensure_file() {
  local file="$1"

  ensure_dir "$(dirname "$file")"

  if [[ -f "$file" ]]; then
    log "File already exists: $file"
  else
    : > "$file"
    log "Created file: $file"
  fi
}

ensure_gitkeep() {
  local dir="$1"

  ensure_dir "$dir"
  ensure_file "$dir/.gitkeep"
}

write_file_safe() {
  local file="$1"
  local tmp

  ensure_dir "$(dirname "$file")"

  if [[ -s "$file" ]]; then
    warn "File already has content, skipping write: $file"
    return 0
  fi

  tmp="$(mktemp)"
  cat > "$tmp"
  mv "$tmp" "$file"

  log "Wrote file: $file"
}