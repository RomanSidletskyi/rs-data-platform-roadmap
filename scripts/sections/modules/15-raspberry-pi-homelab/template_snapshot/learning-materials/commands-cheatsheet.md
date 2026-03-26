# Raspberry Pi Commands Cheatsheet

This file is a short operational reference for the most common Raspberry Pi tasks in this repository.

Use it when you need a command quickly.

Use the other learning materials when you need explanation and context.

## Assumptions Used In Examples

- SSH host alias: `pi5`
- Raspberry Pi user: `rsidletskyi`
- Raspberry Pi hostname: `pi5.local`
- Raspberry Pi IP example: `192.168.1.110`
- repo root on Raspberry Pi: `/srv/rs-data-platform/repo/rs-data-platform-roadmap`

Adjust those values to your real setup.

## One-Command Setup Shortcuts

Full host baseline:

```bash
sudo bash /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/scripts/setup/raspberry-pi/bootstrap-host-baseline.sh
```

Minimal useful terminal apps:

See [15_useful_headless_apps.md](/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/15-raspberry-pi-homelab/learning-materials/15_useful_headless_apps.md)

```bash
sudo bash /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/scripts/setup/raspberry-pi/install-headless-apps.sh
```

Extended useful terminal apps:

See [15_useful_headless_apps.md](/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/15-raspberry-pi-homelab/learning-materials/15_useful_headless_apps.md)

```bash
sudo bash /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/scripts/setup/raspberry-pi/install-extended-headless-apps.sh
```

Useful web UI tools:

See [16_useful_web_ui_apps.md](/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/15-raspberry-pi-homelab/learning-materials/16_useful_web_ui_apps.md)

One-command web UI stack:

```bash
sudo bash /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/scripts/setup/raspberry-pi/install-ops-ui.sh
```

This starts:

- Portainer on `9005`
- Dozzle on `9999`
- File Browser on `8089`
- Uptime Kuma on `3001`

Post-install checklist:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/ops-ui
docker compose ps
```

Open in browser:

- Portainer: `http://pi5.local:9005`
- Dozzle: `http://pi5.local:9999`
- File Browser: `http://pi5.local:8089`
- Uptime Kuma: `http://pi5.local:3001`

First useful Uptime Kuma monitors:

- `http://pi5.local:8088`
- `http://pi5.local:9001`
- `http://pi5.local:9000/minio/health/live`

Manual compose path:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/ops-ui
cp .env.example .env
mkdir -p /srv/rs-data-platform/runtime/portainer/data
mkdir -p /srv/rs-data-platform/runtime/filebrowser/config
mkdir -p /srv/rs-data-platform/runtime/uptime-kuma/data
docker compose up -d
```

## First Login And Basic Host Checks

Connect by SSH alias:

```bash
ssh pi5
```

Connect by hostname directly:

```bash
ssh rsidletskyi@pi5.local
```

Connect by IP directly:

```bash
ssh rsidletskyi@192.168.1.110
```

Basic checks after login:

```bash
whoami
hostname
hostname -I
pwd
ls -lah
df -h
free -h
uname -a
cat /etc/os-release
```

Exit session:

```bash
exit
```

## Filesystem Navigation And Basic File Actions

Show current folder:

```bash
pwd
```

List files:

```bash
ls
ls -lah
```

Go home:

```bash
cd
```

Go to repo runtime base:

```bash
cd /srv/rs-data-platform
```

Go one level up:

```bash
cd ..
```

Go to previous directory:

```bash
cd -
```

Create folder:

```bash
mkdir test-dir
mkdir -p /srv/rs-data-platform/{repo,runtime,data,logs,backups,configs/shared}
```

Create file:

```bash
touch notes.txt
```

Read file:

```bash
cat /etc/hostname
less /etc/ssh/sshd_config
```

Edit file:

```bash
nano ~/.ssh/config
```

## SSH Keys And SSH Config

Generate a dedicated key on Mac:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_pi5 -C "rsidletskyi@pi5.local" -N ""
```

Copy public key to Raspberry Pi:

```bash
cat ~/.ssh/id_ed25519_pi5.pub | ssh rsidletskyi@pi5.local 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
```

Test key login:

```bash
ssh -i ~/.ssh/id_ed25519_pi5 rsidletskyi@pi5.local
```

Create local SSH config:

```bash
touch ~/.ssh/config
chmod 600 ~/.ssh/config
nano ~/.ssh/config
```

Example SSH config:

```sshconfig
Host pi5
    HostName pi5.local
    User rsidletskyi
    IdentityFile ~/.ssh/id_ed25519_pi5
    IdentitiesOnly yes
```

Show effective SSH config:

```bash
ssh -G pi5 | egrep '^(hostname|user|identityfile) '
```

## Find IP And Check Connectivity

On Raspberry Pi:

```bash
hostname -I
ip a
ip addr show eth0
ip addr show wlan0
```

From Mac:

```bash
ping -c 2 pi5.local
arp -a | grep pi5
```

## File Copy And Sync

Copy one file to Raspberry Pi:

```bash
scp ./local-file.txt pi5:/tmp/
```

Copy one file from Raspberry Pi to Mac:

```bash
scp pi5:/etc/hostname ./hostname-from-pi.txt
```

Sync one folder to Raspberry Pi:

```bash
rsync -avz ./my-project/ pi5:/srv/rs-data-platform/runtime/my-project/
```

Sync logs back to Mac:

```bash
rsync -avz pi5:/srv/rs-data-platform/logs/ ./logs-from-pi/
```

Verify remote files:

```bash
ssh pi5 'ls -lah /srv/rs-data-platform'
```

## Package And System Update

Refresh package index:

```bash
sudo apt update
```

Upgrade packages:

```bash
sudo apt full-upgrade -y
```

