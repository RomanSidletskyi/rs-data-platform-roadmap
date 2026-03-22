# Solution - Monitoring And Operations

This solution gives you a basic operational checklist without adding a full monitoring stack yet.

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

1. `docker ps`
2. `docker logs <container-name>`
3. `free -h`
4. `df -h`
5. `journalctl -xe --no-pager | tail -n 50`

This usually tells you whether the problem is container-level, memory-level, or disk-level.

## 4. Restart A Failing Container

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
- you can read Docker logs
- you can restart a broken service
- you have a small repeatable health-check flow