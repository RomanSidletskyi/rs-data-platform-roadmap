# Systemd Python Service Cheatsheet

## Purpose

This note shows the shortest path to run a Python script as a background service on Raspberry Pi without Docker.

Use it when you want to:

- start a Python worker automatically after boot
- keep a script running in the background
- restart it if it fails
- inspect logs with standard Linux tools

## When To Use This

Use `systemd` when:

- the service is simple
- you do not need containers yet
- you want the Raspberry Pi to run a Python script like a normal host process

## Example Directory Layout

Example paths:

```text
/srv/rs-data-platform/runtime/my-python-service/
/srv/rs-data-platform/runtime/my-python-service/app.py
/srv/rs-data-platform/runtime/my-python-service/.venv/
```

## Create A Virtual Environment

```bash
cd /srv/rs-data-platform/runtime/my-python-service
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

## Example App Command

Assume your entrypoint is:

```bash
/srv/rs-data-platform/runtime/my-python-service/.venv/bin/python app.py
```

## Example Systemd Unit

Create:

```text
/etc/systemd/system/my-python-service.service
```

Example content:

```ini
[Unit]
Description=My Python Service
After=network.target

[Service]
Type=simple
User=rsidletskyi
WorkingDirectory=/srv/rs-data-platform/runtime/my-python-service
ExecStart=/srv/rs-data-platform/runtime/my-python-service/.venv/bin/python app.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

## Enable And Start The Service

```bash
sudo systemctl daemon-reload
sudo systemctl enable my-python-service
sudo systemctl start my-python-service
```

## Useful Systemd Commands

Check status:

```bash
systemctl status my-python-service
```

Restart:

```bash
sudo systemctl restart my-python-service
```

Stop:

```bash
sudo systemctl stop my-python-service
```

Disable autostart:

```bash
sudo systemctl disable my-python-service
```

Follow logs:

```bash
journalctl -u my-python-service -f
```

Show recent logs:

```bash
journalctl -u my-python-service --no-pager -n 100
```

## Update The Python Service

Typical update flow:

```bash
cd /srv/rs-data-platform/runtime/my-python-service
source .venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart my-python-service
```

## Good Practice

- keep one service per unit file
- use a virtual environment
- keep app files under `/srv/rs-data-platform/runtime`
- use `journalctl` first when debugging
- do not run the service as `root` unless really necessary

## Short Version

Create service file:

```text
/etc/systemd/system/my-python-service.service
```

Reload and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable my-python-service
sudo systemctl start my-python-service
```

Inspect logs:

```bash
journalctl -u my-python-service -f
```