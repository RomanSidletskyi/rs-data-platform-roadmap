FROM python:3.11-slim

WORKDIR /app

COPY src ./src

CMD ["python", "-c", "from src.metrics import average; print(average([2, 4, 6]))"]