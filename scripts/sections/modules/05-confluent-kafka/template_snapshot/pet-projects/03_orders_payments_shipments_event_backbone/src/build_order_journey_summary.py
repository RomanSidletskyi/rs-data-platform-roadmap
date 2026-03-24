import argparse
import json
from collections import defaultdict


def load_events(path: str):
    with open(path, "r", encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if stripped:
                yield json.loads(stripped)


def build_summary(events):
    orders = defaultdict(
        lambda: {
            "customer_id": None,
            "domains_seen": [],
            "event_count": 0,
            "latest_payment_status": None,
            "latest_shipment_status": None,
            "order_status": None,
        }
    )

    for event in events:
        order_id = event.get("order_id")
        if not order_id:
            continue

        bucket = orders[order_id]
        bucket["event_count"] += 1
        bucket["customer_id"] = event.get("customer_id", bucket["customer_id"])

        domain = event.get("domain")
        if domain and domain not in bucket["domains_seen"]:
            bucket["domains_seen"].append(domain)

        event_type = event.get("event_type")
        if domain == "sales":
            bucket["order_status"] = event_type
        elif domain == "payments":
            bucket["latest_payment_status"] = event_type
        elif domain == "logistics":
            bucket["latest_shipment_status"] = event_type

    summary = {}
    for order_id in sorted(orders):
        bucket = orders[order_id]
        summary[order_id] = {
            "customer_id": bucket["customer_id"],
            "domains_seen": sorted(bucket["domains_seen"]),
            "event_count": bucket["event_count"],
            "latest_payment_status": bucket["latest_payment_status"],
            "latest_shipment_status": bucket["latest_shipment_status"],
            "order_status": bucket["order_status"],
        }

    return {"order_count": len(summary), "orders": summary}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_path")
    args = parser.parse_args()

    summary = build_summary(load_events(args.input_path))
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()