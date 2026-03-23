import csv
import json
from collections import defaultdict
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path


REQUIRED_FIELDS = {"order_id", "region", "category", "amount"}


def load_config(config_path: str) -> dict:
    with open(config_path, "r", encoding="utf-8") as config_file:
        return json.load(config_file)


def read_rows(input_path: str) -> list[dict]:
    with open(input_path, "r", encoding="utf-8", newline="") as csv_file:
        reader = csv.DictReader(csv_file)
        fieldnames = set(reader.fieldnames or [])
        missing_fields = REQUIRED_FIELDS - fieldnames
        if missing_fields:
            missing = ", ".join(sorted(missing_fields))
            raise ValueError(f"Missing required fields: {missing}")

        rows = list(reader)
        if not rows:
            raise ValueError("Input file is empty")
        return rows


def quantize_amount(value: Decimal) -> str:
    return str(value.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP))


def summarize_rows(rows: list[dict], amount_field: str = "amount") -> dict:
    region_totals: dict[str, Decimal] = defaultdict(Decimal)
    category_totals: dict[str, Decimal] = defaultdict(Decimal)
    total_amount = Decimal("0")

    for row in rows:
        amount = Decimal(row[amount_field])
        total_amount += amount
        region_totals[row["region"]] += amount
        category_totals[row["category"]] += amount

    return {
        "total_rows": len(rows),
        "total_amount": quantize_amount(total_amount),
        "region_totals": {key: quantize_amount(value) for key, value in sorted(region_totals.items())},
        "category_totals": {key: quantize_amount(value) for key, value in sorted(category_totals.items())},
    }


def write_summary(summary: dict, output_dir: str, summary_filename: str) -> Path:
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)
    summary_path = output_path / summary_filename
    with open(summary_path, "w", encoding="utf-8") as summary_file:
        json.dump(summary, summary_file, indent=2)
        summary_file.write("\n")
    return summary_path


def write_group_totals(output_dir: str, filename: str, header_name: str, totals: dict[str, str]) -> Path:
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)
    csv_path = output_path / filename
    with open(csv_path, "w", encoding="utf-8", newline="") as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow([header_name, "total_amount"])
        for key, value in totals.items():
            writer.writerow([key, value])
    return csv_path


def run_batch_job(input_path: str, output_dir: str, config_path: str) -> dict:
    config = load_config(config_path)
    rows = read_rows(input_path)
    summary = summarize_rows(rows, amount_field=config.get("amount_field", "amount"))

    write_summary(summary, output_dir, config.get("summary_output", "summary.json"))
    write_group_totals(
        output_dir,
        config.get("region_output", "region_totals.csv"),
        "region",
        summary["region_totals"],
    )
    write_group_totals(
        output_dir,
        config.get("category_output", "category_totals.csv"),
        "category",
        summary["category_totals"],
    )
    return summary