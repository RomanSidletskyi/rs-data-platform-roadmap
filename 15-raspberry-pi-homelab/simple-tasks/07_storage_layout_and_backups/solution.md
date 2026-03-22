# Solution - Storage Layout And Backups

This solution gives you a simple host layout that matches the repository design.

## 1. Create Base Directories

On Raspberry Pi:

```bash
sudo mkdir -p /srv/rs-data-platform/{repo,runtime,data,logs,backups,configs}
sudo chown -R $USER:$USER /srv/rs-data-platform
```

Check:

```bash
tree -L 2 /srv/rs-data-platform
```

If `tree` is missing:

```bash
sudo apt install -y tree
tree -L 2 /srv/rs-data-platform
```

## 2. Create A Practical Structure

```bash
mkdir -p /srv/rs-data-platform/runtime/{airflow,postgres,minio,shared}
mkdir -p /srv/rs-data-platform/data/{raw,bronze,silver,gold,generated}
mkdir -p /srv/rs-data-platform/logs/{airflow,docker,python-jobs}
```

## 3. Clone The Repository Into The Repo Area

```bash
cd /srv/rs-data-platform/repo
git clone <your-repo-url>
```

If already cloned:

```bash
cd /srv/rs-data-platform/repo/rs-data-platform-roadmap
git pull
```

## 4. Decide What Must Not Live In Git

Keep out of git:

- `/srv/rs-data-platform/runtime/`
- `/srv/rs-data-platform/data/`
- `/srv/rs-data-platform/logs/`
- `/srv/rs-data-platform/configs/`

Keep in git:

- compose files
- scripts
- docs
- templates
- small sample datasets only

## 5. Create A Simple Backup Folder

```bash
mkdir -p /srv/rs-data-platform/backups/daily
```

Example manual backup of configs:

```bash
tar -czf /srv/rs-data-platform/backups/daily/configs-$(date +%F).tar.gz /srv/rs-data-platform/configs
```

Example manual backup of one runtime folder:

```bash
tar -czf /srv/rs-data-platform/backups/daily/minio-data-$(date +%F).tar.gz /srv/rs-data-platform/runtime/minio
```

## 6. Definition Of Done Check

Run:

```bash
ls -la /srv/rs-data-platform
du -sh /srv/rs-data-platform/*
```

This task is complete if:

- repo, runtime, data, logs, backups, and configs exist
- runtime state is separate from git-managed code
- you can describe what should be backed up first