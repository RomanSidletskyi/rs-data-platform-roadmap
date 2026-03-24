from __future__ import annotations

import json
import sys


def build_plan(batch_id: str) -> dict[str, object]:
    return {
        "batch_id": batch_id,
        "source_table": "bronze.customer_cdc_events",
        "current_state_table": "silver.customer_current_state",
        "history_table": "silver.customer_change_history",
        "merge_key": ["customer_id"],
        "winner_logic": [
            "keep newest event_ts per customer_id",
            "ignore exact duplicates during staging",
            "treat delete as removal from current state",
        ],
        "validation_steps": [
            "check required CDC fields",
            "deduplicate exact duplicates",
            "preview current-state output",
        ],
    }


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/plan_customer_merge.py <batch-id>")
    json.dump(build_plan(sys.argv[1]), sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
