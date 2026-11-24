"""Split the Cricsheet ODI archive into per-year folders so loads can be replayed as deltas."""

from __future__ import annotations

import argparse
import json
import sys
import urllib.request
import zipfile
from pathlib import Path

ARCHIVE_URL = "https://cricsheet.org/downloads/odis_json.zip"
USER_AGENT = "rs-data-platform-roadmap-p01/1.0 (learning project)"


def match_year(info: dict) -> str:
    dates = info.get("dates") or []
    return str(dates[0])[:4] if dates else "unknown"


def split_archive(zip_path: Path, out_dir: Path, from_year: int, to_year: int) -> dict[str, int]:
    counts: dict[str, int] = {}
    with zipfile.ZipFile(zip_path) as archive:
        for name in archive.namelist():
            if not name.endswith(".json"):
                continue
            data = archive.read(name)
            year = match_year(json.loads(data).get("info", {}))
            if year == "unknown" or not from_year <= int(year) <= to_year:
                continue
            target = out_dir / f"year={year}" / Path(name).name
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(data)
            counts[year] = counts.get(year, 0) + 1
    return dict(sorted(counts.items()))


def download(dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    request = urllib.request.Request(ARCHIVE_URL, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(request, timeout=120) as response, dest.open("wb") as out:
        while chunk := response.read(1 << 20):
            out.write(chunk)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--data-dir", type=Path, default=Path("data"))
    parser.add_argument("--from-year", type=int, default=2000)
    parser.add_argument("--to-year", type=int, default=2100)
    args = parser.parse_args(argv)

    zip_path = args.data_dir / "odis_json.zip"
    if not zip_path.exists():
        print(f"downloading {ARCHIVE_URL}")
        download(zip_path)
    counts = split_archive(zip_path, args.data_dir / "batches", args.from_year, args.to_year)
    for year, n in counts.items():
        print(f"year={year}: {n} matches")
    print(f"total: {sum(counts.values())} matches in {len(counts)} folders")
    return 0


if __name__ == "__main__":
    sys.exit(main())
