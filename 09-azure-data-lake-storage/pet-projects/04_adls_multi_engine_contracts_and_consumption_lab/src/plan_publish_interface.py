import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        contract = json.load(handle)

    plan = {
        "official_publish_path": contract["official_publish_path"],
        "internal_curated_path": contract["internal_curated_path"],
        "required_columns": contract["required_columns"],
        "schema_change_candidate": contract["schema_change_candidate"],
        "supported_engines": contract["supported_engines"],
    }
    print(json.dumps(plan, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
