# Solution - Dockerfile Basics

This topic moves from using existing images to building your own.

## Task 1 — Containerize A Python Script

Example minimal project:

```text
project/
├── src/
│   └── main.py
└── requirements.txt
```

Example `src/main.py`:

```python
import os

print(f"env={os.getenv('APP_ENV', 'dev')}")
```

Example `requirements.txt`:

```text
requests==2.32.3
```

Example Dockerfile:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ /app/src/

CMD ["python", "/app/src/main.py"]
```

Why this is better than `COPY . .` for a small real project:

- runtime files are explicit
- dependency layer is separate
- machine-specific files are less likely to leak into the image

## Task 2 — Build Your First Image

```bash
docker build -t python-script-demo:0.1.0 .
docker images
docker history python-script-demo:0.1.0
```

Use a versioned tag such as `0.1.0` instead of an anonymous local image whenever you want reproducibility.

## Task 3 — Add A .dockerignore File

Example:

```text
.venv
__pycache__
.pytest_cache
.git
data/output
.env
```

This keeps the build context smaller and avoids copying irrelevant files into the image build.

It also reduces the risk of accidentally baking local secrets or generated outputs into the image.

## Task 4 — Run Your Own Image

```bash
docker run --rm -e APP_ENV=prod python-script-demo:0.1.0
```

`CMD` defines the default runtime command if you do not provide one explicitly.

Override the command temporarily:

```bash
docker run --rm --entrypoint sh python-script-demo:0.1.0
```

This is useful when the image exists but the default runtime command is failing.

## Task 5 — Improve A Basic Dockerfile

Two useful improvements:

- avoid copying the entire repository into the image
- separate dependency installation from source-code copy

Example comparison:

Naive:

```dockerfile
FROM python:3.12
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "src/main.py"]
```

Improved:

```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/ /app/src/
CMD ["python", "/app/src/main.py"]
```

Trade-off note:

- the naive version is convenient early on
- the improved version is more reproducible, smaller, and faster to rebuild

Improved summary:

- clear working directory
- explicit dependency layer
- focused runtime command

## Common Mistakes

- forgetting build context location
- missing `.dockerignore`
- using a large base image without a reason
- copying secrets or local config into the image
- expecting mounted runtime files to exist when they were never passed to `docker run`
- tagging images vaguely and later not knowing which build is which

## Optional Hard Mode - One Project, Two Dockerfiles

Example idea:

- `Dockerfile.batch` runs a one-shot ETL or batch job
- `Dockerfile.api` runs a long-running API process

What should differ:

- runtime command
- exposed ports
- mounted inputs versus persistent runtime service behavior

## Definition Of Done

This topic is complete if you can:

- write a Dockerfile for a small realistic Python project
- build an image with a versioned tag
- inspect image history at least once
- run the image with runtime env vars
- explain at least two meaningful Dockerfile improvements