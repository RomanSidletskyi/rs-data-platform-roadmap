import tempfile
import unittest
from pathlib import Path

from src.config_loader import load_config
from src.transformer import build_daily_summary, read_orders_csv


class EtlTransformerTests(unittest.TestCase):
    def test_build_daily_summary_returns_expected_rows(self) -> None:
        rows = [
            {"order_id": "1", "order_date": "2026-03-01", "region": "west", "customer_id": "c1", "amount": "10.50"},
            {"order_id": "2", "order_date": "2026-03-01", "region": "east", "customer_id": "c2", "amount": "4.50"},
            {"order_id": "3", "order_date": "2026-03-02", "region": "west", "customer_id": "c3", "amount": "20.00"},
        ]

        summary = build_daily_summary(rows)

        self.assertEqual(len(summary), 2)
        self.assertEqual(summary[0]["order_date"], "2026-03-01")
        self.assertEqual(summary[0]["order_count"], 2)
        self.assertEqual(summary[0]["total_amount"], "15.00")

    def test_read_orders_csv_rejects_missing_fields(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            csv_path = Path(temp_dir) / "orders.csv"
            csv_path.write_text("order_id,order_date,region,amount\n1,2026-03-01,west,10.00\n", encoding="utf-8")

            with self.assertRaises(ValueError):
                read_orders_csv(str(csv_path), ["order_id", "order_date", "region", "customer_id", "amount"])

    def test_load_config_reads_expected_table_names(self) -> None:
        project_root = Path(__file__).resolve().parents[1]
        config = load_config(str(project_root / "config" / "etl_config.json"))

        self.assertEqual(config["source_table"], "raw_orders")
        self.assertEqual(config["summary_table"], "daily_order_summary")


if __name__ == "__main__":
    unittest.main()