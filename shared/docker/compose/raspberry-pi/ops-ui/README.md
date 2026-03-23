# Ops UI Stack For Raspberry Pi

This stack provides lightweight browser-based tools for a Raspberry Pi homelab.

Included services:

- Portainer for Docker UI
- Dozzle for live Docker logs
- File Browser for host file browsing
- Uptime Kuma for service availability monitoring

## First Start

Fastest path:

```bash
sudo bash /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/scripts/setup/raspberry-pi/install-ops-ui.sh
```

Manual path:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap/shared/docker/compose/raspberry-pi/ops-ui
cp .env.example .env
mkdir -p /srv/rs-data-platform/runtime/portainer/data
mkdir -p /srv/rs-data-platform/runtime/filebrowser/config
mkdir -p /srv/rs-data-platform/runtime/uptime-kuma/data
docker compose up -d
```

## Default Ports

- Portainer: `9005`
- Dozzle: `9999`
- File Browser: `8089`
- Uptime Kuma: `3001`

## Open In Browser

- Portainer: `http://pi5.local:9005`
- Dozzle: `http://pi5.local:9999`
- File Browser: `http://pi5.local:8089`
- Uptime Kuma: `http://pi5.local:3001`

## Post-Install Checklist

Check container status:

```bash
docker compose ps
```

Open in browser:

- Portainer: `http://pi5.local:9005`
- Dozzle: `http://pi5.local:9999`
- File Browser: `http://pi5.local:8089`
- Uptime Kuma: `http://pi5.local:3001`

Suggested first actions:

1. Create the first admin user in Portainer.
2. Verify that Docker services are visible in Portainer.
3. Open Dozzle and check logs for Airflow and MinIO.
4. Open File Browser and inspect `/srv/runtime` and `/srv/configs/shared`.
5. Add the main service URLs into Uptime Kuma.

Recommended Uptime Kuma monitor list:

- `Airflow UI` -> `http://pi5.local:8088`
- `MinIO Console` -> `http://pi5.local:9001`
- `MinIO Health` -> `http://pi5.local:9000/minio/health/live`
- `Portainer` -> `http://pi5.local:9005`
- `Dozzle` -> `http://pi5.local:9999`
- `File Browser` -> `http://pi5.local:8089`
- `Uptime Kuma` -> `http://pi5.local:3001`

## Stop

```bash
docker compose down
```

## Logs

```bash
docker compose logs portainer
docker compose logs dozzle
docker compose logs filebrowser
docker compose logs uptime-kuma
```