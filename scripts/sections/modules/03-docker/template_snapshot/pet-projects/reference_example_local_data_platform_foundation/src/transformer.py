import csv
from collections import defaultdict


REQUIRED_FIELDS = {"event_id", "event_type", "event_date", "source_system"}


def read_events_csv(input_path: str) -> list[dict]:
    with open(input_path, "r", encoding="utf-8", newline="") as csv_file:
        reader = csv.DictReader(csv_file)
        fieldnames = set(reader.fieldnames or [])
        missing = sorted(REQUIRED_FIELDS - fieldnames)
        if missing:
            raise ValueError(f"Missing required fields: {', '.join(missing)}")
        rows = list(reader)
        if not rows:
            raise ValueError("Input file is empty")
        return rows


def build_event_summary(rows: list[dict]) -> list[dict]:
    counts = defaultdict(int)
    for row in rows:
        counts[row["event_type"]] += 1

    return [
        {"event_type": event_type, "event_count": counts[event_type]}
        for event_type in sorted(counts)
    ]
