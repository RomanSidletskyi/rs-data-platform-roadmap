# Dockerfile Basics

## Why This Topic Matters

Using prebuilt images is useful, but real engineering work requires packaging your own code. Dockerfile is the bridge between application source code and a reusable runtime artifact.

## Core Concepts

- `FROM` selects the base image
- `WORKDIR` sets the working directory inside the image
- `COPY` moves files into the build context
- `RUN` executes build-time commands
- `CMD` defines the default runtime command
- `.dockerignore` keeps unnecessary files out of the build context

## How It Works

Docker builds images step by step. Each instruction contributes to the final artifact and can affect cache reuse, build speed, and image size.

## Practical Example

Python script:

```python
import json

result = {"status": "ok", "records_processed": 25}
print(json.dumps(result))
```

Basic Dockerfile:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY app.py .

CMD ["python", "app.py"]
```

Build and run:

```bash
docker build -t python-demo-app .
docker run --rm python-demo-app
```

## Cookbook Example - Small Python Batch Job

Example project layout:

```text
project/
├── src/
│   └── main.py
├── data/
│   └── input.csv
├── requirements.txt
└── Dockerfile
```

Example `requirements.txt`:

```text
requests==2.32.3
```

Example `src/main.py`:

```python
import json
import os
from pathlib import Path

input_path = Path(os.getenv("INPUT_PATH", "/data/input.csv"))

result = {
		"input_exists": input_path.exists(),
		"input_path": str(input_path),
}

print(json.dumps(result))
```

Naive Dockerfile:

```dockerfile
FROM python:3.12

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

CMD ["python", "src/main.py"]
```

Improved Dockerfile:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ /app/src/

ENV PYTHONPATH=/app/src

CMD ["python", "/app/src/main.py"]
```

Run with a mounted input file:

```bash
docker build -t batch-cookbook-demo .

docker run --rm \
	-e INPUT_PATH=/data/input.csv \
	-v "$PWD/data:/data:ro" \
	batch-cookbook-demo
```

Why the improved version is better:

- smaller base image
- dependency installation cached separately from source code changes
- less accidental copying into the image
- clearer runtime boundary

## Cookbook Example - API Service With Dependencies

Example Dockerfile for a tiny API project:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ /app/src/

EXPOSE 8000

CMD ["python", "/app/src/api_app.py"]
```

Useful build and inspect commands:

```bash
docker build -t api-demo:0.1.0 .
docker images api-demo
docker history api-demo:0.1.0
docker run --rm -p 8000:8000 api-demo:0.1.0
```

## Build Cache Walkthrough

Order matters.

If your Dockerfile does this:

```dockerfile
COPY . .
RUN pip install -r requirements.txt
```

then any source-code change may invalidate the dependency install layer.

If your Dockerfile does this:

```dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY src/ /app/src/
```

then source-code changes usually keep the dependency layer cached.

This matters because build speed affects daily iteration speed.

`.dockerignore` example:

```text
.venv
__pycache__
.pytest_cache
.git
data/output
```

## Better Practices

- choose a specific base image tag when reproducibility matters
- keep the build context small
- avoid copying secrets into images
- separate build-time dependencies from runtime needs when the project grows

## Common Mistakes

- copying the whole repository without a `.dockerignore`
- using overly large base images without a reason
- putting environment-specific secrets in the image
- misunderstanding build-time vs runtime behavior
- copying local `.env` files and tokens into the image build context
- writing a Dockerfile that works only when run from one specific host path

## Common Debug Checks

When an image builds but the container fails at runtime, check:

```bash
docker run --rm image-name
docker run --rm --entrypoint sh image-name
docker inspect image-name
```

Questions to ask:

- does the expected file actually exist inside the image
- is the runtime command correct
- does the app expect env vars or mounted files that were never provided
- was the wrong build context used

## Architectural View

Dockerfile is not just a packaging script. It is a declaration of runtime assumptions. Poor image design leads to larger artifacts, slower builds, harder debugging, and higher delivery friction.

## Trade-Offs

- smaller images improve pull speed but may require more explicit setup
- more build steps can improve clarity but affect build complexity
- convenience choices can reduce reproducibility if not controlled

## How It Connects To Data Engineering

Dockerfiles are used to package:

- Python ETL jobs
- API services
- utility scripts
- validation tools
- orchestration-related support code

Common cookbook patterns in data work:

- package a CSV-to-Postgres batch loader
- package a validation job that fails fast on bad schema
- package an API that triggers a background processing flow
- package a local utility that writes artifacts into MinIO

## What To Practice Next

After this topic, practice:

- building a Python image from a small project
- improving `.dockerignore`
- rebuilding after a code change
- comparing a naive and improved Dockerfile

Optional hard mode:

- build one image for a batch job and another for an API service
- compare the two Dockerfiles and explain which layers differ because of runtime behavior