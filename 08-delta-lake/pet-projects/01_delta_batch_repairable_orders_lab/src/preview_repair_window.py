from __future__ import annotations

import json
import sys
from collections import defaultdict
from decimal import Decimal, ROUND_HALF_UP


def as_money(value: str) -> Decimal:
    return Decimal(value).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)


def build_daily_summary(path: str, business_date: str) -> list[dict[str, object]]:
    grouped: dict[tuple[str, str], dict[str, object]] = defaultdict(
        lambda: {
            "order_count": 0,
            "gross_revenue": Decimal("0.00"),
            "refunded_order_count": 0,
        }
    )
    with open(path, "r", encoding="utf-8") as handle:
        for raw_line in handle:
            row = json.loads(raw_line)
            if row["business_date"] != business_date:
                continue
            key = (row["business_date"], row["country_code"].strip().upper())
            bucket = grouped[key]
            bucket["order_count"] += 1
            bucket["gross_revenue"] += as_money(str(row["gross_amount"]))
            if row["order_status"] == "refunded":
                bucket["refunded_order_count"] += 1

    result = []
    for (date_value, country_code), bucket in sorted(grouped.items()):
        result.append(
            {
                "business_date": date_value,
                "country_code": country_code,
                "order_count": bucket["order_count"],
                "gross_revenue": f"{bucket['gross_revenue']:.2f}",
                "refunded_order_count": bucket["refunded_order_count"],
            }
        )
    return result


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("Usage: python3 src/preview_repair_window.py <jsonl-path> <business-date>")
    json.dump(build_daily_summary(sys.argv[1], sys.argv[2]), sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
