"""P04 failure drills: write files that exercise duplicates, malformed rows, schema drift, late events, and reused names."""

from __future__ import annotations

import argparse
import itertools
import json
import sys
import time
import uuid
from datetime import timedelta

from producer import (
    add_sink_args,
    build_sink,
    encode_events,
    encode_lines,
    iso,
    synthetic_events,
    utc_now,
    write_batch,
    write_payload,
)

DRILLS = ["plain", "duplicate-content", "malformed", "schema-drift", "late", "same-name"]


def sample(n: int, seed: int) -> list[dict]:
    return list(itertools.islice(synthetic_events(rate_per_sec=1e6, seed=seed), n))


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("drill", choices=DRILLS)
    parser.add_argument("--rows", type=int, default=100)
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--wait-seconds", type=int, default=180, help="same-name drill: wait before overwriting")
    add_sink_args(parser)
    args = parser.parse_args(argv)

    sink = build_sink(args)
    producer_id = f"chaos-{args.drill}-{uuid.uuid4().hex[:6]}"
    opened_at = utc_now()
    events = sample(args.rows, args.seed)

    if args.drill == "plain":
        # Use with event delivery disabled to simulate a missed notification.
        print(write_batch(sink, events, opened_at, producer_id, "chaos")["file_name"])

    elif args.drill == "duplicate-content":
        for _ in range(2):
            print(write_batch(sink, events, opened_at, producer_id, "chaos")["file_name"])

    elif args.drill == "malformed":
        lines = [json.dumps(e, separators=(",", ":")) for e in events]
        lines.insert(len(lines) // 2, '{"meta": {"id": "broken-line", "dt": ')
        manifest = write_payload(
            sink, encode_lines(lines), len(lines),
            events[0]["meta"]["dt"], events[-1]["meta"]["dt"],
            opened_at, producer_id, "chaos",
        )
        print(manifest["file_name"])

    elif args.drill == "schema-drift":
        for e in events:
            e["bot"] = "unknown"
            e["namespace"] = "main"
            e["drift_field"] = {"added_by": "chaos", "version": 2}
        print(write_batch(sink, events, opened_at, producer_id, "chaos")["file_name"])

    elif args.drill == "late":
        late_dt = iso(utc_now() - timedelta(hours=3))
        for e in events:
            e["meta"]["dt"] = late_dt
        print(write_batch(sink, events, opened_at, producer_id, "chaos")["file_name"])

    elif args.drill == "same-name":
        manifest = write_batch(sink, events, opened_at, producer_id, "chaos")
        key = manifest["file_name"]
        print(f"wrote {key}; waiting {args.wait_seconds}s for it to load, then overwriting with new content")
        time.sleep(args.wait_seconds)
        corrected = sample(args.rows, args.seed + 1)
        sink.put(key, encode_events(corrected), overwrite=True)
        print(f"overwrote {key} with {len(corrected)} different events and no new manifest")

    return 0


if __name__ == "__main__":
    sys.exit(main())
