# Secrets Management For Local And Raspberry Pi Usage

This topic is shared across the whole repository, not only Raspberry Pi.

Canonical document:

- [shared/environments/secrets-management.md](../../shared/environments/secrets-management.md)

Use this Raspberry Pi module note as a reminder of one Pi-specific rule:

- if a secret is used by a service running on Raspberry Pi, store the real runtime value on Raspberry Pi, not in the repository

Recommended Raspberry Pi runtime path:

```text
/srv/rs-data-platform/configs/
```

Examples:

- `/srv/rs-data-platform/configs/airflow/.env`
- `/srv/rs-data-platform/configs/minio/.env`
- `/srv/rs-data-platform/configs/postgres/.env`

The repository should keep only templates such as `.env.example`.