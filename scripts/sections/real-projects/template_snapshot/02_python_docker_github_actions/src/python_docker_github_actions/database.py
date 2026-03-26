from __future__ import annotations

import sqlite3
from pathlib import Path


RAW_SCHEMA_SQL = """
CREATE TABLE IF NOT EXISTS raw_orders (
    run_id TEXT NOT NULL,
    order_id INTEGER NOT NULL,
    customer_id TEXT NOT NULL,
    order_date TEXT NOT NULL,
    product_category TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price REAL NOT NULL,
    PRIMARY KEY (run_id, order_id)
);
"""


CURATED_SCHEMA_SQL = """
CREATE TABLE IF NOT EXISTS curated_daily_sales (
    sales_date TEXT NOT NULL,
    product_category TEXT NOT NULL,
    orders_count INTEGER NOT NULL,
    total_quantity INTEGER NOT NULL,
    gross_revenue REAL NOT NULL,
    PRIMARY KEY (sales_date, product_category)
);
"""


TRANSFORM_SQL = """
INSERT OR REPLACE INTO curated_daily_sales (
    sales_date,
    product_category,
    orders_count,
    total_quantity,
    gross_revenue
)
SELECT
    order_date AS sales_date,
    product_category,
    COUNT(*) AS orders_count,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(quantity * unit_price), 2) AS gross_revenue
FROM raw_orders
WHERE run_id = ?
GROUP BY order_date, product_category
ORDER BY order_date, product_category;
"""


def connect(database_path: str) -> sqlite3.Connection:
    Path(database_path).parent.mkdir(parents=True, exist_ok=True)
    connection = sqlite3.connect(database_path)
    connection.row_factory = sqlite3.Row
    return connection


def initialize_schema(connection: sqlite3.Connection) -> None:
    connection.executescript(RAW_SCHEMA_SQL)
    connection.executescript(CURATED_SCHEMA_SQL)
    connection.commit()


def load_raw_records(
    connection: sqlite3.Connection,
    run_id: str,
    records: list[dict[str, str]],
) -> None:
    rows = [
        (
            run_id,
            int(record["order_id"]),
            record["customer_id"],
            record["order_date"],
            record["product_category"],
            int(record["quantity"]),
            float(record["unit_price"]),
        )
        for record in records
    ]

    connection.executemany(
        """
        INSERT OR REPLACE INTO raw_orders (
            run_id,
            order_id,
            customer_id,
            order_date,
            product_category,
            quantity,
            unit_price
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
        """,
        rows,
    )
    connection.commit()


def build_curated_outputs(connection: sqlite3.Connection, run_id: str) -> None:
    connection.execute("DELETE FROM curated_daily_sales")
    connection.execute(TRANSFORM_SQL, (run_id,))
    connection.commit()


def fetch_latest_run_id(connection: sqlite3.Connection) -> str | None:
    row = connection.execute(
        "SELECT run_id FROM raw_orders ORDER BY run_id DESC LIMIT 1"
    ).fetchone()
    if row is None:
        return None
    return str(row[0])


def fetch_curated_rows(connection: sqlite3.Connection) -> list[dict[str, str | int | float]]:
    rows = connection.execute(
        """
        SELECT sales_date, product_category, orders_count, total_quantity, gross_revenue
        FROM curated_daily_sales
        ORDER BY sales_date, product_category
        """
    ).fetchall()
    return [dict(row) for row in rows]