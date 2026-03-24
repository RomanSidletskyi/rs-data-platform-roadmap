# Debugging And Inspection

## Task 1 — Diagnose A Crashing Container

### Goal

Use logs to understand why a container exits.

### Input

A container that stops shortly after start because of one of these realistic issues:

- wrong command
- missing file
- missing env var
- wrong working directory

### Requirements

- inspect the container status
- read logs
- identify the likely reason for failure

### Expected Output

A short diagnosis based on runtime evidence.

### Extra Challenge

Suggest one fix without rebuilding blindly.

## Task 2 — Inspect Environment Variables Inside A Container

### Goal

Verify runtime configuration directly.

### Input

A running service with environment variables.

### Requirements

- enter the container or inspect it appropriately
- identify the configured environment values
- explain why this is useful during debugging
- mention one risk of assuming the Compose file and runtime container always match perfectly

### Expected Output

A verified list or example of runtime env values.

### Extra Challenge

Compare the configured value from Compose with what is visible in the container.

## Task 3 — Check Files Inside A Running Container

### Goal

Confirm file placement and mounts.

### Input

A running container with mounted or copied files.

### Requirements

- inspect the relevant directory inside the container
- confirm whether expected files exist
- explain what this tells you about the build or mount behavior
- distinguish whether the file should come from `COPY` or from a runtime mount

### Expected Output

A short verification note about runtime files.

### Extra Challenge

Explain one common reason a file might be missing.

## Task 4 — Fix A Port Mapping Problem

### Goal

Learn to reason about service reachability.

### Input

A service that is running but not reachable from the host.

### Requirements

- inspect the port mapping
- explain the likely cause
- propose the corrected mapping
- explain whether the problem is host access, internal service access, or both

### Expected Output

A short diagnosis and corrected port configuration.

### Extra Challenge

Explain how this differs from a service-to-service networking issue.

## Task 5 — Debug A Broken Compose Setup

### Goal

Practice multi-service debugging.

### Input

A Compose stack where one service cannot reach another.

### Requirements

- inspect the Compose service state
- read logs
- identify at least one likely configuration issue
- explain the fix
- mention whether the failure is caused by configuration, readiness, storage, or networking

### Expected Output

A short troubleshooting report.

### Extra Challenge

Mention readiness vs startup order if relevant.

## Optional Hard Mode

Create a short troubleshooting checklist for one realistic stack such as:

- `etl + postgres`
- `api + worker + postgres`
- `app + postgres + minio`

Your checklist should cover:

- logs
- env vars
- ports
- service names
- volumes
- readiness