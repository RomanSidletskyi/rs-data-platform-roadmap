# SCP And Rsync Cheatsheet

## Purpose

This note shows the shortest practical commands for copying files between the main machine and Raspberry Pi.

Use it when you need to:

- copy one file quickly
- copy a folder to Raspberry Pi
- download logs or outputs from Raspberry Pi
- sync a project folder safely

## Assumptions

Examples below assume:

- SSH host alias: `pi5`
- Raspberry Pi user: `rsidletskyi`
- Raspberry Pi root work directory: `/srv/rs-data-platform`

## Quick Copy With SCP

Copy one local file to Raspberry Pi:

```bash
scp ./local-file.txt pi5:/tmp/
```

Copy one local folder to Raspberry Pi:

```bash
scp -r ./local-folder pi5:/srv/rs-data-platform/data/
```

Copy one file from Raspberry Pi to Mac:

```bash
scp pi5:/var/log/syslog ./syslog-from-pi.txt
```

Copy one folder from Raspberry Pi to Mac:

```bash
scp -r pi5:/srv/rs-data-platform/logs ./pi-logs
```

## Practical Rsync Commands

`rsync` is better than `scp` for repeated sync because it copies only changed files.

Sync a local folder to Raspberry Pi:

```bash
rsync -avz ./my-project/ pi5:/srv/rs-data-platform/runtime/my-project/
```

Sync a Raspberry Pi folder back to Mac:

```bash
rsync -avz pi5:/srv/rs-data-platform/logs/ ./logs-from-pi/
```

Sync and delete files on the target that no longer exist locally:

```bash
rsync -avz --delete ./my-project/ pi5:/srv/rs-data-platform/runtime/my-project/
```

## Recommended Patterns

Upload repository helper files to Raspberry Pi:

```bash
rsync -avz ./shared/scripts/ pi5:/srv/rs-data-platform/runtime/shared-scripts/
```

Download logs from Raspberry Pi:

```bash
rsync -avz pi5:/srv/rs-data-platform/logs/ ./tmp/pi-logs/
```

Upload one config template:

```bash
scp ./shared/configs/templates/raspberry-pi/airflow-minio-postgres.env.example pi5:/srv/rs-data-platform/configs/shared/
```

## Useful Options

- `-a` keeps timestamps and permissions where possible
- `-v` prints what is happening
- `-z` compresses transfer data
- `--delete` makes target match source exactly

## Verify Remote Files

After copying:

```bash
ssh pi5 'ls -lah /srv/rs-data-platform'
```

Check one specific target path:

```bash
ssh pi5 'ls -lah /srv/rs-data-platform/configs/shared'
```

## Short Version

Copy one file to Raspberry Pi:

```bash
scp ./file.txt pi5:/tmp/
```

Sync a folder to Raspberry Pi:

```bash
rsync -avz ./folder/ pi5:/srv/rs-data-platform/runtime/folder/
```

Download logs back to Mac:

```bash
rsync -avz pi5:/srv/rs-data-platform/logs/ ./logs-from-pi/
```