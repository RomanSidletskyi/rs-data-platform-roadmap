from __future__ import annotations

import json
import sys


def build_plan(incident_id: str) -> dict[str, object]:
    return {
        "incident_id": incident_id,
        "shared_table": "silver.orders_shared",
        "preferred_strategy": "bounded_replace_where",
        "restore_threshold": "whole_table_corruption",
        "retention_rules": {
            "log_retention_days": 30,
            "deleted_file_retention_days": 14,
        },
        "response_steps": [
            "check quality violations",
            "identify affected business dates",
            "decide bounded repair versus restore",
            "verify retention still preserves recovery path",
        ],
    }


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/plan_quality_recovery.py <incident-id>")
    json.dump(build_plan(sys.argv[1]), sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
