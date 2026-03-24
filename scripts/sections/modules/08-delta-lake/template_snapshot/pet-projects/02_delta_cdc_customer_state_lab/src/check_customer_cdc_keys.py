from __future__ import annotations

import json
import sys
from datetime import datetime


ALLOWED_OPERATIONS = {"upsert", "delete"}
REQUIRED_FIELDS = {"customer_id", "event_ts", "op", "email", "loyalty_tier"}


def validate_timestamp(raw_value: str) -> bool:
    try:
        datetime.fromisoformat(raw_value)
    except ValueError:
        return False
    return True


def check_file(path: str) -> list[str]:
    findings: list[str] = []
    with open(path, "r", encoding="utf-8") as handle:
        for line_number, raw_line in enumerate(handle, start=1):
            row = json.loads(raw_line)
            missing = sorted(REQUIRED_FIELDS - row.keys())
            if missing:
                findings.append(f"line {line_number}: missing fields: {', '.join(missing)}")
                continue
            if not row["customer_id"]:
                findings.append(f"line {line_number}: customer_id must not be empty")
            if row["op"] not in ALLOWED_OPERATIONS:
                findings.append(f"line {line_number}: unsupported op={row['op']}")
            if not validate_timestamp(row["event_ts"]):
                findings.append(f"line {line_number}: invalid event_ts")
            if row["op"] == "upsert" and not row["email"]:
                findings.append(f"line {line_number}: email must not be empty for upsert")
    return findings


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/check_customer_cdc_keys.py <jsonl-path>")
    findings = check_file(sys.argv[1])
    if findings:
        sys.stdout.write("\n".join(findings) + "\n")
        return
    sys.stdout.write("cdc-check=pass\n")


if __name__ == "__main__":
    main()
