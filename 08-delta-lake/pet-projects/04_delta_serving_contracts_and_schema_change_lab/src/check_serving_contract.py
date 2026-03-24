from __future__ import annotations

import json
import sys


REQUIRED_FIELDS = {"business_date", "store_id", "gross_sales", "order_count"}


def check_file(path: str) -> list[str]:
    findings: list[str] = []
    with open(path, "r", encoding="utf-8") as handle:
        for line_number, raw_line in enumerate(handle, start=1):
            row = json.loads(raw_line)
            missing = sorted(REQUIRED_FIELDS - row.keys())
            if missing:
                findings.append(f"line {line_number}: missing fields: {', '.join(missing)}")
                continue
            try:
                float(row["gross_sales"])
            except (TypeError, ValueError):
                findings.append(f"line {line_number}: gross_sales must be numeric")
            if not isinstance(row["order_count"], int):
                findings.append(f"line {line_number}: order_count must be integer")
    return findings


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/check_serving_contract.py <jsonl-path>")
    findings = check_file(sys.argv[1])
    if findings:
        sys.stdout.write("\n".join(findings) + "\n")
        return
    sys.stdout.write("serving-contract-check=pass\n")


if __name__ == "__main__":
    main()
