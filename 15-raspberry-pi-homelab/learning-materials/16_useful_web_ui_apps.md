# Useful Web UI Apps For Raspberry Pi Homelab

If your Raspberry Pi is becoming a real remote lab host, terminal-only workflows eventually become too slow.

This note lists lightweight web UI tools that are actually useful on a small headless Raspberry Pi.

The goal is not to install everything.

The goal is to choose a few UI tools that improve daily work without wasting memory.

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

## Suggested Next Step

If you want, the next practical move is to add a tiny Docker Compose stack for:

- Portainer
- Dozzle
- File Browser

so you can manage the Raspberry Pi more comfortably from the browser.