# Solution - Install Docker And Run Services

This solution installs Docker on Raspberry Pi and runs one small ARM-friendly service.

## 1. Install Basic Utilities

On Raspberry Pi:

```bash
sudo apt update
sudo apt install -y ca-certificates curl git htop tmux
```

## 2. Install Docker

For a learning lab, a practical path is:

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
```

Verify:

```bash
docker --version
```

## 3. Test Docker

```bash
docker run --rm hello-world
```

Expected result:

- Docker pulls the image
- the container runs successfully
- the container exits cleanly

## 4. Run A Real Small Service

Example with Nginx:

```bash
docker run -d --name rpi-nginx -p 8080:80 nginx:alpine
```

Check container state:

```bash
docker ps
docker logs rpi-nginx
```

From your Mac:

```bash
curl http://192.168.1.50:8080
```

Replace the IP with your Raspberry Pi IP.

## 5. Try A Data-Lab Friendly Service

If you want something closer to the repo use MinIO:

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

Check it:

```bash
docker ps
docker logs minio
```

## 6. Clean Up Test Containers

```bash
docker stop rpi-nginx || true
docker rm rpi-nginx || true
```

If you ran MinIO and want to remove it:

```bash
docker stop minio
docker rm minio
```

## 7. Definition Of Done Check

This task is complete if:

- `docker --version` works
- `hello-world` runs successfully
- one real service starts in background
- `docker ps` shows the running service
- you can inspect logs and mounted data directories