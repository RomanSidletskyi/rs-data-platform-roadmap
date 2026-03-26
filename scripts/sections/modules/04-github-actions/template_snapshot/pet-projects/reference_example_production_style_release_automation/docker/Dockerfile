FROM python:3.11-slim

WORKDIR /app

COPY src ./src

CMD ["python", "-c", "from src.release_manifest import build_manifest; print(build_manifest('v2.0.0', 'local', 'prod'))"]