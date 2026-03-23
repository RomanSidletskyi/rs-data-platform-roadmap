# Starter Notes For docker

Create Docker assets for the guided project here.

Recommended minimum:

- one `Dockerfile` for the ETL app
- one `docker-compose.yml` for ETL plus Postgres

Your Compose stack should:

- define a named volume for Postgres
- pass runtime settings through env vars
- let the ETL app reach Postgres through the service name