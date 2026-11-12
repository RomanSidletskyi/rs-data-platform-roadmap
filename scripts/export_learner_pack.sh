#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
EXCLUDE_MANIFEST="$SCRIPT_DIR/learner_export_excludes.txt"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/export_learner_pack.sh --output <new-directory> [--dry-run]

Build a learner copy from the current working tree. Git-ignored files are not
included. The output directory must not already exist and must be outside the
repository. Use --dry-run to inspect exclusion counts without creating output.
EOF
}

fail() {
  printf '[export-learner-pack] ERROR: %s\n' "$1" >&2
  exit 1
}

record_unique() {
  local value="$1"
  local destination="$2"

  if ! grep -Fxq "$value" "$destination"; then
    printf '%s\n' "$value" >> "$destination"
  fi
}

is_below_directory() {
  local file_path="$1"
  shift

  local excluded_dir
  for excluded_dir in "$@"; do
    if [[ "$file_path" == "$excluded_dir" || "$file_path" == "$excluded_dir/"* ]]; then
      return 0
    fi
  done

  return 1
}

record_directory_tree() {
  local relative_root="$1"
  local absolute_root="$REPO_ROOT/$relative_root"
  local absolute_dir
  local relative_dir

  while IFS= read -r -d '' absolute_dir; do
    relative_dir="${absolute_dir#"$REPO_ROOT"/}"
    record_unique "$relative_dir" "$PRESERVED_DIRS"
  done < <(find "$absolute_root" -type d -print0)
}

find_excluded_directory_name() {
  local file_path="$1"
  local remaining="$file_path"
  local prefix=""
  local component
  local excluded_name

  MATCHED_EXCLUDED_DIR=""
  while [[ "$remaining" == */* ]]; do
    component="${remaining%%/*}"
    remaining="${remaining#*/}"
    for excluded_name in "${EXCLUDED_DIRS[@]}"; do
      if [[ "$component" == "$excluded_name" ]]; then
        MATCHED_EXCLUDED_DIR="${prefix:+$prefix/}$component"
        return 0
      fi
    done
    prefix="${prefix:+$prefix/}$component"
  done

  return 1
}

OUTPUT_ARGUMENT=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output|-o)
      [[ $# -ge 2 ]] || fail "--output requires a directory path"
      OUTPUT_ARGUMENT="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help|help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      fail "Unknown argument: $1"
      ;;
  esac
done

[[ -n "$OUTPUT_ARGUMENT" ]] || { usage >&2; fail "Output directory is required"; }
[[ -f "$EXCLUDE_MANIFEST" ]] || fail "Missing exclusion list: $EXCLUDE_MANIFEST"
command -v git >/dev/null 2>&1 || fail "git is required"
command -v rsync >/dev/null 2>&1 || fail "rsync is required"

case "$OUTPUT_ARGUMENT" in
  /*) ;;
  *) OUTPUT_ARGUMENT="$REPO_ROOT/$OUTPUT_ARGUMENT" ;;
esac

while [[ "$OUTPUT_ARGUMENT" != "/" && "$OUTPUT_ARGUMENT" == */ ]]; do
  OUTPUT_ARGUMENT="${OUTPUT_ARGUMENT%/}"
done

OUTPUT_NAME="$(basename "$OUTPUT_ARGUMENT")"
OUTPUT_PARENT_ARGUMENT="$(dirname "$OUTPUT_ARGUMENT")"
[[ "$OUTPUT_NAME" != "." && "$OUTPUT_NAME" != ".." ]] || fail "Invalid output directory"
[[ -d "$OUTPUT_PARENT_ARGUMENT" ]] || fail "Output parent must already exist: $OUTPUT_PARENT_ARGUMENT"

OUTPUT_PARENT="$(cd "$OUTPUT_PARENT_ARGUMENT" && pwd -P)"
OUTPUT_PATH="$OUTPUT_PARENT/$OUTPUT_NAME"
[[ "$OUTPUT_PATH" != "$REPO_ROOT" ]] || fail "Output cannot be the repository root"
case "$OUTPUT_PATH/" in
  "$REPO_ROOT/"*) fail "Output must be outside the repository" ;;
esac
[[ ! -e "$OUTPUT_PATH" && ! -L "$OUTPUT_PATH" ]] || fail "Output already exists: $OUTPUT_PATH"

