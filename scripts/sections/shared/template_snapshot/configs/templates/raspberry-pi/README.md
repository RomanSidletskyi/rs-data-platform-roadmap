# Raspberry Pi Config Templates

This directory is reserved for Raspberry Pi specific configuration templates.

Typical contents:

- `.env.example` files
- service config templates
- SSH or host setup examples
- compose-related runtime config examples

The first stack-specific example environment file currently lives next to its compose file:

- `shared/docker/compose/raspberry-pi/airflow-minio-postgres/.env.example`

Host-local runtime template added:

- `shared/configs/templates/raspberry-pi/airflow-minio-postgres.env.example`

Recommended usage on Raspberry Pi:

- copy the template to `/srv/rs-data-platform/configs/shared/airflow-minio-postgres.env`
- keep the real runtime file out of git