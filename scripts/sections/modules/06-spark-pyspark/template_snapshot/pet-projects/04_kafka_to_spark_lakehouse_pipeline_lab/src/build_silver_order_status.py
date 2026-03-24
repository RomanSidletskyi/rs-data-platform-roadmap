from __future__ import annotations

import json
import sys


def build_status_view(path: str) -> list[dict[str, object]]:
    latest: dict[str, dict[str, object]] = {}
    with open(path, "r", encoding="utf-8") as handle:
        for raw_line in handle:
            event = json.loads(raw_line)
            payload = event["payload"]
            order_id = payload["order_id"]
            current = latest.get(order_id)
            candidate = {
                "order_id": order_id,
                "latest_event_time": payload["event_time"],
                "latest_status": payload["order_status"],
                "latest_amount": payload["amount"],
            }
            if current is None or candidate["latest_event_time"] >= current["latest_event_time"]:
                latest[order_id] = candidate
    return [latest[key] for key in sorted(latest)]


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/build_silver_order_status.py <jsonl-path>")
    json.dump(build_status_view(sys.argv[1]), sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()