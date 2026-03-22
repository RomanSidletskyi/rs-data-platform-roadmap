# Keep Current SSD OS And Clean Runtime

This note is for the case where:

- Raspberry Pi already boots from SSD
- you do not want to reinstall the OS right now
- you do want a clean baseline for Docker and repository runtime state

This is not a full operating system reset.

It is a controlled cleanup of old Docker/runtime state while keeping the current SSD-based system.

## When This Path Is Correct

Choose this path when:

- boot is already confirmed on SSD
- old containers and images are not needed
- you want to start fresh with this repository without re-imaging the disk

## What Your Current State Means

From your current output:

- containers: `0`
- images: `0`
- volumes: `0`
- only default Docker networks remain

This means Docker is already almost perfectly clean.

The default Docker networks are normal:

- `bridge`
- `host`
- `none`

Do not remove them.

## Practical Plan

### 1. Keep The Current SSD OS

Do not reinstall the OS.

The system is already booting from SSD and there is no sign of old Docker workloads that matter.

### 2. Run The Cleanup Script Anyway

Even though Docker already looks clean, use the script as a baseline step:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap
bash shared/scripts/setup/raspberry-pi/cleanup-docker-runtime.sh
```

What it does:

- prints the current Docker state
- removes Portainer if present
- removes leftover containers if present
- prunes old images and volumes
- creates `/srv/rs-data-platform/` layout

### 3. Update The System

```bash
sudo apt update
sudo apt full-upgrade -y
sudo rpi-eeprom-update -a
```

### 4. Reboot

```bash
sudo reboot
```

### 5. Create The New Baseline Workflow

After reboot:

- use SSH key authentication
- keep using `pi5.local`
- clone or update the repo under `/srv/rs-data-platform/repo`
- store host-local secrets under `/srv/rs-data-platform/configs`
- start only the new documented stacks

## Expected Runtime Layout

After cleanup, this path should exist:

```text
/srv/rs-data-platform/
├── repo/
├── runtime/
├── data/
├── logs/
├── backups/
└── configs/
```

Verify with:

```bash
ls -la /srv/rs-data-platform
```

## Recommended Next Step After Cleanup

After the baseline is ready:

1. clone the repository under `/srv/rs-data-platform/repo`
2. create `/srv/rs-data-platform/configs/shared/airflow-minio-postgres.env`
3. start the stack from:

```text
shared/docker/compose/raspberry-pi/airflow-minio-postgres/
```

## Short Version

Your Docker state is already basically clean.

So your real work is now:

- keep the SSD OS
- run the cleanup/baseline script once
- update the OS
- reboot
- move into the new repo-driven setup