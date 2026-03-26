import json
import tempfile
import unittest
from pathlib import Path

from src.batch_job import read_rows, run_batch_job, summarize_rows


class BatchJobTests(unittest.TestCase):
    def test_summarize_rows_returns_expected_totals(self) -> None:
        rows = [
            {"order_id": "1", "region": "west", "category": "hardware", "amount": "10.50"},
            {"order_id": "2", "region": "west", "category": "software", "amount": "5.00"},
            {"order_id": "3", "region": "east", "category": "hardware", "amount": "4.50"},
        ]

        summary = summarize_rows(rows)

        self.assertEqual(summary["total_rows"], 3)
        self.assertEqual(summary["total_amount"], "20.00")
        self.assertEqual(summary["region_totals"]["west"], "15.50")
        self.assertEqual(summary["category_totals"]["hardware"], "15.00")

    def test_read_rows_rejects_missing_fields(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            bad_csv_path = Path(temp_dir) / "bad.csv"
            bad_csv_path.write_text("order_id,region,amount\n1,west,10.00\n", encoding="utf-8")

            with self.assertRaises(ValueError):
                read_rows(str(bad_csv_path))

    def test_run_batch_job_writes_expected_artifacts(self) -> None:
        project_root = Path(__file__).resolve().parents[1]
        input_path = project_root / "data" / "input" / "sales.csv"
        config_path = project_root / "config" / "job_config.json"

        with tempfile.TemporaryDirectory() as temp_dir:
            summary = run_batch_job(
                input_path=str(input_path),
                output_dir=temp_dir,
                config_path=str(config_path),
            )

            summary_path = Path(temp_dir) / "summary.json"
            region_totals_path = Path(temp_dir) / "region_totals.csv"
            category_totals_path = Path(temp_dir) / "category_totals.csv"

            self.assertEqual(summary["total_rows"], 6)
            self.assertTrue(summary_path.exists())
            self.assertTrue(region_totals_path.exists())
            self.assertTrue(category_totals_path.exists())

            saved_summary = json.loads(summary_path.read_text(encoding="utf-8"))
            self.assertEqual(saved_summary["total_amount"], "1011.50")
            self.assertEqual(saved_summary["region_totals"]["west"], "311.50")


if __name__ == "__main__":
    unittest.main()