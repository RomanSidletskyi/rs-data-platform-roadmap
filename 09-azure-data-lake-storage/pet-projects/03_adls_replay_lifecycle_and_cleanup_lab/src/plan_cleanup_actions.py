import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        blueprint = json.load(handle)
    with open(sys.argv[2], "r", encoding="utf-8") as handle:
        inventory = json.load(handle)

    delete_candidates = []
    keep_candidates = []
    for item in inventory:
        retention_limit = blueprint["retention_days"][item["path_class"]]
        record = {
            "age_days": item["age_days"],
            "path": item["path"],
            "path_class": item["path_class"],
        }
        if item["age_days"] > retention_limit and item["path_class"] == "temporary":
            delete_candidates.append(record)
        else:
            keep_candidates.append(record)

    plan = {
        "delete_candidates": delete_candidates,
        "keep_candidates": keep_candidates,
        "warning": "Never delete replay-critical or published paths without validating recovery and consumer impact.",
    }
    print(json.dumps(plan, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
