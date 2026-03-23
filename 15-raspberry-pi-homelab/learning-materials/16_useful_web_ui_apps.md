# Useful Web UI Apps For Raspberry Pi Homelab

If your Raspberry Pi is becoming a real remote lab host, terminal-only workflows eventually become too slow.

This note lists lightweight web UI tools that are actually useful on a small headless Raspberry Pi.

The goal is not to install everything.

The goal is to choose a few UI tools that improve daily work without wasting memory.

For useful terminal-side tools and one-command install scripts, also see [15_useful_headless_apps.md](/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/15-raspberry-pi-homelab/learning-materials/15_useful_headless_apps.md).

## One-Command Compose Setup

If you want a cleaner setup than separate `docker run` commands, use the ready stack from this repository:

`/srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/ops-ui`

Fastest path:

```bash
sudo bash /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/scripts/setup/raspberry-pi/install-ops-ui.sh
```

Quick start:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/ops-ui
cp .env.example .env
mkdir -p /srv/rs-data-platform/runtime/portainer/data
mkdir -p /srv/rs-data-platform/runtime/filebrowser/config
docker compose up -d
```

Read more in:

- [shared/docker/compose/raspberry-pi/ops-ui/README.md](/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/ops-ui/README.md)

Default URLs:

- Portainer: `http://pi5.local:9005`
- Dozzle: `http://pi5.local:9999`
- File Browser: `http://pi5.local:8089`
- Uptime Kuma: `http://pi5.local:3001`

## Post-Install Checklist

After starting the stack, use this short checklist.

### 1. Check container status

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/ops-ui
docker compose ps
```

Expected services:

- `rpi-portainer`
- `rpi-dozzle`
- `rpi-filebrowser`
- `rpi-uptime-kuma`

### 2. Open the web UIs

- Portainer: `http://pi5.local:9005`
- Dozzle: `http://pi5.local:9999`
- File Browser: `http://pi5.local:8089`
- Uptime Kuma: `http://pi5.local:3001`

If hostname resolution fails, use the Raspberry Pi IP instead of `pi5.local`.

### 3. First actions in Portainer

1. Create the first admin user.
2. Choose the local Docker environment.
3. Verify that Airflow, MinIO, Postgres, and the new ops UI containers are visible.

### 4. First actions in Dozzle

Open logs for:

- `rpi-airflow-webserver`
- `rpi-airflow-scheduler`
- `rpi-minio`
- `rpi-uptime-kuma`

### 5. First folders to inspect in File Browser

- `/srv/runtime/airflow`
- `/srv/runtime/minio`
- `/srv/configs/shared`
- `/srv/repo/rs-data-platform-roadmap`

### 6. First monitors to add in Uptime Kuma

Add these URLs first:

- `http://pi5.local:8088`
- `http://pi5.local:9001`
- `http://pi5.local:9000/minio/health/live`
- `http://pi5.local:9005`
- `http://pi5.local:9999`
- `http://pi5.local:8089`

Recommended monitor list:

1. `Airflow UI`
	URL: `http://pi5.local:8088`
	Type: `HTTP(s)`
2. `MinIO Console`
	URL: `http://pi5.local:9001`
	Type: `HTTP(s)`
3. `MinIO Health`
	URL: `http://pi5.local:9000/minio/health/live`
	Type: `HTTP(s)`
4. `Portainer`
	URL: `http://pi5.local:9005`
	Type: `HTTP(s)`
5. `Dozzle`
	URL: `http://pi5.local:9999`
	Type: `HTTP(s)`
6. `File Browser`
	URL: `http://pi5.local:8089`
	Type: `HTTP(s)`
7. `Uptime Kuma`
	URL: `http://pi5.local:3001`
	Type: `HTTP(s)`

If `pi5.local` does not resolve on your Mac or another client device, replace it with `192.168.1.110`.

Suggested tags:

- `core` for Airflow and MinIO
- `ops-ui` for Portainer, Dozzle, File Browser, and Uptime Kuma

