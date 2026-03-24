from __future__ import annotations

import sqlite3
import subprocess
import unittest
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[1]
PYTHON_EXECUTABLE = Path(
    "/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python"
)


class PipelineSmokeTest(unittest.TestCase):
    def test_pipeline_builds_curated_output(self) -> None:
        warehouse_path = PROJECT_ROOT / "data/warehouse/warehouse.db"
        if warehouse_path.exists():
            warehouse_path.unlink()

        result = subprocess.run(
            [str(PYTHON_EXECUTABLE), "run_pipeline.py", "--run-mode", "full"],
            cwd=PROJECT_ROOT,
            check=True,
            capture_output=True,
            text=True,
        )

        self.assertIn("Pipeline finished successfully", result.stdout)
        self.assertTrue(warehouse_path.exists())

        with sqlite3.connect(warehouse_path) as connection:
            row_count = connection.execute(
                "SELECT COUNT(*) FROM curated_daily_sales"
            ).fetchone()[0]
            books_row = connection.execute(
                """
                SELECT gross_revenue
                FROM curated_daily_sales
                WHERE sales_date = '2026-03-20' AND product_category = 'books'
                """
            ).fetchone()

        self.assertEqual(row_count, 7)
        self.assertIsNotNone(books_row)
        self.assertEqual(books_row[0], 77.0)

    def test_pipeline_fails_on_invalid_source_data(self) -> None:
        invalid_source = PROJECT_ROOT / "data/source/orders_invalid.csv"

        result = subprocess.run(
            [
                str(PYTHON_EXECUTABLE),
                "run_pipeline.py",
                "--source-path",
                str(invalid_source),
                "--run-mode",
                "full",
            ],
            cwd=PROJECT_ROOT,
            check=False,
            capture_output=True,
            text=True,
        )

        self.assertNotEqual(result.returncode, 0)
        combined_output = f"{result.stdout}\n{result.stderr}"
        self.assertIn("Data quality check failed", combined_output)