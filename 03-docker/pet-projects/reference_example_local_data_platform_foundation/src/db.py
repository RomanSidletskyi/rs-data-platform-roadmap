import os


def get_connection():
    try:
        import psycopg
    except ImportError as exc:
        raise RuntimeError("psycopg is required. Install dependencies from requirements.txt.") from exc

    return psycopg.connect(
        dbname=os.getenv("POSTGRES_DB", "platform_lab"),
        user=os.getenv("POSTGRES_USER", "platform_user"),
        password=os.getenv("POSTGRES_PASSWORD", "platform_pass"),
        host=os.getenv("POSTGRES_HOST", "localhost"),
        port=os.getenv("POSTGRES_PORT", "5432"),
    )


def ensure_tables(connection, raw_table: str, summary_table: str) -> None:
    with connection.cursor() as cursor:
        cursor.execute(
            f"""
            CREATE TABLE IF NOT EXISTS {raw_table} (
                event_id TEXT PRIMARY KEY,
                event_type TEXT NOT NULL,
                event_date DATE NOT NULL,
                source_system TEXT NOT NULL
            )
            """
        )
        cursor.execute(
            f"""
            CREATE TABLE IF NOT EXISTS {summary_table} (
                event_type TEXT PRIMARY KEY,
                event_count INTEGER NOT NULL
            )
            """
        )
    connection.commit()


def load_raw_events(connection, raw_table: str, rows: list[dict]) -> None:
    with connection.cursor() as cursor:
        cursor.execute(f"TRUNCATE TABLE {raw_table}")
        for row in rows:
            cursor.execute(
                f"""
                INSERT INTO {raw_table} (event_id, event_type, event_date, source_system)
                VALUES (%s, %s, %s, %s)
                """,
                (row["event_id"], row["event_type"], row["event_date"], row["source_system"]),
            )
    connection.commit()


def load_summary(connection, summary_table: str, summary_rows: list[dict]) -> None:
    with connection.cursor() as cursor:
        cursor.execute(f"TRUNCATE TABLE {summary_table}")
        for row in summary_rows:
            cursor.execute(
                f"""
                INSERT INTO {summary_table} (event_type, event_count)
                VALUES (%s, %s)
                """,
                (row["event_type"], row["event_count"]),
            )
    connection.commit()
