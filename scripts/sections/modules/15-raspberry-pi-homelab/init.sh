#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="15-raspberry-pi-homelab-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "15-raspberry-pi-homelab")"

log "Creating 15-raspberry-pi-homelab structure..."

ensure_dir "$MODULE"

ensure_dir "$MODULE/learning-materials"

ensure_dir "$MODULE/simple-tasks"
ensure_dir "$MODULE/simple-tasks/01_first_boot_and_ssh"
ensure_dir "$MODULE/simple-tasks/02_first_session_linux_basics"
ensure_dir "$MODULE/simple-tasks/03_ssh_keys_and_config"
ensure_dir "$MODULE/simple-tasks/04_static_ip_and_remote_access"
ensure_dir "$MODULE/simple-tasks/05_file_transfer_and_remote_editing"
ensure_dir "$MODULE/simple-tasks/06_install_docker_and_run_services"
ensure_dir "$MODULE/simple-tasks/07_storage_layout_and_backups"
ensure_dir "$MODULE/simple-tasks/08_monitoring_and_operations"
ensure_dir "$MODULE/simple-tasks/09_systemd_python_service"

ensure_dir "$MODULE/pet-projects"
ensure_dir "$MODULE/pet-projects/01_remote_docker_lab"
ensure_dir "$MODULE/pet-projects/02_airflow_on_raspberry_pi"
ensure_dir "$MODULE/pet-projects/02_airflow_on_raspberry_pi/examples"
ensure_dir "$MODULE/pet-projects/02_airflow_on_raspberry_pi/examples/airflow_dags"
ensure_dir "$MODULE/pet-projects/03_python_etl_service_on_pi"

log "Adding .gitkeep files where useful..."

ensure_gitkeep "$MODULE/learning-materials"

ensure_gitkeep "$MODULE/simple-tasks/01_first_boot_and_ssh"
ensure_gitkeep "$MODULE/simple-tasks/02_first_session_linux_basics"
ensure_gitkeep "$MODULE/simple-tasks/03_ssh_keys_and_config"
ensure_gitkeep "$MODULE/simple-tasks/04_static_ip_and_remote_access"
ensure_gitkeep "$MODULE/simple-tasks/05_file_transfer_and_remote_editing"
ensure_gitkeep "$MODULE/simple-tasks/06_install_docker_and_run_services"
ensure_gitkeep "$MODULE/simple-tasks/07_storage_layout_and_backups"
ensure_gitkeep "$MODULE/simple-tasks/08_monitoring_and_operations"
ensure_gitkeep "$MODULE/simple-tasks/09_systemd_python_service"

ensure_gitkeep "$MODULE/pet-projects/01_remote_docker_lab"
ensure_gitkeep "$MODULE/pet-projects/02_airflow_on_raspberry_pi/examples/airflow_dags"
ensure_gitkeep "$MODULE/pet-projects/03_python_etl_service_on_pi"

log "15-raspberry-pi-homelab structure initialized."