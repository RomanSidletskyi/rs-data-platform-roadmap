# Solution - Optional Systemd Python Service

This solution runs a very small Python service directly on Raspberry Pi without Docker.

## 1. Create Service Folder

```bash
mkdir -p /srv/rs-data-platform/runtime/my-python-service
cd /srv/rs-data-platform/runtime/my-python-service
```

## 2. Create A Small Python Script

```bash
cat > app.py <<'EOF'
import time

while True:
    print("service is alive", flush=True)
    time.sleep(30)
EOF
```

## 3. Create Virtual Environment

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
```

## 4. Create Systemd Unit

```bash
sudo nano /etc/systemd/system/my-python-service.service
```

Add:

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

## 5. Enable And Start

```bash
sudo systemctl daemon-reload
sudo systemctl enable my-python-service
sudo systemctl start my-python-service
```

## 6. Inspect Logs

```bash
systemctl status my-python-service
journalctl -u my-python-service --no-pager -n 50
journalctl -u my-python-service -f
```

## 7. Definition Of Done Check

This task is complete if:

- `systemctl status my-python-service` shows it as active
- `journalctl` shows repeated output from the Python script
- the service is enabled for startup