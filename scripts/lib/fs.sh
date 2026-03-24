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

copy_file_from_template() {
  local source_file="$1"
  local target_file="$2"

  if [[ ! -f "$source_file" ]]; then
    die "Missing template file: $source_file"
  fi

  ensure_dir "$(dirname "$target_file")"
  cp "$source_file" "$target_file"

  log "Copied template file: $source_file -> $target_file"
}

sync_dir_contents_from_template() {
  local source_dir="$1"
  local target_dir="$2"
  shift 2

  local excluded_names=("$@")
  local entry
  local base_name
  local excluded_name
  local skip_entry

  if [[ ! -d "$source_dir" ]]; then
    die "Missing template directory: $source_dir"
  fi

  ensure_dir "$target_dir"

  shopt -s dotglob nullglob

  for entry in "$target_dir"/*; do
    base_name="$(basename "$entry")"
    skip_entry=false

    for excluded_name in "${excluded_names[@]}"; do
      if [[ "$base_name" == "$excluded_name" ]]; then
        skip_entry=true
        break
      fi
    done

    if [[ "$skip_entry" == false ]]; then
      rm -rf "$entry"
    fi
  done

  for entry in "$source_dir"/*; do
    base_name="$(basename "$entry")"
    skip_entry=false

    for excluded_name in "${excluded_names[@]}"; do
      if [[ "$base_name" == "$excluded_name" ]]; then
        skip_entry=true
        break
      fi
    done

    if [[ "$skip_entry" == false ]]; then
      cp -R "$entry" "$target_dir/$base_name"
    fi
  done

  shopt -u dotglob nullglob

  log "Synchronized template directory contents: $source_dir -> $target_dir"
}