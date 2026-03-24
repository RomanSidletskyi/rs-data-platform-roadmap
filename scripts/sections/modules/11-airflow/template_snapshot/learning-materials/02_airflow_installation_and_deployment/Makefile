.PHONY: init up down restart logs ps clean

init:
	docker compose up airflow-init

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose down && docker compose up -d

logs:
	docker compose logs -f

ps:
	docker compose ps

clean:
	docker compose down -v
