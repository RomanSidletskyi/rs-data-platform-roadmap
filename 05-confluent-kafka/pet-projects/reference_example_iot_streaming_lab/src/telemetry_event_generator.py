import argparse
import json
from itertools import cycle, islice


SAMPLE_EVENTS = [
    {
        "event_id": "evt-temp-1001",
        "event_type": "temperature_reported",
        "event_time": "2026-03-24T10:00:00Z",
        "device_id": "sensor-warehouse-1-a",
        "site_id": "warehouse-1",
        "temperature_c": 23.4,
        "humidity_pct": 41.2,
    },
    {
        "event_id": "evt-temp-1002",
        "event_type": "temperature_reported",
        "event_time": "2026-03-24T10:01:00Z",
        "device_id": "sensor-warehouse-1-b",
        "site_id": "warehouse-1",
        "temperature_c": 24.4,
        "humidity_pct": 40.1,
    },
    {
        "event_id": "evt-temp-1003",
        "event_type": "temperature_reported",
        "event_time": "2026-03-24T10:02:00Z",
        "device_id": "sensor-warehouse-2-a",
        "site_id": "warehouse-2",
        "temperature_c": 21.9,
        "humidity_pct": 48.0,
    },
    {
        "event_id": "evt-temp-1004",
        "event_type": "temperature_reported",
        "event_time": "2026-03-24T10:03:00Z",
        "device_id": "sensor-warehouse-2-b",
        "site_id": "warehouse-2",
        "temperature_c": 22.5,
        "humidity_pct": 46.8,
    },
    {
        "event_id": "evt-temp-1005",
        "event_type": "temperature_reported",
        "event_time": "2026-03-24T10:04:00Z",
        "device_id": "sensor-warehouse-1-a",
        "site_id": "warehouse-1",
        "temperature_c": 23.4,
        "humidity_pct": 42.3,
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