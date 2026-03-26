from __future__ import annotations

import json
import sys


def build_current_state(path: str) -> list[dict[str, object]]:
    latest_by_customer: dict[str, dict[str, str]] = {}
    with open(path, "r", encoding="utf-8") as handle:
        for raw_line in handle:
            row = json.loads(raw_line)
            customer_id = row["customer_id"]
            current = latest_by_customer.get(customer_id)
            if current is None or row["event_ts"] >= current["event_ts"]:
                latest_by_customer[customer_id] = row

    result: list[dict[str, object]] = []
    for customer_id, row in sorted(latest_by_customer.items()):
        if row["op"] == "delete":
            continue
        result.append(
            {
                "customer_id": customer_id,
                "event_ts": row["event_ts"],
                "email": row["email"],
                "loyalty_tier": row["loyalty_tier"],
            }
        )
    return result


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/preview_customer_current_state.py <jsonl-path>")
    json.dump(build_current_state(sys.argv[1]), sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
