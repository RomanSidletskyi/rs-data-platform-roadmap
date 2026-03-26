from __future__ import annotations

import json
import sys


CURRENT_GRAIN = ["business_date", "store_id"]
REQUIRED_FIELDS = {"business_date", "store_id", "gross_sales", "order_count"}
TYPE_RULES = {"gross_sales": "string"}


def review_candidate(path: str) -> dict[str, object]:
    with open(path, "r", encoding="utf-8") as handle:
        candidate = json.load(handle)

    findings: list[str] = []
    removed_fields = set(candidate.get("proposed_removed_fields", []))
    if REQUIRED_FIELDS & removed_fields:
        findings.append("breaking: removes required field")

    proposed_type_changes = candidate.get("proposed_type_changes", {})
    for field_name, new_type in proposed_type_changes.items():
        if TYPE_RULES.get(field_name) and TYPE_RULES[field_name] != new_type:
            findings.append(f"breaking: changes type for {field_name}")

    proposed_grain = candidate.get("proposed_grain")
    if proposed_grain and proposed_grain != CURRENT_GRAIN:
        findings.append("breaking: changes consumer grain")

    return {
        "approved": not findings,
        "findings": findings,
    }


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 src/review_schema_change.py <candidate-json-path>")
    json.dump(review_candidate(sys.argv[1]), sys.stdout, indent=2)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
