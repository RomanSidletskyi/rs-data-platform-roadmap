init:
	docker compose up airflow-init

up:
	docker compose up -d postgres redis airflow-webserver airflow-scheduler airflow-worker

down:
	docker compose down

logs:
	docker compose logs -f

reset:
	docker compose down -v

ps:
	docker compose ps
