from __future__ import annotations

import json
import sys


def normalize(path: str) -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    with open(path, "r", encoding="utf-8") as handle:
        for raw_line in handle:
            event = json.loads(raw_line)
            payload = event["payload"]
            rows.append(
                {
                    "topic": event["topic"],
                    "partition": event["partition"],
                    "offset": event["offset"],
                    "event_type": payload["event_type"],
                    "order_id": payload["order_id"],
                    "event_time": payload["event_time"],
                    "order_status": payload["order_status"],
                    "amount": payload["amount"],
                }
            )
    return rows


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/normalize_kafka_orders_to_bronze.py <jsonl-path>")
    json.dump(normalize(sys.argv[1]), sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()