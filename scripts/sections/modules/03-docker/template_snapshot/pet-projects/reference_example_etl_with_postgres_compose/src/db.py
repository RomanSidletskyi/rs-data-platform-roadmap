import os


def get_connection():
    try:
        import psycopg
    except ImportError as exc:
        raise RuntimeError("psycopg is required. Install dependencies from requirements.txt.") from exc

    return psycopg.connect(
        dbname=os.getenv("POSTGRES_DB", "etl_lab"),
        user=os.getenv("POSTGRES_USER", "etl_user"),
        password=os.getenv("POSTGRES_PASSWORD", "etl_pass"),
        host=os.getenv("POSTGRES_HOST", "localhost"),
        port=os.getenv("POSTGRES_PORT", "5432"),
    )


def ensure_tables(connection, source_table: str, summary_table: str) -> None:
    with connection.cursor() as cursor:
        cursor.execute(
            f"""
            CREATE TABLE IF NOT EXISTS {source_table} (
                order_id TEXT PRIMARY KEY,
                order_date DATE NOT NULL,
                region TEXT NOT NULL,
                customer_id TEXT NOT NULL,
                amount NUMERIC(12, 2) NOT NULL
            )
            """
        )
        cursor.execute(
            f"""
            CREATE TABLE IF NOT EXISTS {summary_table} (
                order_date DATE PRIMARY KEY,
                order_count INTEGER NOT NULL,
                total_amount NUMERIC(12, 2) NOT NULL
            )
            """
        )
    connection.commit()


def load_raw_rows(connection, source_table: str, rows: list[dict]) -> None:
    with connection.cursor() as cursor:
        cursor.execute(f"TRUNCATE TABLE {source_table}")
        for row in rows:
            cursor.execute(
                f"""
                INSERT INTO {source_table} (order_id, order_date, region, customer_id, amount)
                VALUES (%s, %s, %s, %s, %s)
                """,
                (row["order_id"], row["order_date"], row["region"], row["customer_id"], row["amount"]),
            )
    connection.commit()


def load_daily_summary(connection, summary_table: str, summary_rows: list[dict]) -> None:
    with connection.cursor() as cursor:
        cursor.execute(f"TRUNCATE TABLE {summary_table}")
        for row in summary_rows:
            cursor.execute(
                f"""
                INSERT INTO {summary_table} (order_date, order_count, total_amount)
                VALUES (%s, %s, %s)
                """,
                (row["order_date"], row["order_count"], row["total_amount"]),
            )
    connection.commit()