WORK_DIR="$(mktemp -d "$OUTPUT_PARENT/.${OUTPUT_NAME}.learner-export.XXXXXX")"
cleanup() {
  if [[ -n "${WORK_DIR:-}" && -d "$WORK_DIR" ]]; then
    rm -rf "$WORK_DIR"
  fi
}
trap cleanup EXIT

PACKAGE_DIR="$WORK_DIR/package"
FILE_LIST="$WORK_DIR/files.nul"
OMITTED_FILES="$WORK_DIR/omitted-files.txt"
OMITTED_DIRS="$WORK_DIR/omitted-directories.txt"
PRESERVED_DIRS="$WORK_DIR/preserved-directories.txt"

mkdir -p "$PACKAGE_DIR"
: > "$FILE_LIST"
: > "$OMITTED_FILES"
: > "$OMITTED_DIRS"
: > "$PRESERVED_DIRS"

EXCLUDED_DIRS=()
while IFS= read -r excluded_dir || [[ -n "$excluded_dir" ]]; do
  [[ -n "$excluded_dir" && "$excluded_dir" != \#* ]] || continue
  excluded_dir="${excluded_dir%/}"
  case "$excluded_dir" in
    /*|..|../*|*/../*|*/..) fail "Exclusion paths must stay inside the repository: $excluded_dir" ;;
  esac
  EXCLUDED_DIRS+=("$excluded_dir")
done < "$EXCLUDE_MANIFEST"

REFERENCE_DIRS=()
while IFS= read -r -d '' reference_dir; do
  relative_dir="${reference_dir#"$REPO_ROOT"/}"
  [[ "$relative_dir" != scripts/* ]] || continue
  REFERENCE_DIRS+=("$relative_dir")
  record_unique "$relative_dir" "$OMITTED_DIRS"
  record_directory_tree "$relative_dir"
done < <(find "$REPO_ROOT" \( -name .git -o -name .venv -o -name node_modules \) -prune -o -type d -name 'reference_example_*' -print0)

INCLUDED_COUNT=0
while IFS= read -r -d '' relative_path; do
  source_path="$REPO_ROOT/$relative_path"
  [[ -f "$source_path" && ! -L "$source_path" ]] || continue

  base_name="${relative_path##*/}"
  case "$base_name" in
    *.env.example) ;;
    .env|.env.*|*.env|*.secret|*.secrets|*.token|*.pem|*.key|*.p12|*.crt) continue ;;
  esac

  case "$relative_path" in
    .git/*|.venv/*|venv/*|scripts/*|node_modules/*|*/node_modules/*|*/__pycache__/*|*/.DS_Store) continue ;;
  esac

  if is_below_directory "$relative_path" "${REFERENCE_DIRS[@]}"; then
    for reference_dir in "${REFERENCE_DIRS[@]}"; do
      if [[ "$relative_path" == "$reference_dir/"* ]]; then
        record_unique "$reference_dir" "$OMITTED_DIRS"
        break
      fi
    done
    case "$base_name" in
      *.md) record_unique "$relative_path" "$OMITTED_FILES" ;;
    esac
    continue
  fi

  if find_excluded_directory_name "$relative_path"; then
    if ! grep -Fxq "$MATCHED_EXCLUDED_DIR" "$OMITTED_DIRS"; then
      record_unique "$MATCHED_EXCLUDED_DIR" "$OMITTED_DIRS"
      record_directory_tree "$MATCHED_EXCLUDED_DIR"
    fi
    case "$base_name" in
      *.md) record_unique "$relative_path" "$OMITTED_FILES" ;;
    esac
    continue
  fi

  case "$relative_path" in
    */simple-tasks/*/solution.md)
      record_unique "$relative_path" "$OMITTED_FILES"
      continue
      ;;
  esac

  case "$base_name" in
    reference_solution*)
      record_unique "$relative_path" "$OMITTED_FILES"
      continue
      ;;
  esac

  case "$relative_path" in
    real-projects/*|*/real-projects/*)
      case "$relative_path" in
        */src/*|*/tests/*|*/docker/*|*/logs/*|*/data/warehouse/*|*/data/quality/*) continue ;;
      esac
      case "$base_name" in
        *.py|*.sql|*.sh|*.yml|*.yaml|*.db|*.sqlite|*.sqlite3|*.log|Dockerfile|.dockerignore) continue ;;
      esac
      ;;
  esac

  printf '%s\0' "$relative_path" >> "$FILE_LIST"
  INCLUDED_COUNT=$((INCLUDED_COUNT + 1))
done < <(git -C "$REPO_ROOT" ls-files --cached --others --exclude-standard -z)

OMITTED_FILE_COUNT="$(wc -l < "$OMITTED_FILES" | tr -d ' ')"
OMITTED_DIR_COUNT="$(wc -l < "$OMITTED_DIRS" | tr -d ' ')"

while IFS= read -r omitted_dir || [[ -n "$omitted_dir" ]]; do
  [[ -n "$omitted_dir" ]] || continue
  record_unique "$omitted_dir/README.md" "$OMITTED_FILES"
done < "$OMITTED_DIRS"

while IFS= read -r preserved_dir || [[ -n "$preserved_dir" ]]; do
  [[ -n "$preserved_dir" ]] || continue
  destination_dir="$PACKAGE_DIR/$preserved_dir"
  mkdir -p "$destination_dir"
  if [[ -z "$(find "$destination_dir" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
    : > "$destination_dir/.gitkeep"
  fi
done < "$PRESERVED_DIRS"

OMITTED_FILE_COUNT="$(wc -l < "$OMITTED_FILES" | tr -d ' ')"

if [[ "$DRY_RUN" == true ]]; then
  printf 'Learner export preview\n'
  printf '  Included files: %s\n' "$INCLUDED_COUNT"
  printf '  Omitted answer/reference files: %s\n' "$OMITTED_FILE_COUNT"
  printf '  Omitted solved-project directories: %s\n' "$OMITTED_DIR_COUNT"
  printf '  Output: %s\n' "$OUTPUT_PATH"
  exit 0
fi

rsync -a --from0 --files-from="$FILE_LIST" --relative "$REPO_ROOT/" "$PACKAGE_DIR/"

if [[ -f "$PACKAGE_DIR/README.md" ]]; then
  awk '
    /^## Scripts And Automation$/ {
      print "## Scripts And Automation"
      print ""
      print "Repository-maintenance and generator scripts are omitted from this learner copy. Module materials and project briefs remain available."
      print ""
      skipping = 1
      next
    }
    /^## Working Principles$/ { skipping = 0 }
    !skipping { print }
  ' "$PACKAGE_DIR/README.md" > "$WORK_DIR/README.md"
  mv "$WORK_DIR/README.md" "$PACKAGE_DIR/README.md"
fi

while IFS= read -r omitted_file || [[ -n "$omitted_file" ]]; do
  [[ -n "$omitted_file" ]] || continue
  omitted_path="$PACKAGE_DIR/$omitted_file"
  mkdir -p "$(dirname "$omitted_path")"
  printf '# Omitted From Learner Export\n\nThe solution or reference implementation for this path is not included in the learner copy.\n' > "$omitted_path"
done < "$OMITTED_FILES"

while IFS= read -r omitted_dir || [[ -n "$omitted_dir" ]]; do
  [[ -n "$omitted_dir" ]] || continue
  omitted_readme="$PACKAGE_DIR/$omitted_dir/README.md"
  if [[ ! -f "$omitted_readme" ]]; then
    mkdir -p "$(dirname "$omitted_readme")"
    printf '# Project Omitted From Learner Export\n\nThis completed project or solved reference is not included in the learner copy.\n' > "$omitted_readme"
  fi
done < "$OMITTED_DIRS"

branch_name="$(git -C "$REPO_ROOT" branch --show-current)"
commit_id="$(git -C "$REPO_ROOT" rev-parse --short HEAD)"
{
  printf '# Learner Export\n\n'
  printf 'Source branch: `%s`\n\n' "${branch_name:-detached HEAD}"
  printf 'Base commit: `%s`\n\n' "$commit_id"
  printf 'This copy was assembled from the current working tree. Git-ignored files, local secrets, generator internals, task answer keys, solved reference examples, and paths listed in `scripts/learner_export_excludes.txt` are omitted. Placeholder files make the omissions visible without exposing the solutions.\n\n'
  printf 'Executable implementation files under `real-projects/` are omitted; project briefs and architecture documents are retained.\n'
} > "$PACKAGE_DIR/LEARNER_EXPORT.md"

mv "$PACKAGE_DIR" "$OUTPUT_PATH"
printf '[export-learner-pack] Created learner copy at %s (%s source files; %s answer/reference placeholders).\n' "$OUTPUT_PATH" "$INCLUDED_COUNT" "$OMITTED_FILE_COUNT"