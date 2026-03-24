FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt ./requirements.txt
RUN python -m pip install --upgrade pip && pip install -r requirements.txt

COPY config ./config
COPY data ./data
COPY src ./src
COPY run_pipeline.py ./run_pipeline.py

CMD ["python", "run_pipeline.py", "--run-mode", "full"]