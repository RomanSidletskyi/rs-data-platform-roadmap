import argparse
import json
from collections import defaultdict


def load_events(path: str):
    with open(path, "r", encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped:
                yield json.loads(stripped)


def build_gold(events):
    buckets = defaultdict(float)
    for event in events:
        if event.get("quality_status") != "valid":
            continue
        if "order_id" not in event:
            continue
        amount = event.get("net_amount")
        if not isinstance(amount, (int, float)):
            continue
        key = (event.get("event_date"), event.get("country_code"))
        buckets[key] += float(amount)

    rows = []
    for (event_date, country_code), revenue in sorted(buckets.items()):
        rows.append(
            {
                "country_code": country_code,
                "event_date": event_date,
                "net_revenue": round(revenue, 2),
            }
        )

    return {"row_count": len(rows), "rows": rows}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_path")
    args = parser.parse_args()
    print(json.dumps(build_gold(load_events(args.input_path)), indent=2, sort_keys=True))


if __name__ == "__main__":
    main()