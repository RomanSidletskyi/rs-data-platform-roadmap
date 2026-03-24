#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <module-name>"
  echo "Example: $0 03-docker"
  exit 1
fi

MODULE="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SCRIPT_NAME="create-module"

source "$REPO_ROOT/scripts/lib/common.sh"
source "$REPO_ROOT/scripts/lib/fs.sh"

MODULE_SCRIPT_DIR="$REPO_ROOT/scripts/sections/modules/$MODULE"
SNAPSHOT_DIR="$MODULE_SCRIPT_DIR/template_snapshot"

log "Creating script scaffold for module: $MODULE"

ensure_dir "$MODULE_SCRIPT_DIR"
ensure_dir "$SNAPSHOT_DIR"
ensure_dir "$SNAPSHOT_DIR/learning-materials"
ensure_dir "$SNAPSHOT_DIR/simple-tasks"
ensure_dir "$SNAPSHOT_DIR/pet-projects"

ensure_file "$MODULE_SCRIPT_DIR/init.sh"
ensure_file "$MODULE_SCRIPT_DIR/fill_readme.sh"
ensure_file "$MODULE_SCRIPT_DIR/fill_learning_materials.sh"
ensure_file "$MODULE_SCRIPT_DIR/fill_simple_tasks.sh"
ensure_file "$MODULE_SCRIPT_DIR/fill_pet_projects.sh"
ensure_file "$MODULE_SCRIPT_DIR/bootstrap.sh"
ensure_file "$SNAPSHOT_DIR/README.md"
ensure_file "$SNAPSHOT_DIR/learning-materials/.gitkeep"
ensure_file "$SNAPSHOT_DIR/simple-tasks/.gitkeep"
ensure_file "$SNAPSHOT_DIR/pet-projects/.gitkeep"

write_file_safe "$MODULE_SCRIPT_DIR/init.sh" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="__MODULE__-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "__MODULE__")"

log "Creating __MODULE__ structure..."

ensure_dir "$MODULE"
ensure_dir "$MODULE/learning-materials"
ensure_dir "$MODULE/simple-tasks"
ensure_dir "$MODULE/pet-projects"

ensure_gitkeep "$MODULE/learning-materials"
ensure_gitkeep "$MODULE/simple-tasks"
ensure_gitkeep "$MODULE/pet-projects"

log "__MODULE__ structure initialized."
EOF

write_file_safe "$MODULE_SCRIPT_DIR/fill_readme.sh" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="__MODULE__-fill-readme"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "__MODULE__")"
TEMPLATE_DIR="$SCRIPT_DIR/template_snapshot"

log "Creating __MODULE__ README..."

write_file_safe "$MODULE/README.md" < "$TEMPLATE_DIR/README.md"

log "__MODULE__ README created."
EOF

write_file_safe "$MODULE_SCRIPT_DIR/fill_learning_materials.sh" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="__MODULE__-fill-learning-materials"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "__MODULE__")"

log "Preparing __MODULE__ learning materials..."

ensure_dir "$MODULE/learning-materials"
ensure_gitkeep "$MODULE/learning-materials"

log "__MODULE__ learning materials prepared."
EOF

write_file_safe "$MODULE_SCRIPT_DIR/fill_simple_tasks.sh" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="__MODULE__-fill-simple-tasks"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "__MODULE__")"

log "Preparing __MODULE__ simple tasks..."

ensure_dir "$MODULE/simple-tasks"
ensure_gitkeep "$MODULE/simple-tasks"

log "__MODULE__ simple tasks prepared."
EOF

write_file_safe "$MODULE_SCRIPT_DIR/fill_pet_projects.sh" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="__MODULE__-fill-pet-projects"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "__MODULE__")"

log "Preparing __MODULE__ pet projects..."

ensure_dir "$MODULE/pet-projects"
ensure_gitkeep "$MODULE/pet-projects"

log "__MODULE__ pet projects prepared."
EOF

write_file_safe "$MODULE_SCRIPT_DIR/bootstrap.sh" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"

SCRIPT_NAME="__MODULE__-bootstrap"

log "Starting __MODULE__ bootstrap..."

bash "$SCRIPT_DIR/init.sh"
bash "$SCRIPT_DIR/fill_readme.sh"
bash "$SCRIPT_DIR/fill_learning_materials.sh"
bash "$SCRIPT_DIR/fill_simple_tasks.sh"
bash "$SCRIPT_DIR/fill_pet_projects.sh"

log "__MODULE__ bootstrap finished successfully."
EOF

write_file_safe "$SNAPSHOT_DIR/README.md" <<'EOF'
# __MODULE__

Generator-backed module placeholder.

Replace this snapshot content before using the module bootstrap as a source of truth.
EOF

for script_file in \
  "$MODULE_SCRIPT_DIR/init.sh" \
  "$MODULE_SCRIPT_DIR/fill_readme.sh" \
  "$MODULE_SCRIPT_DIR/fill_learning_materials.sh" \
  "$MODULE_SCRIPT_DIR/fill_simple_tasks.sh" \
  "$MODULE_SCRIPT_DIR/fill_pet_projects.sh" \
  "$MODULE_SCRIPT_DIR/bootstrap.sh"
do
  perl -0pi -e 's/__MODULE__/'"$MODULE"'/g' "$script_file"
done

chmod +x "$MODULE_SCRIPT_DIR/init.sh"
chmod +x "$MODULE_SCRIPT_DIR/fill_readme.sh"
chmod +x "$MODULE_SCRIPT_DIR/fill_learning_materials.sh"
chmod +x "$MODULE_SCRIPT_DIR/fill_simple_tasks.sh"
chmod +x "$MODULE_SCRIPT_DIR/fill_pet_projects.sh"
chmod +x "$MODULE_SCRIPT_DIR/bootstrap.sh"

log "Module script scaffold created: scripts/sections/modules/$MODULE"
log "Template snapshot created: scripts/sections/modules/$MODULE/template_snapshot"
log "Next step: replace snapshot placeholders and refine the scripts"
log "Run with: ./scripts/bootstrap_section.sh modules $MODULE"