Install useful tools:

```bash
sudo apt install -y git curl wget tmux htop btop tree ncdu jq unzip ca-certificates gnupg lsb-release rsync mc ripgrep fd-find bat vim lsof net-tools dnsutils python3-venv sqlite3
```

Useful command notes on Raspberry Pi OS:

```bash
batcat --paging=never /etc/os-release
fdfind docker /srv/rs-data-platform
rg minio /srv/rs-data-platform/repo/rs-data-platform-roadmap
mc
btop
```

Reboot:

```bash
sudo reboot
```

Power off:

```bash
sudo poweroff
```

Update Raspberry Pi EEPROM:

```bash
sudo rpi-eeprom-update -a
```

Open Raspberry Pi configuration tool:

```bash
sudo raspi-config
```

## Host Directory Layout

Create base directories:

```bash
sudo mkdir -p /srv/rs-data-platform/{repo,runtime,data,logs,backups,configs}
sudo chown -R $USER:$USER /srv/rs-data-platform
mkdir -p /srv/rs-data-platform/configs/shared
```

Inspect sizes:

```bash
du -sh /srv/rs-data-platform/*
ncdu /srv/rs-data-platform
```

## Git On Raspberry Pi

Clone the repository:

```bash
cd /srv/rs-data-platform/repo
git clone <your-repo-url>
```

Enter the repo:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap
```

Pull the latest changes:

```bash
git pull
```

Check status:

```bash
git status
git branch --show-current
```

## Systemd Python Services

Create service directory:

```bash
mkdir -p /srv/rs-data-platform/runtime/my-python-service
cd /srv/rs-data-platform/runtime/my-python-service
```

Create virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
```

Reload units and start service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable my-python-service
sudo systemctl start my-python-service
```

Check service status:

```bash
systemctl status my-python-service
```

Follow logs:

```bash
journalctl -u my-python-service -f
```

Show recent logs:

```bash
journalctl -u my-python-service --no-pager -n 100
```

Restart service:

```bash
sudo systemctl restart my-python-service
```

## Docker Install And Verification

Install Docker:

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
```

Check Docker version:

```bash
docker --version
docker run --rm hello-world
```

## Docker Basics

Show running containers:

```bash
docker ps
docker ps -a
```

Show logs:

```bash
docker logs <container-name>
```

Restart or stop:

```bash
docker restart <container-name>
docker stop <container-name>
docker rm <container-name>
```

Resource usage:

```bash
docker stats --no-stream
```

## Docker Compose And Airflow Stack

Go to the stack directory:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/airflow-minio-postgres
```

Prepare runtime config:

```bash
mkdir -p /srv/rs-data-platform/configs/shared
cp /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/configs/templates/raspberry-pi/airflow-minio-postgres.env.example /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
nano /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
```

Create host directories:

```bash
mkdir -p /srv/rs-data-platform/runtime/airflow/{dags,logs,plugins}
mkdir -p /srv/rs-data-platform/runtime/postgres/data
mkdir -p /srv/rs-data-platform/runtime/minio/data
```

Start stack:

```bash
docker compose up -d
docker compose ps
docker compose logs
```

Stop stack:

```bash
docker compose down
```

## Monitoring And Troubleshooting

Interactive process view:

```bash
htop
```

CPU and memory:

```bash
uptime
free -h
```

Disk:

```bash
df -h
du -sh /srv/rs-data-platform/*
```

Failed services:

```bash
systemctl --failed
```

Recent system problems:

```bash
journalctl -xe --no-pager | tail -n 50
```

```bash
journalctl -xe --no-pager | tail -n 50
```

Show listening ports:

```bash
ss -tulpn
```

## Backup Commands

Backup configs:

```bash
tar -czf /srv/rs-data-platform/backups/configs-$(date +%F).tar.gz /srv/rs-data-platform/configs
```

Backup MinIO runtime data:

```bash
tar -czf /srv/rs-data-platform/backups/minio-$(date +%F).tar.gz /srv/rs-data-platform/runtime/minio
```

List backup files:

```bash
ls -lh /srv/rs-data-platform/backups
```

## SSD And Performance Notes

Edit Raspberry Pi 5 firmware config for PCIe tuning:

```bash
sudo nano /boot/firmware/config.txt
```

Useful settings under `[all]`:

```conf
dtparam=pciex1
dtparam=pciex1_gen=3
```

Edit EEPROM boot order:

```bash
sudo rpi-eeprom-config --edit
```

Run storage benchmark:

```bash
sudo curl https://raw.githubusercontent.com/TheRemote/PiBenchmarks/master/Storage.sh | sudo bash
```

## Portainer Optional

Create Portainer volume:

```bash
docker volume create portainer_data
```

Run Portainer:

```bash
docker run -d \
  -p 8000:8000 \
  -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

See Portainer container status:

```bash
docker container ls -a
docker restart portainer
```

## Useful One-Liners For This Repository

Go to the repo quickly:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap
```

Show quick host and Docker health:

```bash
docker ps && free -h && df -h
```

Show logs folder sizes:

```bash
du -sh /srv/rs-data-platform/logs/*
```

Save a quick health snapshot:

```bash
echo "=== $(date) ===" >> /srv/rs-data-platform/logs/health-check.log
uptime >> /srv/rs-data-platform/logs/health-check.log
free -h >> /srv/rs-data-platform/logs/health-check.log
df -h >> /srv/rs-data-platform/logs/health-check.log
docker ps >> /srv/rs-data-platform/logs/health-check.log
```

## When To Use Which File

Use this file when:

- you need a command quickly
- you forgot the exact syntax
- you want a short operational reference

Use the quickstart when:

- you are setting up Raspberry Pi from scratch

Use the simple task solutions when:

- you want step-by-step answers for a specific task