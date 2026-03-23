import json
import os
from datetime import datetime, timezone


def get_connection():
    try:
        import psycopg
    except ImportError as exc:
        raise RuntimeError("psycopg is required. Install dependencies from requirements.txt.") from exc

    return psycopg.connect(
        dbname=os.getenv("POSTGRES_DB", "jobs_lab"),
        user=os.getenv("POSTGRES_USER", "jobs_user"),
        password=os.getenv("POSTGRES_PASSWORD", "jobs_pass"),
        host=os.getenv("POSTGRES_HOST", "localhost"),
        port=os.getenv("POSTGRES_PORT", "5432"),
    )


def ensure_tables(connection, job_table: str, result_table: str) -> None:
    with connection.cursor() as cursor:
        cursor.execute(
            f"""
            CREATE TABLE IF NOT EXISTS {job_table} (
                job_id TEXT PRIMARY KEY,
                job_type TEXT NOT NULL,
                payload JSONB NOT NULL,
                status TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL,
                updated_at TIMESTAMPTZ NOT NULL
            )
            """
        )
        cursor.execute(
            f"""
            CREATE TABLE IF NOT EXISTS {result_table} (
                job_id TEXT PRIMARY KEY,
                result_payload JSONB NOT NULL,
                created_at TIMESTAMPTZ NOT NULL
            )
            """
        )
    connection.commit()


def insert_job(connection, job_table: str, job: dict) -> None:
    now = datetime.now(timezone.utc)
    with connection.cursor() as cursor:
        cursor.execute(
            f"""
            INSERT INTO {job_table} (job_id, job_type, payload, status, created_at, updated_at)
            VALUES (%s, %s, %s, %s, %s, %s)
            ON CONFLICT (job_id) DO UPDATE
            SET job_type = EXCLUDED.job_type,
                payload = EXCLUDED.payload,
                status = EXCLUDED.status,
                updated_at = EXCLUDED.updated_at
            """,
            (job["job_id"], job["job_type"], json.dumps(job["payload"]), "pending", now, now),
        )
    connection.commit()


def fetch_pending_jobs(connection, job_table: str) -> list[dict]:
    with connection.cursor() as cursor:
        cursor.execute(
            f"SELECT job_id, job_type, payload FROM {job_table} WHERE status = 'pending' ORDER BY created_at"
        )
        return [
            {"job_id": row[0], "job_type": row[1], "payload": row[2]}
            for row in cursor.fetchall()
        ]


def mark_job_status(connection, job_table: str, job_id: str, status: str) -> None:
    now = datetime.now(timezone.utc)
    with connection.cursor() as cursor:
        cursor.execute(
            f"UPDATE {job_table} SET status = %s, updated_at = %s WHERE job_id = %s",
            (status, now, job_id),
        )
    connection.commit()


def save_job_result(connection, result_table: str, job_id: str, result_payload: dict) -> None:
    now = datetime.now(timezone.utc)
    with connection.cursor() as cursor:
        cursor.execute(
            f"""
            INSERT INTO {result_table} (job_id, result_payload, created_at)
            VALUES (%s, %s, %s)
            ON CONFLICT (job_id) DO UPDATE
            SET result_payload = EXCLUDED.result_payload,
                created_at = EXCLUDED.created_at
            """,
            (job_id, json.dumps(result_payload), now),
        )
    connection.commit()
