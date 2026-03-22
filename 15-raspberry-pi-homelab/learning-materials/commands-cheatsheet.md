# Raspberry Pi Commands Cheatsheet

This file is a short operational reference for the most common Raspberry Pi tasks in this repository.

Use it when you need a command quickly.

Use the other learning materials when you need explanation and context.

## Assumptions Used In Examples

- SSH host alias: `rpi-lab`
- Raspberry Pi user: `piuser`
- Raspberry Pi IP example: `192.168.1.50`
- repo root on Raspberry Pi: `/srv/rs-data-platform/repo/rs-data-platform-roadmap`

Adjust those values to your real setup.

## SSH And Remote Access

Connect with SSH alias:

```bash
ssh rpi-lab
```

Connect directly by IP:

```bash
ssh piuser@192.168.1.50
```

Copy SSH key to Raspberry Pi:

```bash
ssh-copy-id piuser@192.168.1.50
```

Test hostname resolution:

```bash
ping rpi-lab.local
```

Show loaded SSH config for the host:

```bash
ssh -G rpi-lab
```

Try older known login patterns if you are recovering access:

```bash
ssh rsidletskyi@pi5.local
ssh rsidletskyi@192.168.0.108
```

## File Copy And Sync

Copy one file to Raspberry Pi:

```bash
scp ./local-file.txt rpi-lab:/srv/rs-data-platform/configs/
```

Copy one folder from Mac to Raspberry Pi:

```bash
rsync -av ./local-folder/ rpi-lab:/srv/rs-data-platform/repo/
```

Copy one folder from Raspberry Pi to Mac:

```bash
rsync -av rpi-lab:/srv/rs-data-platform/logs/ ./rpi-logs/
```

## Basic Host Checks

Who am I:

```bash
whoami
```

Hostname:

```bash
hostname
```

Show IP addresses:

```bash
ip addr
```

Show uptime:

```bash
uptime
```

Show memory usage:

```bash
free -h
```

Show disk usage:

```bash
df -h
```

Show kernel and OS info:

```bash
uname -a
cat /etc/os-release
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
sudo apt install -y git curl htop tmux tree ncdu
```

Reboot:

```bash
sudo reboot
```

Open Raspberry Pi configuration tool:

```bash
sudo raspi-config
```

Power off:

```bash
sudo poweroff
```

Schedule shutdown:

```bash
sudo shutdown -h 21:00
```

Update Raspberry Pi EEPROM:

```bash
sudo rpi-eeprom-update -a
```

## Directory Layout

Create base directories:

```bash
sudo mkdir -p /srv/rs-data-platform/{repo,runtime,data,logs,backups,configs}
sudo chown -R $USER:$USER /srv/rs-data-platform
```

Create common runtime subdirectories:

```bash
mkdir -p /srv/rs-data-platform/runtime/{airflow,postgres,minio,shared}
mkdir -p /srv/rs-data-platform/data/{raw,bronze,silver,gold,generated}
mkdir -p /srv/rs-data-platform/logs/{airflow,docker,python-jobs}
```

Inspect directory sizes:

```bash
du -sh /srv/rs-data-platform/*
```

Inspect interactively:

```bash
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

Check git status:

```bash
git status
```

Show current branch:

```bash
git branch --show-current
```

## Docker Install And Verification

Install Docker with the convenience script:

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
```

Check Docker version:

```bash
docker --version
```

Run a test container:

```bash
docker run --rm hello-world
```

## Docker Basics

Show running containers:

```bash
docker ps
```

Show all containers:

```bash
docker ps -a
```

Show container logs:

```bash
docker logs <container-name>
```

Restart a container:

```bash
docker restart <container-name>
```

Stop a container:

```bash
docker stop <container-name>
```

Remove a container:

```bash
docker rm <container-name>
```

Remove an image:

```bash
docker rmi <image-name>
```

Show live container resource usage once:

```bash
docker stats --no-stream
```

## Quick Test Containers

Run Nginx on port 8080:

```bash
docker run -d --name rpi-nginx -p 8080:80 nginx:alpine
```

Test from the laptop:

```bash
curl http://192.168.1.50:8080
```

Run MinIO:

```bash
mkdir -p /srv/rs-data-platform/runtime/minio/data

docker run -d \
  --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -e MINIO_ROOT_USER=replace_me_locally \
  -e MINIO_ROOT_PASSWORD=replace_me_locally \
  -v /srv/rs-data-platform/runtime/minio/data:/data \
  quay.io/minio/minio server /data --console-address ":9001"
```

## Docker Compose

Start services in the background:

```bash
docker compose up -d
```

See service status:

```bash
docker compose ps
```

See logs:

```bash
docker compose logs
```

Restart services:

```bash
docker compose restart
```

Stop and remove the stack:

```bash
docker compose down
```

## Airflow On Raspberry Pi

Go to the Raspberry Pi compose stack:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/airflow-minio-postgres
```

Copy the example environment file:

```bash
cp .env.example .env
```

Prepare the host-local runtime secret file:

```bash
mkdir -p /srv/rs-data-platform/configs/shared
cp /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/configs/templates/raspberry-pi/airflow-minio-postgres.env.example /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
nano /srv/rs-data-platform/configs/shared/airflow-minio-postgres.env
```

Create host directories before first start:

```bash
mkdir -p /srv/rs-data-platform/runtime/airflow/{dags,logs,plugins}
mkdir -p /srv/rs-data-platform/runtime/postgres/data
mkdir -p /srv/rs-data-platform/runtime/minio/data
```

Start the stack:

```bash
docker compose up -d
```

See Airflow-related logs:

```bash
docker compose logs airflow-init
docker compose logs airflow-webserver
docker compose logs airflow-scheduler
```

Open Airflow UI:

```bash
curl http://192.168.1.50:8088
```

Open MinIO console:

```bash
curl http://192.168.1.50:9001
```

Stop the stack:

```bash
docker compose down
```

Restart only Airflow webserver:

```bash
docker compose restart airflow-webserver
```

## PostgreSQL And MinIO Quick Commands

Connect to PostgreSQL container shell:

```bash
docker exec -it rpi-postgres psql -U airflow -d airflow
```

See PostgreSQL logs:

```bash
docker logs rpi-postgres
```

See MinIO logs:

```bash
docker logs rpi-minio
```

Check MinIO data path usage:

```bash
du -sh /srv/rs-data-platform/runtime/minio/data
```

Check Postgres data path usage:

```bash
du -sh /srv/rs-data-platform/runtime/postgres/data
```

## Monitoring And Troubleshooting

Interactive process view:

```bash
htop
```

Memory usage:

```bash
free -h
```

Disk usage:

```bash
df -h
```

Largest directories in the lab path:

```bash
du -sh /srv/rs-data-platform/*
```

Find failed systemd services:

```bash
systemctl --failed
```

Inspect recent system problems:

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