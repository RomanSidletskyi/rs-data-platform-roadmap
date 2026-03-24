from __future__ import annotations

import json
import sys


SUPPORTED_CURRENCIES = {"EUR", "PLN", "UAH"}


def check_file(path: str) -> list[str]:
    findings: list[str] = []
    with open(path, "r", encoding="utf-8") as handle:
        for line_number, raw_line in enumerate(handle, start=1):
            row = json.loads(raw_line)
            if float(row["gross_amount"]) < 0:
                findings.append(f"line {line_number}: gross_amount must be non-negative")
            if row["currency_code"] != row["currency_code"].strip().upper():
                findings.append(f"line {line_number}: currency_code must be uppercase and trimmed")
            if row["currency_code"].strip().upper() not in SUPPORTED_CURRENCIES:
                findings.append(f"line {line_number}: unsupported currency_code={row['currency_code']}")
    return findings


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/check_quality_rules.py <jsonl-path>")
    findings = check_file(sys.argv[1])
    if findings:
        sys.stdout.write("\n".join(findings) + "\n")
        return
    sys.stdout.write("quality-check=pass\n")


if __name__ == "__main__":
    main()
