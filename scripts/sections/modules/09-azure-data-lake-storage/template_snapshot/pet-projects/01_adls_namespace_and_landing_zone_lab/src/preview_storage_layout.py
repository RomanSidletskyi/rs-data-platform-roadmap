import json
import sys


def classify(objects):
    counts = {"consumer_contract": 0, "internal_trusted": 0, "landing": 0, "quarantine": 0}
    for item in objects:
        counts[item["purpose"]] += 1
    return counts


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        objects = json.load(handle)

    preview = {
        "object_count": len(objects),
        "purpose_counts": classify(objects),
        "contract_paths": sorted(item["path"] for item in objects if item["purpose"] == "consumer_contract"),
        "internal_paths": sorted(item["path"] for item in objects if item["purpose"] != "consumer_contract"),
    }
    print(json.dumps(preview, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
