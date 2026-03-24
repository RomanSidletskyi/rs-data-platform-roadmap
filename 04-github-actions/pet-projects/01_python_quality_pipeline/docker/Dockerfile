FROM python:3.11-slim

WORKDIR /app

COPY src ./src

CMD ["python", "-c", "from src.calculator import mean; print(mean([1, 2, 3]))"]