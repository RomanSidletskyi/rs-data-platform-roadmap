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
    by_session = defaultdict(lambda: {"event_count": 0, "user_id": None, "pages": [], "completed_checkout": False})

    for event in events:
        session_id = event.get("session_id")
        if not session_id:
            continue

        bucket = by_session[session_id]
        bucket["event_count"] += 1
        bucket["user_id"] = event.get("user_id")

        page_url = event.get("page_url")
        if page_url and page_url not in bucket["pages"]:
            bucket["pages"].append(page_url)

        if event.get("event_type") == "checkout_completed":
            bucket["completed_checkout"] = True

    sessions = {}
    for session_id in sorted(by_session):
        bucket = by_session[session_id]
        sessions[session_id] = {
            "completed_checkout": bucket["completed_checkout"],
            "event_count": bucket["event_count"],
            "page_count": len(bucket["pages"]),
            "user_id": bucket["user_id"],
        }

    return {"session_count": len(sessions), "sessions": sessions}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_path")
    args = parser.parse_args()

    summary = build_summary(load_events(args.input_path))
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()