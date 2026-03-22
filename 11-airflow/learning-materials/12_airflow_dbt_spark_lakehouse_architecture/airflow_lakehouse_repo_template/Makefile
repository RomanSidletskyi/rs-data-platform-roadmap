init:
	docker compose up airflow-init

up:
	docker compose up -d postgres airflow-webserver airflow-scheduler

down:
	docker compose down

logs:
	docker compose logs -f

reset:
	docker compose down -v
