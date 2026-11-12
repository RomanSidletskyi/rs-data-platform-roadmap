"""Offline checks for prepare_months: python -m pytest prepare/test_prepare_months.py"""

import csv
from datetime import datetime

from prepare_months import normalise, sheet_tag, synthetic_rows, write_months


def test_normalise_cleans_excel_types():
    row = normalise((489434, "85048", " GLASS BALL ", 12, datetime(2009, 12, 1, 7, 45), 6.95, 13085.0, "United Kingdom"))
    assert row["customer_id"] == "13085"
    assert row["invoice_date"] == "2009-12-01 07:45:00"
    assert row["description"] == "GLASS BALL"


def test_normalise_keeps_missing_customer_empty():
    row = normalise(("C489449", "22087", "PAPER", -12, datetime(2009, 12, 1, 10, 33), 0.85, None, "Australia"))
    assert row["customer_id"] == ""
    assert row["invoice"] == "C489449"


def test_sheet_tag():
    assert sheet_tag("Year 2009-2010") == "y2009_2010"


def test_write_months_splits_by_invoice_month(tmp_path):
    rows = [
        normalise((1, "A", "x", 1, datetime(2010, 11, 30, 23, 0), 1.0, 1, "UK")),
        normalise((2, "A", "x", 1, datetime(2010, 12, 1, 0, 1), 1.0, 1, "UK")),
    ]
    counts = write_months(rows, tmp_path, "t")
    assert counts == {"2010-11": 1, "2010-12": 1}
    with (tmp_path / "month=2010-12" / "online_retail_t.csv").open() as handle:
        assert next(csv.DictReader(handle))["invoice"] == "2"


def test_synthetic_rows_contain_the_same_kinds_of_dirt():
    rows = list(synthetic_rows())
    assert any(r["invoice"].startswith("C") for r in rows)
    assert any(r["stock_code"] == "POST" for r in rows)
    assert any(r["customer_id"] == "" for r in rows)
    assert any(r["price"] == "0" and int(r["quantity"]) < 0 for r in rows)
    assert len(rows) != len({tuple(sorted(r.items())) for r in rows})  # duplicates exist
