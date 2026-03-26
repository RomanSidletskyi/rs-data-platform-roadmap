import argparse
import json


REQUIRED_FIELDS = {
    "sales": {"event_id", "event_time", "event_type", "order_id", "customer_id", "schema_version"},
    "payments": {"event_id", "event_time", "event_type", "order_id", "payment_id", "schema_version"},
    "logistics": {"event_id", "event_time", "event_type", "order_id", "shipment_id", "schema_version"},
}

ALLOWED_EVENT_TYPES = {
    "sales": {"order_created", "order_confirmed", "order_cancelled"},
    "payments": {"payment_authorized", "payment_failed", "payment_captured"},
    "logistics": {"shipment_created", "shipment_dispatched", "shipment_delivered"},
}


def load_events(path: str):
    with open(path, "r", encoding="utf-8") as handle:
        for line_number, line in enumerate(handle, start=1):
            stripped = line.strip()
            if stripped:
                yield line_number, json.loads(stripped)


def inspect_events(events):
    findings = []

    for line_number, event in events:
        domain = event.get("domain")
        if domain not in REQUIRED_FIELDS:
            findings.append(f"line {line_number}: unknown domain")
            continue

        missing_fields = sorted(REQUIRED_FIELDS[domain] - set(event))
        if missing_fields:
            findings.append(f"line {line_number}: missing fields: {', '.join(missing_fields)}")

        event_type = event.get("event_type")
        if event_type not in ALLOWED_EVENT_TYPES[domain]:
            findings.append(f"line {line_number}: unexpected event_type '{event_type}' for domain '{domain}'")

        owner = event.get("producer_service")
        if domain == "sales" and owner != "order-service":
            findings.append(f"line {line_number}: producer_service should be 'order-service' for sales events")
        if domain == "payments" and owner != "payment-service":
            findings.append(f"line {line_number}: producer_service should be 'payment-service' for payments events")
        if domain == "logistics" and owner != "shipment-service":
            findings.append(f"line {line_number}: producer_service should be 'shipment-service' for logistics events")

    return findings


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_path")
    args = parser.parse_args()

    findings = inspect_events(load_events(args.input_path))
    if findings:
        print("contract-check=fail")
        for finding in findings:
            print(finding)
    else:
        print("contract-check=pass")


if __name__ == "__main__":
    main()