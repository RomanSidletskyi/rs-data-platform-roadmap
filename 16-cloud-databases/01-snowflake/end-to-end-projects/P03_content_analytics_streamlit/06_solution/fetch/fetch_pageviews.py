"""Download Wikipedia pageviews from the Wikimedia REST API: daily top articles and daily project totals."""

from __future__ import annotations

import argparse
import json
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from datetime import date, datetime, timedelta, timezone
from pathlib import Path

API = "https://wikimedia.org/api/rest_v1/metrics/pageviews"
# Wikimedia asks every client to identify itself; requests without a User-Agent can be blocked.
USER_AGENT = "rs-data-platform-roadmap-p03/1.0 (learning project)"
PROJECTS = ["en.wikipedia", "de.wikipedia", "uk.wikipedia"]


def top_url(project: str, day: date) -> str:
    return f"{API}/top/{urllib.parse.quote(project)}/all-access/{day:%Y/%m/%d}"


def aggregate_url(project: str, start: date, end: date) -> str:
    return f"{API}/aggregate/{urllib.parse.quote(project)}/all-access/user/daily/{start:%Y%m%d}00/{end:%Y%m%d}00"


def default_end(today: date) -> date:
    # Daily files are published with a delay of roughly one day; two days back is reliably available.
    return today - timedelta(days=2)


def day_range(end: date, days: int) -> list[date]:
    return [end - timedelta(days=offset) for offset in range(days - 1, -1, -1)]


def with_source(payload: dict, kind: str, project: str, url: str, **extra: str) -> dict:
    payload["_source"] = {
        "kind": kind,
        "project": project,
        "url": url,
        "fetched_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        **extra,
    }
    return payload


def fetch(url: str) -> dict | None:
    """Return the JSON body, or None when the day is not published yet (HTTP 404)."""
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    try:
        with urllib.request.urlopen(request, timeout=60) as response:
            return json.loads(response.read())
    except urllib.error.HTTPError as error:
        if error.code == 404:
            return None
        raise


def write(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--data-dir", type=Path, default=Path("data"))
    parser.add_argument("--days", type=int, default=30)
    parser.add_argument("--end-date", type=date.fromisoformat, default=default_end(date.today()))
    parser.add_argument("--projects", default=",".join(PROJECTS))
    parser.add_argument("--force", action="store_true", help="re-download top lists that already exist")
    parser.add_argument("--pause-seconds", type=float, default=0.2)
    args = parser.parse_args(argv)

    root = args.data_dir / "pageviews"
    days = day_range(args.end_date, args.days)
    for project in args.projects.split(","):
        fetched = skipped = missing = 0
        for day in days:
            target = root / "kind=top" / f"project={project}" / f"top_{day.isoformat()}.json"
            # A published day never changes, so existing files are kept unless --force.
            if target.exists() and not args.force:
                skipped += 1
                continue
            url = top_url(project, day)
            payload = fetch(url)
            if payload is None:
                missing += 1
                continue
            write(target, with_source(payload, "top", project, url, day=day.isoformat()))
            fetched += 1
            time.sleep(args.pause_seconds)

        url = aggregate_url(project, days[0], days[-1])
        payload = fetch(url)
        if payload is not None:
            target = root / "kind=aggregate" / f"project={project}" / f"aggregate_{days[0]}_{days[-1]}.json"
            write(target, with_source(payload, "aggregate", project, url, start=days[0].isoformat(), end=days[-1].isoformat()))
        print(f"{project}: top fetched {fetched}, kept {skipped}, not published {missing}; aggregate {'ok' if payload else 'missing'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
