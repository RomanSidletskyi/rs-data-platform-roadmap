import csv
from collections import defaultdict
from decimal import Decimal, ROUND_HALF_UP


def quantize(value: Decimal) -> str:
    return str(value.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP))


def read_orders_csv(input_path: str, required_fields: list[str]) -> list[dict]:
    with open(input_path, "r", encoding="utf-8", newline="") as csv_file:
        reader = csv.DictReader(csv_file)
        fieldnames = set(reader.fieldnames or [])
        missing = sorted(set(required_fields) - fieldnames)
        if missing:
            raise ValueError(f"Missing required fields: {', '.join(missing)}")

        rows = list(reader)
        if not rows:
            raise ValueError("Input file is empty")
        return rows


def build_daily_summary(rows: list[dict]) -> list[dict]:
    daily_totals: dict[str, dict] = defaultdict(lambda: {"order_count": 0, "total_amount": Decimal("0")})

    for row in rows:
        order_date = row["order_date"]
        amount = Decimal(row["amount"])
        daily_totals[order_date]["order_count"] += 1
        daily_totals[order_date]["total_amount"] += amount

    summary_rows = []
    for order_date in sorted(daily_totals):
        summary_rows.append(
            {
                "order_date": order_date,
                "order_count": daily_totals[order_date]["order_count"],
                "total_amount": quantize(daily_totals[order_date]["total_amount"]),
            }
        )
    return summary_rows
