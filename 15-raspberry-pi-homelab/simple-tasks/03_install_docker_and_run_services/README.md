# Simple Task 03 - Install Docker And Run Services

## Goal

Install Docker and run one ARM-compatible service on Raspberry Pi.

Ready answer with concrete steps and commands:

- [solution.md](solution.md)

If Docker is not installed yet, follow:

- [quickstart from first boot to Docker](../../learning-materials/00_quickstart_first_boot_to_docker.md)

## What To Practice

- Docker installation
- verifying ARM image compatibility
- container lifecycle basics
- mounted volumes and ports

## Suggested First Service

- PostgreSQL or MinIO

## Suggested Workflow

1. verify basic packages are installed
2. install Docker
3. confirm your user can run Docker without `sudo`
4. run `hello-world`
5. run one small real service
6. inspect logs and mounted data directories

## Definition Of Done

- Docker is installed and working
- one service starts successfully
- you can inspect logs and persistent storage

## Useful Verification Commands

```bash
docker --version
docker ps
docker run --rm hello-world
docker logs <container-name>
```