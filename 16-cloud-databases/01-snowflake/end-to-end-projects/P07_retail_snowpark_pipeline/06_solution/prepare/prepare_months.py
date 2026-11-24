"""Split UCI Online Retail II into monthly CSV files, as monthly deliveries from a shop system would arrive.

  <out>/month=YYYY-MM/online_retail_<sheet>.csv

Both workbook sheets are kept as delivered. They overlap in December 2010, so that month gets two files with
partly identical rows; deduplication is the pipeline's job, not this script's.

--synthetic writes three small months with the same columns and the same kinds of dirt, for when the source is
unavailable or for fast experiments.
"""

from __future__ import annotations

import argparse
import csv
import io
import random
import sys
import urllib.request
import zipfile
from datetime import datetime, timedelta
from pathlib import Path
from typing import Iterable, Iterator

SOURCE_URL = "https://archive.ics.uci.edu/static/public/502/online+retail+ii.zip"
COLUMNS = ["invoice", "stock_code", "description", "quantity", "invoice_date", "price", "customer_id", "country"]


def normalise(row: tuple) -> dict:
    invoice, stock_code, description, quantity, invoice_date, price, customer_id, country = row
    return {
        "invoice": "" if invoice is None else str(invoice),
        "stock_code": "" if stock_code is None else str(stock_code),
        "description": "" if description is None else str(description).strip(),
        "quantity": "" if quantity is None else str(quantity),
        "invoice_date": invoice_date.strftime("%Y-%m-%d %H:%M:%S") if isinstance(invoice_date, datetime) else str(invoice_date or ""),
        "price": "" if price is None else str(price),
        # Excel stores the id as a number; keep the integer text so 13085.0 becomes 13085.
        "customer_id": "" if customer_id is None else str(int(customer_id)),
        "country": "" if country is None else str(country),
    }


def sheet_tag(title: str) -> str:
    return "y" + title.replace("Year ", "").replace("-", "_")


def write_months(rows: Iterable[dict], out: Path, tag: str) -> dict[str, int]:
    handles: dict[str, tuple] = {}
    counts: dict[str, int] = {}
    try:
        for row in rows:
            month = row["invoice_date"][:7]
            if month not in handles:
                folder = out / f"month={month}"
                folder.mkdir(parents=True, exist_ok=True)
                handle = (folder / f"online_retail_{tag}.csv").open("w", newline="", encoding="utf-8")
                writer = csv.DictWriter(handle, fieldnames=COLUMNS)
                writer.writeheader()
                handles[month] = (handle, writer)
                counts[month] = 0
            handles[month][1].writerow(row)
            counts[month] += 1
    finally:
        for handle, _ in handles.values():
            handle.close()
    return counts


def read_workbook(xlsx: Path) -> Iterator[tuple[str, Iterator[dict]]]:
    import openpyxl  # only needed for the real dataset

    workbook = openpyxl.load_workbook(xlsx, read_only=True)
    for sheet in workbook.worksheets:
        rows = sheet.iter_rows(values_only=True)
        next(rows)  # header
        yield sheet_tag(sheet.title), (normalise(r) for r in rows if any(v is not None for v in r))


def download(target_dir: Path) -> Path:
    xlsx = target_dir / "online_retail_II.xlsx"
    if xlsx.exists():
        return xlsx
    target_dir.mkdir(parents=True, exist_ok=True)
    request = urllib.request.Request(SOURCE_URL, headers={"User-Agent": "rs-data-platform-roadmap-p07/1.0"})
    with urllib.request.urlopen(request, timeout=300) as response:
        archive = zipfile.ZipFile(io.BytesIO(response.read()))
    archive.extract("online_retail_II.xlsx", target_dir)
    return xlsx


def synthetic_rows(seed: int = 7) -> Iterator[dict]:
    rng = random.Random(seed)
    products = [(f"2{n:04d}", f"PRODUCT {n}", round(rng.uniform(0.5, 15), 2)) for n in range(300)]
    countries = ["United Kingdom"] * 8 + ["Germany", "France", "EIRE", "Netherlands"]
    start = datetime(2011, 1, 3, 8)
    invoice = 600000
    for day in range(0, 88):
        for _ in range(rng.randint(20, 40)):
            invoice += 1
            when = start + timedelta(days=day, minutes=rng.randint(0, 600))
            customer = "" if rng.random() < 0.2 else str(rng.randint(12000, 12600))
            country = rng.choice(countries)
            cancel = rng.random() < 0.03
            for _ in range(rng.randint(1, 8)):
                code, name, price = rng.choice(products)
                qty = rng.randint(1, 24)
                row = {
                    "invoice": f"C{invoice}" if cancel else str(invoice), "stock_code": code, "description": name,
                    "quantity": str(-qty if cancel else qty), "invoice_date": when.strftime("%Y-%m-%d %H:%M:%S"),
                    "price": str(price), "customer_id": customer, "country": country,
                }
                yield row
                if rng.random() < 0.01:
                    yield dict(row)  # exact duplicate
            if rng.random() < 0.05:
                yield {**row, "stock_code": "POST", "description": "POSTAGE", "quantity": "1", "price": "18.0"}
        # stock adjustments: negative quantity, zero price, no invoice prefix
        yield {"invoice": str(invoice + 1), "stock_code": "21733", "description": "damaged", "quantity": "-12",
               "invoice_date": (start + timedelta(days=day, hours=9)).strftime("%Y-%m-%d %H:%M:%S"),
               "price": "0", "customer_id": "", "country": "United Kingdom"}
        invoice += 1


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--out", type=Path, required=True, help="folder for month=YYYY-MM/ subfolders")
    parser.add_argument("--download-dir", type=Path, help="where to keep the downloaded workbook (default: --out/source)")
    parser.add_argument("--synthetic", action="store_true")
    args = parser.parse_args(argv)

    if args.synthetic:
        counts = write_months(synthetic_rows(), args.out, "synthetic")
        print(f"synthetic: {sum(counts.values())} rows in {len(counts)} months")
        return 0

    xlsx = download(args.download_dir or args.out / "source")
    for tag, rows in read_workbook(xlsx):
        counts = write_months(rows, args.out, tag)
        print(f"{tag}: {sum(counts.values())} rows in {len(counts)} months ({min(counts)} to {max(counts)})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
