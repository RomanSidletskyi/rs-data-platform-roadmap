import argparse
import json


def load_events(path: str):
    with open(path, "r", encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped:
                yield json.loads(stripped)


def build_projection(events):
    orders = {}
    for event in events:
        order_id = event.get("order_id")
        if not order_id:
            continue
        orders[order_id] = {
            "last_event_time": event.get("event_time"),
            "latest_status": event.get("status"),
            "order_id": order_id,
        }

    rows = [orders[key] for key in sorted(orders)]
    return {"row_count": len(rows), "rows": rows}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_path")
    args = parser.parse_args()
    print(json.dumps(build_projection(load_events(args.input_path)), indent=2, sort_keys=True))


if __name__ == "__main__":
    main()