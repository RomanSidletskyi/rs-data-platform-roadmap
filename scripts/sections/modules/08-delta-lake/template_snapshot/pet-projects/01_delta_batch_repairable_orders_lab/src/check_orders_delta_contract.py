from __future__ import annotations

import json
import sys


REQUIRED_FIELDS = {
    "order_id",
    "business_date",
    "customer_id",
    "country_code",
    "gross_amount",
    "order_status",
}
ALLOWED_STATUSES = {"paid", "refunded", "pending"}


def check_file(path: str) -> list[str]:
    findings: list[str] = []
    with open(path, "r", encoding="utf-8") as handle:
        for line_number, raw_line in enumerate(handle, start=1):
            row = json.loads(raw_line)
            missing = sorted(REQUIRED_FIELDS - row.keys())
            if missing:
                findings.append(f"line {line_number}: missing fields: {', '.join(missing)}")
                continue
            if row["country_code"] != row["country_code"].strip().upper():
                findings.append(f"line {line_number}: country_code must be uppercase and trimmed")
            try:
                float(row["gross_amount"])
            except (TypeError, ValueError):
                findings.append(f"line {line_number}: gross_amount must be numeric")
            if row["order_status"] not in ALLOWED_STATUSES:
                findings.append(f"line {line_number}: unsupported order_status={row['order_status']}")
    return findings


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/check_orders_delta_contract.py <jsonl-path>")
    findings = check_file(sys.argv[1])
    if findings:
        sys.stdout.write("\n".join(findings) + "\n")
        return
    sys.stdout.write("delta-contract-check=pass\n")


if __name__ == "__main__":
    main()
