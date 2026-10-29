# Raspberry Pi Homelab

This module introduces Raspberry Pi as a small self-hosted lab environment for data engineering practice.

The goal is not to turn Raspberry Pi into a production platform.

The goal is to learn how to use a low-cost remote machine for:

- Docker workloads
- lightweight data services
- remote development workflows
- file storage for local labs
- service operations and monitoring

## Why It Matters

Many learning roadmaps assume you can run everything on a laptop.

In practice, local machines often have constraints:

- Docker may not be available
- memory may be limited
- it may be inconvenient to keep services running all the time
- you may want a separate host for experiments

Raspberry Pi gives you a small always-on environment where you can learn:

- remote access
- service deployment
- host organization
- basic infrastructure operations
- lightweight self-hosted platform patterns

## What You Will Learn

- Raspberry Pi role in a learning data platform
- Raspberry Pi OS installation and first boot
- SSH access and network basics
- static IP and remote login workflows
- Docker on ARM devices
- service deployment with compose
- file layout, volumes, and backups
- monitoring CPU, memory, disk, and container health
- security basics for a home lab machine
- how Raspberry Pi integrates with this repository

## Quick One-Command Setup

If you already have Raspberry Pi OS running and want fast setup entry points, use these commands on the Pi.

Full host baseline:

```bash
sudo bash /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/scripts/setup/raspberry-pi/bootstrap-host-baseline.sh
```

Minimal useful terminal apps:

See [learning-materials/15_useful_headless_apps.md](learning-materials/15_useful_headless_apps.md)

```bash
sudo bash /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/scripts/setup/raspberry-pi/install-headless-apps.sh
```

Extended useful terminal apps:

See [learning-materials/15_useful_headless_apps.md](learning-materials/15_useful_headless_apps.md)

```bash
sudo bash /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/scripts/setup/raspberry-pi/install-extended-headless-apps.sh
```

Useful browser-based tools:

See [learning-materials/16_useful_web_ui_apps.md](learning-materials/16_useful_web_ui_apps.md)

## Learning Structure

### Learning Materials

Recommended order for a new Raspberry Pi user:

1. [Raspberry Pi fundamentals and hardware choices](learning-materials/01_raspberry_pi_role_in_data_platform_lab.md)
2. [OS installation and first boot](learning-materials/02_installation_and_first_boot.md)
3. [First 15 minutes on Pi after boot](learning-materials/01_first_15_minutes_on_pi.md)
4. [Quickstart from first boot to working SSH and Docker](learning-materials/00_quickstart_first_boot_to_docker.md)
5. [SSH, networking, and remote access](learning-materials/03_ssh_networking_and_remote_access.md)
6. [SSH access cheatsheet](learning-materials/11_ssh_access_cheatsheet.md)
7. [SCP and rsync cheatsheet](learning-materials/12_scp_and_rsync_cheatsheet.md)
8. [VS Code Remote SSH](learning-materials/13_vscode_remote_ssh.md)
9. [Shared secrets management rules](learning-materials/08_secrets_management.md)
10. [Shared local env files workflow](../shared/environments/local-env-files-workflow.md)
11. [Keep current SSD OS and build a clean baseline](learning-materials/10_keep_current_ssd_os_and_clean_runtime.md)
12. [Clean SSD-first rebuild from an existing Raspberry Pi](learning-materials/09_clean_ssd_first_rebuild.md)
13. [Docker and service management on ARM](learning-materials/04_docker_services_and_runtime_layout.md)
14. [Storage, file layout, and backups](learning-materials/05_storage_backups_and_file_management.md)
15. [Monitoring, security, and operations](learning-materials/06_monitoring_security_and_operations.md)
16. [Useful headless apps for daily Raspberry Pi work](learning-materials/15_useful_headless_apps.md)
17. [Useful web UI apps for Raspberry Pi homelab](learning-materials/16_useful_web_ui_apps.md)
18. [Commands cheatsheet](learning-materials/commands-cheatsheet.md)
19. [Systemd Python service cheatsheet](learning-materials/14_systemd_python_service_cheatsheet.md)
20. [Recovering access from old notes](learning-materials/07_recovering_access_from_old_notes.md)

### Simple Tasks

Recommended task order:

1. [First boot and SSH login](simple-tasks/01_first_boot_and_ssh/README.md)
2. [First session Linux basics](simple-tasks/02_first_session_linux_basics/README.md)
3. [SSH keys and SSH config](simple-tasks/03_ssh_keys_and_config/README.md)
4. [Static IP and remote access setup](simple-tasks/04_static_ip_and_remote_access/README.md)
5. [File transfer and remote editing](simple-tasks/05_file_transfer_and_remote_editing/README.md)
6. [Docker installation and first service](simple-tasks/06_install_docker_and_run_services/README.md)
7. [Storage layout and backup basics](simple-tasks/07_storage_layout_and_backups/README.md)
8. [Monitoring and service operations](simple-tasks/08_monitoring_and_operations/README.md)
9. [Optional systemd Python service](simple-tasks/09_systemd_python_service/README.md)

### Pet Projects

Recommended pet project order:

1. [Remote Docker lab](pet-projects/01_remote_docker_lab/README.md)
2. [Airflow on Raspberry Pi](pet-projects/02_airflow_on_raspberry_pi/README.md)
3. [Optional Python ETL service on Pi](pet-projects/03_python_etl_service_on_pi/README.md)

## Related Modules

- 03-docker
- 04-github-actions
- 11-airflow
- 12-dbt
- 16-observability

## Completion Criteria

By the end of this module, you should be able to:

- install Raspberry Pi OS and complete the first boot setup
- connect to the device with SSH from your main machine
- explain the difference between code storage and runtime storage
- install Docker and run simple ARM-compatible services
- organize host directories for repo, data, configs, and logs
- monitor resource usage and inspect service health
- use Raspberry Pi as a remote runtime for this repository