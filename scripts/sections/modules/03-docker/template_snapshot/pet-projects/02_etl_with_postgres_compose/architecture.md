# Architecture - 02 ETL With Postgres Compose

## Components

- ETL application service
- Postgres database service
- sample input dataset
- persistent database volume

## Target Project Shape

The intended implementation should include:

- one ETL application container
- one Postgres service managed by Compose
- one raw table for loaded source records
- one transformed analytics-oriented output

## Data Flow

1. ETL reads local source data
2. ETL transforms records
3. ETL writes results into Postgres
4. validation queries confirm the load

## Storage Model

- source files live in `data/`
- Postgres state lives in a named volume
- application code lives in the built image or mounted project files depending on the chosen pattern

## Configuration Model

- file paths should be configurable through env vars or config files
- database host should come from the Compose service name
- credentials should come from `.env.example`-style runtime configuration

## Network Model

- ETL reaches Postgres through the Compose service name
- host clients reach Postgres only if a host port is published

## Target Outputs

Your implementation should produce at least:

- one loaded raw table
- one transformed summary output such as daily totals or region totals
- logs or SQL checks that prove the load succeeded

## Trade-Offs

- mounting source code is convenient for fast iteration
- building the app image is closer to real packaging practice
- one compose file is simple, but can become noisy if too many responsibilities are added

## What Would Change In Production

- external database service
- stronger schema management
- secrets management beyond local env files
- orchestration or scheduled execution