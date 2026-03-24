#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <section-name>"
  echo "Supported: ai-learning | docs | real-projects | shared"
  exit 1
fi

SECTION="$1"

case "$SECTION" in
  ai-learning|docs|real-projects|shared)
    ;;
  *)
    echo "Unsupported section: $SECTION"
    exit 1
    ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SCRIPT_NAME="create-section"

source "$REPO_ROOT/scripts/lib/common.sh"
source "$REPO_ROOT/scripts/lib/fs.sh"

SECTION_SCRIPT_DIR="$REPO_ROOT/scripts/sections/$SECTION"
SNAPSHOT_DIR="$SECTION_SCRIPT_DIR/template_snapshot"

log "Creating script scaffold for section: $SECTION"

ensure_dir "$SECTION_SCRIPT_DIR"
ensure_dir "$SNAPSHOT_DIR"
ensure_file "$SECTION_SCRIPT_DIR/init.sh"
ensure_file "$SECTION_SCRIPT_DIR/fill_readme.sh"
ensure_file "$SECTION_SCRIPT_DIR/fill_content.sh"
ensure_file "$SECTION_SCRIPT_DIR/bootstrap.sh"
ensure_file "$SNAPSHOT_DIR/README.md"

write_file_safe "$SECTION_SCRIPT_DIR/init.sh" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"

SCRIPT_NAME="__SECTION__-init"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/__SECTION__"

log "Creating __SECTION__ structure..."

ensure_dir "$SECTION_ROOT"
ensure_gitkeep "$SECTION_ROOT"

log "__SECTION__ structure initialized."
EOF

write_file_safe "$SECTION_SCRIPT_DIR/fill_readme.sh" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"

SCRIPT_NAME="__SECTION__-fill-readme"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/__SECTION__"
TEMPLATE_FILE="$SCRIPT_DIR/template_snapshot/README.md"

log "Creating __SECTION__ README..."

copy_file_from_template "$TEMPLATE_FILE" "$SECTION_ROOT/README.md"

log "__SECTION__ README created."
EOF

write_file_safe "$SECTION_SCRIPT_DIR/fill_content.sh" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"

SCRIPT_NAME="__SECTION__-fill-content"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/__SECTION__"
TEMPLATE_DIR="$SCRIPT_DIR/template_snapshot"

log "Synchronizing __SECTION__ content from template snapshot..."

sync_dir_contents_from_template "$TEMPLATE_DIR" "$SECTION_ROOT" "README.md"

log "__SECTION__ content synchronized."
EOF

write_file_safe "$SECTION_SCRIPT_DIR/bootstrap.sh" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"

SCRIPT_NAME="__SECTION__-bootstrap"

log "Starting __SECTION__ bootstrap..."

bash "$SCRIPT_DIR/init.sh"
bash "$SCRIPT_DIR/fill_readme.sh"
bash "$SCRIPT_DIR/fill_content.sh"

log "__SECTION__ bootstrap finished successfully."
EOF

write_file_safe "$SNAPSHOT_DIR/README.md" <<'EOF'
# __SECTION__

Section template snapshot placeholder.
EOF

for script_file in \
  "$SECTION_SCRIPT_DIR/init.sh" \
  "$SECTION_SCRIPT_DIR/fill_readme.sh" \
  "$SECTION_SCRIPT_DIR/fill_content.sh" \
  "$SECTION_SCRIPT_DIR/bootstrap.sh"
do
  perl -0pi -e 's/__SECTION__/'"$SECTION"'/g' "$script_file"
done

perl -0pi -e 's/__SECTION__/'"$SECTION"'/g' "$SNAPSHOT_DIR/README.md"

chmod +x "$SECTION_SCRIPT_DIR/init.sh"
chmod +x "$SECTION_SCRIPT_DIR/fill_readme.sh"
chmod +x "$SECTION_SCRIPT_DIR/fill_content.sh"
chmod +x "$SECTION_SCRIPT_DIR/bootstrap.sh"

log "Section script scaffold created: scripts/sections/$SECTION"
log "Template snapshot created: scripts/sections/$SECTION/template_snapshot"
log "Run with: ./scripts/bootstrap_section.sh $SECTION"