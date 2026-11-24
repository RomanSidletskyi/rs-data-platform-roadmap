"""Download hourly historical weather from the Open-Meteo archive API: one JSON file per city per year."""

from __future__ import annotations

import argparse
import json
import sys
import time
import urllib.parse
import urllib.request
from datetime import date, datetime, timezone
from pathlib import Path

ARCHIVE_URL = "https://archive-api.open-meteo.com/v1/archive"
USER_AGENT = "rs-data-platform-roadmap-p02/1.0 (learning project)"
HOURLY = ["temperature_2m", "relative_humidity_2m", "precipitation", "wind_speed_10m", "cloud_cover", "weather_code"]

# slug, name, latitude, longitude, IANA time zone
CITIES = [
    ("nyc", "New York", 40.7128, -74.0060, "America/New_York"),
    ("london", "London", 51.5074, -0.1278, "Europe/London"),
    ("kyiv", "Kyiv", 50.4501, 30.5234, "Europe/Kiev"),
    ("tokyo", "Tokyo", 35.6762, 139.6503, "Asia/Tokyo"),
    ("sydney", "Sydney", -33.8688, 151.2093, "Australia/Sydney"),
    ("sao_paulo", "Sao Paulo", -23.5505, -46.6333, "America/Sao_Paulo"),
]


def build_url(latitude: float, longitude: float, start: date, end: date) -> str:
    params = {
        "latitude": latitude,
        "longitude": longitude,
        "start_date": start.isoformat(),
        "end_date": end.isoformat(),
        "hourly": ",".join(HOURLY),
        "timezone": "UTC",
    }
    return f"{ARCHIVE_URL}?{urllib.parse.urlencode(params)}"


def year_range(year: int, today: date) -> tuple[date, date] | None:
    start = date(year, 1, 1)
    # The archive lags real time by a few days; stop a week back to avoid partial trailing days.
    end = min(date(year, 12, 31), date.fromordinal(today.toordinal() - 7))
    return (start, end) if start <= end else None


def with_source(payload: dict, slug: str, name: str, tz: str, year: int) -> dict:
    payload["_source"] = {
        "city_slug": slug,
        "city_name": name,
        "time_zone": tz,
        "year": year,
        "fetched_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "api": ARCHIVE_URL,
    }
    return payload


def fetch(url: str) -> dict:
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(request, timeout=60) as response:
        return json.loads(response.read())


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--data-dir", type=Path, default=Path("data"))
    parser.add_argument("--from-year", type=int, default=2016)
    parser.add_argument("--to-year", type=int, default=date.today().year)
    parser.add_argument("--cities", default=",".join(c[0] for c in CITIES))
    parser.add_argument("--pause-seconds", type=float, default=1.0, help="be polite to the free API")
    args = parser.parse_args(argv)

    wanted = set(args.cities.split(","))
    today = date.today()
    for slug, name, lat, lon, tz in CITIES:
        if slug not in wanted:
            continue
        for year in range(args.from_year, args.to_year + 1):
            span = year_range(year, today)
            if span is None:
                continue
            target = args.data_dir / "weather" / f"city={slug}" / f"year={year}" / "open_meteo_hourly.json"
            payload = with_source(fetch(build_url(lat, lon, *span)), slug, name, tz, year)
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(json.dumps(payload, separators=(",", ":")))
            print(f"{slug} {year}: {len(payload['hourly']['time'])} hours -> {target}")
            time.sleep(args.pause_seconds)
    return 0


if __name__ == "__main__":
    sys.exit(main())
