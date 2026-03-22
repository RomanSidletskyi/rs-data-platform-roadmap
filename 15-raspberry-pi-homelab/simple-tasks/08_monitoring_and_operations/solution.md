# Solution - Monitoring And Operations

This solution gives you a basic operational checklist for both host services and container-based services.

## 1. Install Basic Tools

On Raspberry Pi:

```bash
sudo apt update
sudo apt install -y htop btop iftop ncdu
```

If some packages are unavailable, keep at least `htop` and `ncdu`.

## 2. Core Health Commands

CPU and memory:

```bash
htop
free -h
uptime
```

Disk:

```bash
df -h
du -sh /srv/rs-data-platform/*
ncdu /srv/rs-data-platform
```

Docker:

```bash
docker ps
docker stats --no-stream
docker logs <container-name>
```

System services:

```bash
systemctl --failed
journalctl -xe --no-pager | tail -n 50
```

## 3. Example Operational Routine

When something looks wrong, check in this order:

1. `systemctl --failed`
2. `journalctl -xe --no-pager | tail -n 50`
3. `docker ps`
4. `docker logs <container-name>`
5. `free -h`
6. `df -h`

This usually tells you whether the problem is container-level, memory-level, or disk-level.

## 4. Restart A Failing Service

If it is a `systemd` service:

```bash
sudo systemctl restart my-python-service
systemctl status my-python-service
```

If it is a container:

```bash
docker restart <container-name>
docker logs <container-name>
```

If a service is started by compose:

```bash
docker compose ps
docker compose logs
docker compose restart
```

## 5. Save A Quick Health Snapshot

```bash
echo "=== $(date) ===" >> /srv/rs-data-platform/logs/health-check.log
uptime >> /srv/rs-data-platform/logs/health-check.log
free -h >> /srv/rs-data-platform/logs/health-check.log
df -h >> /srv/rs-data-platform/logs/health-check.log
docker ps >> /srv/rs-data-platform/logs/health-check.log
```

## 6. Definition Of Done Check

This task is complete if:

- you know how to inspect CPU, memory, and disk usage
- you can read service logs with `journalctl` or Docker logs
- you can restart a broken service
- you have a small repeatable health-check flow