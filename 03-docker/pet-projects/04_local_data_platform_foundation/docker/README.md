# Starter Notes For docker

Create Docker assets for the guided project here.

Recommended minimum:

- one `Dockerfile` for the application
- one `docker-compose.yml` for Postgres, MinIO, and the processing app

Your Compose stack should:

- persist Postgres state
- persist MinIO state
- publish MinIO API and console ports when needed
- keep app-to-service connectivity inside the Compose network