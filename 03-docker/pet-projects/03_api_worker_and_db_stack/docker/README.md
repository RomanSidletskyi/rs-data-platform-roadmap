# Starter Notes For docker

Create Docker assets for the guided project here.

Recommended minimum:

- one `docker-compose.yml`
- one or more `Dockerfile` files depending on how you package the API and worker

Your Compose stack should:

- run API, worker, and Postgres together
- publish the API port to the host
- connect services by service name