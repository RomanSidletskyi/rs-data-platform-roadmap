# Docker

Docker is optional here, but it can make frequent dbt execution and local repetition easier.

Useful options:

- a small dbt runner image for repeated builds
- a shell wrapper for frequent selector runs
- a mock local producer only if it helps explain sample payload generation

Do not overbuild this into a fake streaming platform. The learning goal is the warehouse transformation boundary.
