"""Download market data as delivered: Coinbase hourly candles (crypto) and FRED daily series (equities, dollar).

Coinbase: one JSON envelope per product and request window, coinbase/product=<id>/<start>_<end>.json
FRED:     one CSV per series and run,                        fred/series=<id>/<fetched>.csv
"""

from __future__ import annotations

import argparse
import json
import sys
import time
import urllib.error
import urllib.request
from datetime import datetime, timedelta, timezone
from pathlib import Path

COINBASE = "https://api.exchange.coinbase.com/products/{product}/candles?granularity={granularity}&start={start}&end={end}"
FRED = "https://fred.stlouisfed.org/graph/fredgraph.csv?id={series}&cosd={start}"
USER_AGENT = "rs-data-platform-roadmap-p09/1.0 (learning project)"
PRODUCTS = ["BTC-USD", "ETH-USD", "SOL-USD"]
SERIES = ["SP500", "NASDAQCOM", "DTWEXBGS"]
MAX_CANDLES = 300  # Coinbase returns at most 300 candles per request


def windows(start: datetime, end: datetime, granularity: int) -> list[tuple[datetime, datetime]]:
    """Split [start, end) into request windows of at most MAX_CANDLES candles."""
    step = timedelta(seconds=granularity * MAX_CANDLES)
    result, cursor = [], start
    while cursor < end:
        result.append((cursor, min(cursor + step, end)))
        cursor += step
    return result


def floor_hour(ts: datetime) -> datetime:
    return ts.replace(minute=0, second=0, microsecond=0)


def envelope(product: str, granularity: int, start: datetime, end: datetime, candles: list) -> dict:
    return {
        "product": product,
        "granularity": granularity,
        "window_start": start.isoformat(),
        "window_end": end.isoformat(),
        "fetched_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        # [time, low, high, open, close, volume], newest first, as the API returns them
        "candles": candles,
    }


def get(url: str, user_agent: str | None = USER_AGENT, attempts: int = 3) -> bytes:
    headers = {"User-Agent": user_agent} if user_agent else {}
    for attempt in range(1, attempts + 1):
        try:
            with urllib.request.urlopen(urllib.request.Request(url, headers=headers), timeout=60) as response:
                return response.read()
        except (urllib.error.URLError, TimeoutError, ConnectionError):
            if attempt == attempts:
                raise
            time.sleep(2 ** attempt)
    raise AssertionError("unreachable")


def fetch_coinbase(out: Path, days: int, granularity: int, pause: float) -> int:
    end = floor_hour(datetime.now(timezone.utc))
    start = end - timedelta(days=days)
    files = 0
    for product in PRODUCTS:
        for w_start, w_end in windows(start, end, granularity):
            url = COINBASE.format(product=product, granularity=granularity, start=w_start.isoformat(), end=w_end.isoformat())
            candles = json.loads(get(url))
            target = out / "coinbase" / f"product={product}" / f"{w_start:%Y%m%dT%H}_{w_end:%Y%m%dT%H}.json"
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(json.dumps(envelope(product, granularity, w_start, w_end, candles)))
            files += 1
            time.sleep(pause)
    return files


def fetch_fred(out: Path, start: str) -> int:
    fetched = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S")
    for series in SERIES:
        target = out / "fred" / f"series={series}" / f"{fetched}.csv"
        target.parent.mkdir(parents=True, exist_ok=True)
        # FRED drops connections for some custom User-Agent strings; the library default is accepted.
        target.write_bytes(get(FRED.format(series=series, start=start), user_agent=None))
    return len(SERIES)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--days", type=int, default=3, help="Coinbase lookback; overlapping windows are deduplicated in dbt")
    parser.add_argument("--granularity", type=int, default=3600)
    parser.add_argument("--fred-start", default="2023-01-01")
    parser.add_argument("--pause-seconds", type=float, default=0.3)
    parser.add_argument("--sources", choices=["all", "coinbase", "fred"], default="all", help="FRED is daily data: fetch it once a day")
    args = parser.parse_args(argv)

    coinbase_files = fetch_coinbase(args.out, args.days, args.granularity, args.pause_seconds) if args.sources != "fred" else 0
    fred_files = fetch_fred(args.out, args.fred_start) if args.sources != "coinbase" else 0
    print(f"coinbase files {coinbase_files}, fred files {fred_files} -> {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
