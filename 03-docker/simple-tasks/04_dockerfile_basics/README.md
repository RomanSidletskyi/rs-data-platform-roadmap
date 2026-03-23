# Dockerfile Basics

## Task 1 — Containerize A Python Script

### Goal

Package a small Python script into an image.

### Input

A small Python project with:

- `src/main.py`
- `requirements.txt`
- one input path expected through an environment variable

### Requirements

- create a minimal Dockerfile
- use an appropriate Python base image
- copy only the files required for runtime
- keep machine-specific paths out of the image

### Expected Output

A valid Dockerfile for a small but realistic Python application.

### Extra Challenge

Explain why `python:3.12-slim` is often a better learning default than a large full image.

## Task 2 — Build Your First Image

### Goal

Turn source code into a Docker artifact.

### Input

The Dockerfile from Task 1.

### Requirements

- build the image
- assign a custom versioned tag such as `app-name:0.1.0`
- confirm the image exists locally
- inspect image metadata or history at least once

### Expected Output

A successfully built local image.

### Extra Challenge

Rebuild after a code change and explain which layer should be reused from cache.

## Task 3 — Add A .dockerignore File

### Goal

Reduce unnecessary build context.

### Input

A small project folder with local development artifacts.

### Requirements

- add `.dockerignore`
- exclude at least `.venv`, cache files, git metadata, and one local-only config or output path
- explain why this matters

### Expected Output

A cleaner build context.

### Extra Challenge

Add one project-specific ignored path such as generated outputs.

## Task 4 — Run Your Own Image

### Goal

Validate that the built image works at runtime.

### Input

The image built in Task 2.

### Requirements

- run the image
- verify the expected output
- explain what `CMD` does in this example
- pass at least one environment variable at runtime

### Expected Output

A successful container run from your own image.

### Extra Challenge

Override the default command temporarily.

## Task 5 — Improve A Basic Dockerfile

### Goal

Move from working to cleaner image design.

### Input

A naive Dockerfile.

### Requirements

- improve naming or structure
- keep the image focused on runtime needs
- explain at least two improvements clearly
- mention one trade-off related to convenience vs reproducibility

### Expected Output

An improved Dockerfile and a short design note.

### Extra Challenge

Add a note about build cache or layer ordering.

## Optional Hard Mode

Take the same project and write two Dockerfiles:

- one for a batch job
- one for an API-style process

Then compare:

- base image choice
- runtime command
- exposed ports
- mounted files versus baked-in files