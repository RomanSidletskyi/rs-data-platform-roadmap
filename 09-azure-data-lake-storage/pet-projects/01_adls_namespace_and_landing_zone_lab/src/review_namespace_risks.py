import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        objects = json.load(handle)

    contract_outside_publish = sorted(
        item["path"]
        for item in objects
        if item["purpose"] == "consumer_contract" and not item["path"].startswith("publish/")
    )
    internal_inside_publish = sorted(
        item["path"]
        for item in objects
        if item["purpose"] != "consumer_contract" and item["path"].startswith("publish/")
    )

    output = {
        "consumer_contracts_outside_publish": contract_outside_publish,
        "internal_working_objects_inside_publish": internal_inside_publish,
        "risk_detected": bool(contract_outside_publish or internal_inside_publish),
        "recommendation": "Keep contract data only on publish paths and keep temporary working outputs out of publish.",
    }
    print(json.dumps(output, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
