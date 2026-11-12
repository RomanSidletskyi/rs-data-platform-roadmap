"""GH Archive helpers for the P10 DAGs. No Airflow imports, so everything here is tested without a scheduler."""

from __future__ import annotations

import argparse
import collections
import gzip
import json
import sys
import urllib.request
from collections.abc import Iterable
from datetime import date, datetime, timedelta, timezone
from pathlib import Path

BASE_URL = "https://data.gharchive.org"
# Cloudflare in front of GH Archive answers 403 to the default Python User-Agent.
USER_AGENT = "rs-data-platform-roadmap-p10/1.0 (learning project)"
LANDING_PREFIX = "gharchive"


def normalize_hour(ts: datetime) -> datetime:
    """Return the UTC hour that contains ts. Naive values are treated as UTC."""
    if ts.tzinfo is None:
        ts = ts.replace(tzinfo=timezone.utc)
    return ts.astimezone(timezone.utc).replace(minute=0, second=0, microsecond=0)


def hour_file_name(hour: datetime) -> str:
    """GH Archive writes the hour without a leading zero: 2026-11-09-5.json.gz."""
    hour = normalize_hour(hour)
    return f"{hour:%Y-%m-%d}-{hour.hour}.json.gz"


def source_url(hour: datetime) -> str:
    return f"{BASE_URL}/{hour_file_name(hour)}"


def landing_key(hour: datetime, root: str = "") -> str:
    """Object key relative to the landing container or bucket prefix; one folder per UTC day."""
    hour = normalize_hour(hour)
    return f"{root}{LANDING_PREFIX}/dt={hour:%Y-%m-%d}/{hour_file_name(hour)}"


def snowflake_ts(hour: datetime) -> str:
    """TIMESTAMP_NTZ literal in UTC, the type the Snowflake procedures take."""
    return f"{normalize_hour(hour):%Y-%m-%d %H:%M:%S}"


def hours_of_day(day: date) -> list[datetime]:
    start = datetime(day.year, day.month, day.day, tzinfo=timezone.utc)
    return [start + timedelta(hours=h) for h in range(24)]


def is_published(status_code: int) -> bool:
    """200: the hour file exists. 404: not published yet (about 5 minutes after the hour ends). Anything else is an error."""
    if status_code == 200:
        return True
    if status_code == 404:
        return False
    raise RuntimeError(f"GH Archive answered HTTP {status_code}")


def should_land(exists: bool, force: bool) -> bool:
    """Uploads to Blob, S3, and stages are atomic, so an existing object is complete; skip it unless forced."""
    return force or not exists


def check_size(expected: int | None, actual: int) -> None:
    if expected is not None and expected != actual:
        raise RuntimeError(f"size mismatch: source {expected} bytes, landed {actual} bytes")


def profile_lines(lines: Iterable[str], hour: datetime | None = None) -> dict:
    """Profile one hour file: volume, event type mix, and the payload fields the pipeline depends on."""
    types: collections.Counter[str] = collections.Counter()
    pr_actions: collections.Counter[str] = collections.Counter()
    seen: set[str] = set()
    events = duplicates = bad_lines = bots = outside_hour = 0
    push_with_size = pr_with_merged_flag = 0
    start = normalize_hour(hour) if hour else None
    for line in lines:
        if not line.strip():
            continue
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            bad_lines += 1
            continue
        events += 1
        types[event.get("type", "?")] += 1
        if event.get("id") in seen:
            duplicates += 1
        seen.add(event.get("id"))
        if str(event.get("actor", {}).get("login", "")).endswith("[bot]"):
            bots += 1
        payload = event.get("payload") or {}
        if event.get("type") == "PushEvent" and "size" in payload:
            push_with_size += 1
        if event.get("type") == "PullRequestEvent":
            pr_actions[payload.get("action", "?")] += 1
            if "merged" in (payload.get("pull_request") or {}):
                pr_with_merged_flag += 1
        if start is not None:
            created = datetime.fromisoformat(event["created_at"].replace("Z", "+00:00"))
            if not start <= created < start + timedelta(hours=1):
                outside_hour += 1
    return {
        "events": events,
        "duplicate_ids": duplicates,
        "bad_lines": bad_lines,
        "bot_events": bots,
        "created_outside_hour": outside_hour if start is not None else None,
        "types": dict(types.most_common()),
        "push_events_with_size": push_with_size,
        "pr_events_with_merged_flag": pr_with_merged_flag,
        "pr_actions": dict(pr_actions.most_common()),
    }


def main(argv: list[str] | None = None) -> int:
    """Profile one GH Archive hour from the network or a local file: python gharchive_lib.py 2026-11-09T15."""
    parser = argparse.ArgumentParser(description=main.__doc__)
    parser.add_argument("hour", help="UTC hour, for example 2025-10-01T15")
    parser.add_argument("--file", type=Path, help="local .json.gz instead of downloading")
    args = parser.parse_args(argv)
    hour = normalize_hour(datetime.fromisoformat(args.hour))
    if args.file:
        raw = args.file.read_bytes()
    else:
        request = urllib.request.Request(source_url(hour), headers={"User-Agent": USER_AGENT})
        with urllib.request.urlopen(request, timeout=300) as response:
            raw = response.read()
    lines = gzip.decompress(raw).decode("utf-8").splitlines()
    print(json.dumps({"hour": snowflake_ts(hour), "compressed_bytes": len(raw), **profile_lines(lines, hour)}, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
