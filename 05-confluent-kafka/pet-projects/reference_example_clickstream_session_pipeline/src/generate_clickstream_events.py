import argparse
import json
from itertools import cycle, islice


SAMPLE_EVENTS = [
    {
        "event_id": "evt-web-1001",
        "event_type": "page_viewed",
        "event_time": "2026-03-24T12:00:00Z",
        "session_id": "sess-100",
        "user_id": "user-21",
        "page_url": "/home",
    },
    {
        "event_id": "evt-web-1002",
        "event_type": "product_clicked",
        "event_time": "2026-03-24T12:00:05Z",
        "session_id": "sess-100",
        "user_id": "user-21",
        "page_url": "/products/sku-1",
    },
    {
        "event_id": "evt-web-1003",
        "event_type": "cart_added",
        "event_time": "2026-03-24T12:00:20Z",
        "session_id": "sess-100",
        "user_id": "user-21",
        "page_url": "/cart",
    },
    {
        "event_id": "evt-web-1004",
        "event_type": "page_viewed",
        "event_time": "2026-03-24T12:03:00Z",
        "session_id": "sess-200",
        "user_id": "user-55",
        "page_url": "/home",
    },
    {
        "event_id": "evt-web-1005",
        "event_type": "checkout_started",
        "event_time": "2026-03-24T12:03:30Z",
        "session_id": "sess-200",
        "user_id": "user-55",
        "page_url": "/checkout",
    },
    {
        "event_id": "evt-web-1006",
        "event_type": "checkout_completed",
        "event_time": "2026-03-24T12:04:10Z",
        "session_id": "sess-200",
        "user_id": "user-55",
        "page_url": "/checkout/success",
    },
]


def render_events(count: int) -> str:
    selected = list(islice(cycle(SAMPLE_EVENTS), count))
    return "\n".join(json.dumps(event, sort_keys=True) for event in selected)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--count", type=int, default=len(SAMPLE_EVENTS))
    parser.add_argument("--output")
    args = parser.parse_args()

    payload = render_events(args.count)
    if args.output:
        with open(args.output, "w", encoding="utf-8") as handle:
            handle.write(payload + "\n")
        return

    print(payload)


if __name__ == "__main__":
    main()