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
    buckets = defaultdict(list)
    for event in events:
        site_id = event.get("site_id")
        temperature_c = event.get("temperature_c")
        if site_id is None or not isinstance(temperature_c, (int, float)):
            continue
        buckets[site_id].append(float(temperature_c))

    sites = {}
    total_events = 0
    for site_id in sorted(buckets):
        temperatures = buckets[site_id]
        total_events += len(temperatures)
        sites[site_id] = {
            "avg_temperature_c": round(sum(temperatures) / len(temperatures), 2),
            "event_count": len(temperatures),
            "max_temperature_c": max(temperatures),
        }

    return {"sites": sites, "total_events": total_events}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_path")
    args = parser.parse_args()

    summary = build_summary(load_events(args.input_path))
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()