from __future__ import annotations

import json
import sys


def build_plan(release_id: str) -> dict[str, object]:
    return {
        "release_id": release_id,
        "source_table": "gold.daily_store_sales",
        "official_consumer_object": "analytics.daily_store_sales",
        "contract_grain": ["business_date", "store_id"],
        "freshness_sla_hours": 4,
        "review_steps": [
            "check required serving fields",
            "review schema-change proposal",
            "publish only through official consumer object",
        ],
    }


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/plan_serving_publish.py <release-id>")
    json.dump(build_plan(sys.argv[1]), sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
