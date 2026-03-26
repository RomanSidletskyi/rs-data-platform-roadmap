from __future__ import annotations

import json
import sys


def build_plan(business_date: str) -> dict[str, object]:
    return {
        "bronze_table": "bronze.orders_raw",
        "silver_table": "silver.orders_clean",
        "gold_table": "gold.daily_sales",
        "business_date": business_date,
        "repair_strategy": "replace_where",
        "replace_where_predicate": f"business_date = '{business_date}'",
        "validation_steps": [
            "check raw contract",
            "rebuild affected silver slice",
            "rebuild affected gold slice",
            "compare aggregate totals before publish",
        ],
    }


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/plan_batch_repair.py <business-date>")
    json.dump(build_plan(sys.argv[1]), sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