Suggested interval for a small homelab:

- every `60` seconds for UI services
- every `30` seconds for `MinIO Health`

### 7. If something does not open

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/ops-ui
docker compose logs portainer
docker compose logs dozzle
docker compose logs filebrowser
docker compose logs uptime-kuma
```

### 8. Check listening ports quickly

```bash
sudo lsof -iTCP -sTCP:LISTEN -P -n | egrep '9005|9999|8089|3001'
```

## Best First Picks

If you want only the most useful web UI tools first, start with:

1. Portainer
2. Dozzle
3. File Browser

That combination covers:

- Docker container visibility
- live logs in browser
- file browsing on the host

## 1. Portainer

Portainer is the most useful first web UI if you run Docker on Raspberry Pi.

Use it for:

- seeing containers, images, volumes, and networks
- starting and stopping containers
- inspecting environment variables and mounts
- browsing Docker state without typing long commands

Why it is useful:

- much easier than reading `docker ps`, `docker inspect`, and `docker volume ls` separately
- good for learning Docker structure visually

What it replaces partially:

- repeated `docker ps`
- repeated `docker inspect`
- some compose troubleshooting

Tradeoff:

- useful, but not mandatory if you are still learning CLI first

Quick Docker run example:

```bash
docker volume create portainer_data

docker run -d \
	--name portainer \
	--restart unless-stopped \
	-p 9005:9000 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v portainer_data:/data \
	portainer/portainer-ce:latest
```

Open in browser:

- `http://pi5.local:9005`
- `http://192.168.1.110:9005`

What to do first in UI:

1. Create the first admin user.
2. Choose the local Docker environment.
3. Open `Containers` and verify your Airflow, MinIO, and Postgres services are visible.

## 2. Dozzle

Dozzle is a lightweight web UI for Docker logs.

Use it for:

- reading container logs in browser
- following logs live
- quickly switching between services

Why it is useful:

- much faster than repeatedly running `docker compose logs ...`
- very lightweight compared to bigger monitoring stacks

Good fit for Raspberry Pi:

- yes, very good

Quick Docker run example:

```bash
docker run -d \
	--name dozzle \
	--restart unless-stopped \
	-p 9999:8080 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	amir20/dozzle:latest
```

Open in browser:

- `http://pi5.local:9999`
- `http://192.168.1.110:9999`

What to do first in UI:

1. Select `rpi-airflow-webserver`.
2. Select `rpi-airflow-scheduler`.
3. Select `rpi-minio`.
4. Use it as a faster replacement for repeated `docker compose logs` commands.

## 3. File Browser

File Browser gives you a simple web UI for files and folders.

Use it for:

- browsing runtime directories
- downloading logs or config files
- uploading small files without `scp`
- checking what is actually stored under `/srv/rs-data-platform`

Why it is useful:

- very convenient for a headless box
- especially helpful when comparing runtime files, config files, and mounted volumes

Good fit for Raspberry Pi:

- yes, if you keep its scope narrow and point it only at directories you need

Quick Docker run example:

```bash
mkdir -p /srv/rs-data-platform/runtime/filebrowser

docker run -d \
	--name filebrowser \
	--restart unless-stopped \
	-p 8089:80 \
	-v /srv/rs-data-platform:/srv \
	-v /srv/rs-data-platform/runtime/filebrowser:/config \
	filebrowser/filebrowser:latest
```

Open in browser:

- `http://pi5.local:8089`
- `http://192.168.1.110:8089`

Practical first folders to inspect:

- `/srv/runtime/airflow`
- `/srv/runtime/minio`
- `/srv/configs/shared`
- `/srv/repo/rs-data-platform-roadmap`

## 4. Uptime Kuma

Uptime Kuma is a simple service status dashboard.

Use it for:

- checking whether Airflow, MinIO, and other services respond
- keeping a small status page for your homelab
- seeing if a service goes down overnight

Why it is useful:

- easier than manually opening every service URL
- good if you keep several web services running on the Pi

