get_repo_root() {
  local caller_dir="$1"
  cd "$caller_dir/../../../.." && pwd
}

get_section_root() {
  local caller_dir="$1"
  cd "$caller_dir/.." && pwd
}

get_module_root() {
  local repo_root="$1"
  local module_name="$2"
  printf '%s/%s\n' "$repo_root" "$module_name"
}