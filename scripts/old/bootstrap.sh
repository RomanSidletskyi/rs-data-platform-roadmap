#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================="
echo "Starting Data Platform Roadmap Bootstrap"
echo "========================================="

echo ""
echo "Step 1/12: Initialize repository structure"
bash "$SCRIPT_DIR/init_repo.sh"

echo ""
echo "Step 2/12: Initialize Python API project"
bash "$SCRIPT_DIR/init_python_api_project.sh"

echo ""
echo "Step 3/12: Populate Python simple tasks"
bash "$SCRIPT_DIR/fill_python_simple_tasks.sh" --with-examples

echo ""
echo "Step 4/12: Populate Python pet projects"
bash "$SCRIPT_DIR/fill_python_pet_projects.sh"

echo ""
echo "Step 5/12: Initialize SQL module"
bash "$SCRIPT_DIR/init_sql_module.sh"

echo ""
echo "Step 6/12: Populate SQL learning materials"
bash "$SCRIPT_DIR/fill_sql_learning_materials.sh"

echo ""
echo "Step 7/12: Populate SQL simple tasks"
bash "$SCRIPT_DIR/fill_sql_simple_tasks.sh"

echo ""
echo "Step 8/12: Populate SQL pet projects"
bash "$SCRIPT_DIR/fill_sql_pet_projects.sh"

echo ""
echo "Step 9/12: Initialize documentation"
bash "$SCRIPT_DIR/init_docs.sh"

echo ""
echo "Step 10/12: Populate module READMEs"
bash "$SCRIPT_DIR/fill_new_modules_readmes.sh"

echo ""
echo "Step 11/12: Populate simple tasks for new modules"
bash "$SCRIPT_DIR/fill_new_modules_simple_tasks.sh"

echo ""
echo "Step 12/12: Initialize repository documentation context"
bash "$SCRIPT_DIR/init_repo_docs.sh"

echo ""
echo "========================================="
echo "Bootstrap completed successfully"
echo "Repository structure is ready"
echo "========================================="