Good fit for Raspberry Pi:

- yes, but not as essential as Portainer or Dozzle

Quick Docker run example:

```bash
docker volume create uptime-kuma

docker run -d \
	--name uptime-kuma \
	--restart unless-stopped \
	-p 3001:3001 \
	-v uptime-kuma:/app/data \
	louislam/uptime-kuma:1
```

Open in browser:

- `http://pi5.local:3001`
- `http://192.168.1.110:3001`

Good first monitors to add:

- `http://pi5.local:8088`
- `http://pi5.local:9001`
- `http://pi5.local:9000/minio/health/live`

## 5. Netdata

Netdata is a more detailed host monitoring UI.

Use it for:

- CPU, RAM, disk, and network monitoring
- seeing spikes and resource pressure visually

Why it is useful:

- very nice operational dashboard
- good for understanding what your containers do to the host

Tradeoff:

- heavier than the other tools in this list
- probably not the first thing I would install on a small Pi homelab

Quick Docker run example:

```bash
docker run -d \
	--name netdata \
	--restart unless-stopped \
	-p 19999:19999 \
	--cap-add SYS_PTRACE \
	--security-opt apparmor=unconfined \
	netdata/netdata:stable
```

Open in browser:

- `http://pi5.local:19999`
- `http://192.168.1.110:19999`

## What I Would Install In Your Case

Given your current setup with Docker, Airflow, and MinIO, I would choose this order:

1. Portainer
2. Dozzle
3. File Browser
4. Uptime Kuma

I would delay Netdata until you actually feel blind on CPU or memory usage.

## What Each Tool Helps You See

### Container View

Use Portainer when you want to inspect:

- running containers
- restart loops
- mounted volumes
- published ports

### Log View

Use Dozzle when you want to inspect:

- Airflow logs
- MinIO logs
- PostgreSQL logs
- startup failures

### File View

Use File Browser when you want to inspect:

- `/srv/rs-data-platform/runtime`
- `/srv/rs-data-platform/configs`
- Airflow DAG files
- downloaded logs or artifacts

### Availability View

Use Uptime Kuma when you want to inspect:

- `http://pi5.local:8088`
- `http://pi5.local:9001`
- any future dashboards or APIs

## What Not To Do

Do not install too many dashboards at once.

On Raspberry Pi this usually leads to:

- wasted RAM
- more open ports
- more services to maintain
- more confusion instead of more visibility

Keep the UI layer small and intentional.

## Practical Recommendation

If you want the highest practical value per resource spent:

1. Portainer for Docker UI
2. Dozzle for logs UI
3. File Browser for files UI

That trio is enough for most Raspberry Pi homelab work.

## Short Start Commands

If you want the shortest practical start, these are the three commands I would use first:

```bash
docker volume create portainer_data
docker run -d --name portainer --restart unless-stopped -p 9005:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

docker run -d --name dozzle --restart unless-stopped -p 9999:8080 -v /var/run/docker.sock:/var/run/docker.sock amir20/dozzle:latest

mkdir -p /srv/rs-data-platform/runtime/filebrowser && docker run -d --name filebrowser --restart unless-stopped -p 8089:80 -v /srv/rs-data-platform:/srv -v /srv/rs-data-platform/runtime/filebrowser:/config filebrowser/filebrowser:latest
```

Then open:

- Portainer: `http://pi5.local:9005`
- Dozzle: `http://pi5.local:9999`
- File Browser: `http://pi5.local:8089`

## Recommended Use Pattern

Use the tools like this:

1. Open Portainer when you want to inspect containers, ports, and volumes.
2. Open Dozzle when something is failing and you want logs quickly.
3. Open File Browser when you want to inspect runtime folders without `scp` or `mc`.

## Suggested Next Step

The ready `ops-ui` stack already includes:

- Portainer
- Dozzle
- File Browser
- Uptime Kuma

Use it when you want one browser-side toolbox instead of four separate ad-hoc containers.