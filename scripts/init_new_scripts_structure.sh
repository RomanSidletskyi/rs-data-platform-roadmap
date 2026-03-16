#!/usr/bin/env bash

set -euo pipefail

ROOT="scripts"

create_dir() {
  local dir="$1"

  if [ -d "$dir" ]; then
    echo "[SKIP] dir exists: $dir"
  else
    mkdir -p "$dir"
    echo "[CREATE] dir: $dir"
  fi
}

create_file() {
  local file="$1"

  if [ -f "$file" ]; then
    echo "[SKIP] file exists: $file"
  else
    mkdir -p "$(dirname "$file")"
    touch "$file"
    echo "[CREATE] file: $file"
  fi
}

echo "Creating new scripts architecture..."

############################
# lib
############################

create_dir "$ROOT/lib"

create_file "$ROOT/lib/common.sh"
create_file "$ROOT/lib/fs.sh"
create_file "$ROOT/lib/section.sh"

############################
# entrypoints
############################

create_file "$ROOT/bootstrap_section.sh"
create_file "$ROOT/bootstrap_all.sh"

############################
# sections
############################

create_dir "$ROOT/sections"

############################
# modules
############################

create_dir "$ROOT/sections/modules"

create_dir "$ROOT/sections/modules/01-python"
create_file "$ROOT/sections/modules/01-python/init.sh"
create_file "$ROOT/sections/modules/01-python/fill_learning_materials.sh"
create_file "$ROOT/sections/modules/01-python/fill_simple_tasks.sh"
create_file "$ROOT/sections/modules/01-python/fill_pet_projects.sh"
create_file "$ROOT/sections/modules/01-python/bootstrap.sh"

create_dir "$ROOT/sections/modules/02-sql"
create_file "$ROOT/sections/modules/02-sql/init.sh"
create_file "$ROOT/sections/modules/02-sql/fill_learning_materials.sh"
create_file "$ROOT/sections/modules/02-sql/fill_simple_tasks.sh"
create_file "$ROOT/sections/modules/02-sql/fill_pet_projects.sh"
create_file "$ROOT/sections/modules/02-sql/bootstrap.sh"

############################
# docs section
############################

create_dir "$ROOT/sections/docs"

create_file "$ROOT/sections/docs/init.sh"
create_file "$ROOT/sections/docs/fill_core_docs.sh"
create_file "$ROOT/sections/docs/fill_architecture.sh"
create_file "$ROOT/sections/docs/fill_system_design.sh"
create_file "$ROOT/sections/docs/fill_case_studies.sh"
create_file "$ROOT/sections/docs/fill_tradeoffs.sh"
create_file "$ROOT/sections/docs/bootstrap.sh"

############################
# ai-learning section
############################

create_dir "$ROOT/sections/ai-learning"

create_file "$ROOT/sections/ai-learning/init.sh"
create_file "$ROOT/sections/ai-learning/fill_prompting_guides.sh"
create_file "$ROOT/sections/ai-learning/fill_workflows.sh"
create_file "$ROOT/sections/ai-learning/fill_tools.sh"
create_file "$ROOT/sections/ai-learning/fill_practical_exercises.sh"
create_file "$ROOT/sections/ai-learning/bootstrap.sh"

############################
# real-projects section
############################

create_dir "$ROOT/sections/real-projects"

create_file "$ROOT/sections/real-projects/init.sh"
create_file "$ROOT/sections/real-projects/fill_readmes.sh"
create_file "$ROOT/sections/real-projects/bootstrap.sh"

############################
# shared section
############################

create_dir "$ROOT/sections/shared"

create_file "$ROOT/sections/shared/init.sh"
create_file "$ROOT/sections/shared/fill_readmes.sh"
create_file "$ROOT/sections/shared/bootstrap.sh"

############################
# old scripts archive
############################

create_dir "$ROOT/old"

echo ""
echo "New scripts structure created."
echo "You can now start moving logic into scripts/sections/..."