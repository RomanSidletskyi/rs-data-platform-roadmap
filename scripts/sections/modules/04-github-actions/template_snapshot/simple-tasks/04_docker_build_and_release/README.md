# 04 Docker Build And Release

## Task 1 — Validate Docker Build On Pull Request

### Goal

Ensure a Docker image can be built before merge.

### Input

A repository with a Dockerfile.

### Requirements

- trigger on PR
- build the image without pushing it
- fail if the Docker build breaks

### Expected Output

A safe Docker validation workflow.

## Task 2 — Push On Main

### Goal

Publish a Docker image only after merge to `main`.

### Requirements

- separate validation and publish concerns
- authenticate with the registry using secrets
- tag the image explicitly

### Expected Output

A publish workflow with a controlled trigger.

## Task 3 — Tag Strategy

### Goal

Design a tag scheme that is traceable.

### Requirements

- include at least one immutable tag
- explain why `latest` alone is weak

### Expected Output

A short note and example tag values.