# Keep Current SSD OS And Build A Clean Baseline

This note is for the case where:

- Raspberry Pi already boots from SSD
- you do not want to reinstall the OS right now
- you do want a clean baseline for the machine and repository runtime state

This is not a full operating system reset.

It is a controlled reset of the working environment while keeping the current SSD-based system.

## When This Path Is Correct

Choose this path when:

- boot is already confirmed on SSD
- old workloads are not needed
- you want to start fresh with this repository without re-imaging the disk

## What Your Current State Means

From your current checks:

- containers: `0`
- images: `0`
- volumes: `0`
- only default Docker networks remain

This means Docker is already almost perfectly clean.

So Docker cleanup is no longer the main task.

The real task is to prepare a clean host-level baseline.

The default Docker networks are normal:

- `bridge`
- `host`
- `none`

Do not remove them.

## Practical Plan

### 1. Keep The Current SSD OS

Do not reinstall the OS.

The system is already booting from SSD and there is no sign of old runtime state that justifies a full reinstall.

### 2. Update The OS And Install Baseline Tools

Run the host baseline script from the repository after cloning it to the Pi:

```bash
sudo bash shared/scripts/setup/raspberry-pi/bootstrap-host-baseline.sh
```

What it does:

- updates package lists
- runs a full system upgrade
- installs baseline tools like `git`, `curl`, `tmux`, `htop`, `tree`, `ncdu`, `jq`, and `rsync`
- runs `rpi-eeprom-update -a` if available
- creates `/srv/rs-data-platform/` layout

If the repository is not cloned on the Pi yet, you can run the commands manually:

```bash
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y git curl wget tmux htop tree ncdu jq unzip ca-certificates gnupg lsb-release rsync
sudo rpi-eeprom-update -a
```

### 3. Reboot

```bash
sudo reboot
```

### 4. Create The New Baseline Workflow

After reboot:

- use SSH key authentication
- keep using `pi5.local`
- clone or update the repo under `/srv/rs-data-platform/repo`
- store host-local secrets under `/srv/rs-data-platform/configs`
- start only the tools and services you really need

### 5. Create The Runtime Layout Manually If Needed

If you want to do it without the script:

```bash
sudo mkdir -p /srv/rs-data-platform/{repo,runtime,data,logs,backups,configs/shared}
sudo chown -R "$USER":"$USER" /srv/rs-data-platform
```

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

## Recommended Next Step After Baseline Setup

After the baseline is ready:

1. clone the repository under `/srv/rs-data-platform/repo`
2. set up SSH keys for passwordless access
3. decide which tool to install next as a host service or isolated process
4. if later needed, create `/srv/rs-data-platform/configs/shared/airflow-minio-postgres.env`
5. only then start the stack from:

```text
shared/docker/compose/raspberry-pi/airflow-minio-postgres/
```

## Short Version

Your Docker state is already basically clean.

So your real work is now:

- keep the SSD OS
- run the host baseline script once
- update the OS
- reboot
- create `/srv/rs-data-platform`
- move into the new repo-driven setup