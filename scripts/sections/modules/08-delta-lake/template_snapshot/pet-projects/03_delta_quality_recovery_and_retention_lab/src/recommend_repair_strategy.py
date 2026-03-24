from __future__ import annotations

import json
import sys
from collections import Counter


def recommend_strategy(path: str) -> dict[str, object]:
    business_dates = Counter()
    invalid_rows = 0
    with open(path, "r", encoding="utf-8") as handle:
        for raw_line in handle:
            row = json.loads(raw_line)
            if row["quality_status"] == "invalid":
                invalid_rows += 1
                business_dates[row["business_date"]] += 1

    if not business_dates:
        return {
            "recommended_strategy": "no_repair_needed",
            "affected_business_dates": [],
            "invalid_row_count": 0,
        }

    if len(business_dates) == 1:
        strategy = "bounded_replace_where"
    else:
        strategy = "evaluate_restore_or_multi_window_repair"

    return {
        "recommended_strategy": strategy,
        "affected_business_dates": sorted(business_dates),
        "invalid_row_count": invalid_rows,
    }


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/recommend_repair_strategy.py <jsonl-path>")
    json.dump(recommend_strategy(sys.argv[1]), sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
