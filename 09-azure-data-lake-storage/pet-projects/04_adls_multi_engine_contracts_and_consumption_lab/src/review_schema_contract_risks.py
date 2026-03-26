import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        contract = json.load(handle)

    dropped_required = sorted(
        column
        for column in contract["schema_change_candidate"]["drops"]
        if column in contract["required_columns"]
    )
    output = {
        "dropped_required_columns": dropped_required,
        "official_path_is_publish": contract["official_publish_path"].startswith("publish/"),
        "risk_detected": bool(dropped_required) or not contract["official_publish_path"].startswith("publish/"),
        "recommendation": "Keep the official contract on a publish path and do not drop columns that downstream engines treat as required.",
    }
    print(json.dumps(output, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
