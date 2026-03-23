# Architecture - 03 API Worker And DB Stack

## Components

- API service
- worker service
- Postgres database
- optional client or test request source

## Current Example

The implemented reference uses:

- one Flask API process
- one worker loop process
- one Postgres database
- one sample request payload used for end-to-end testing

## Target Project Shape

The intended implementation should include:

- one API process for request intake
- one worker process for background processing
- one Postgres service for persistence
- one sample request payload to test the end-to-end flow

## Data Flow

1. client sends a request to the API
2. API records work metadata
3. worker processes the job
4. worker stores results or status updates in the database

## Responsibility Boundaries

- API handles request intake and response shaping
- worker handles asynchronous processing logic
- database handles persistence and state

## Configuration Model

- runtime settings should come from env vars or config files
- service connectivity should be described in Compose
- database credentials should stay outside source code

Current runtime variables:

- `APP_ENV`
- `API_PORT`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_HOST`
- `POSTGRES_PORT`
- `APP_CONFIG_PATH`

## Network Model

- services communicate over the Compose network
- API may publish a host port
- internal service references should use service names

## Target Outputs

Your implementation should produce at least:

- a persisted job record
- a processed status or result update
- logs that show the request flow across API and worker

In this reference example, the worker writes:

- a completed status to `jobs`
- a JSON result payload to `job_results`

## Trade-Offs

- separating API and worker improves clarity but adds coordination overhead
- one shared codebase can be simpler, but clearer service boundaries are often better for learning
- local Compose is enough for system thinking, but not equivalent to full production orchestration

## What Would Change In Production

- stronger queueing model
- proper observability
- more robust deployment and scaling strategy
- authentication and operational hardening