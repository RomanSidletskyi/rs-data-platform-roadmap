FROM python:3.11-slim

WORKDIR /app

COPY src ./src

CMD ["python", "-c", "from src.workflow_checks import validation_report; print(validation_report('.'))"]