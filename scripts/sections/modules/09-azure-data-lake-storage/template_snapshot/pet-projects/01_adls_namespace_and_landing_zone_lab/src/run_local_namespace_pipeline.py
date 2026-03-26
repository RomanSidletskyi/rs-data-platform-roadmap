import json
import sys
from pathlib import Path


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        blueprint = json.load(handle)
    with open(sys.argv[2], "r", encoding="utf-8") as handle:
        objects = json.load(handle)

    output = {
        "environment": blueprint["environment"],
        "storage_account": blueprint["storage_account"],
        "published_paths": sorted(
            dataset["publish_path"]
            for domain in blueprint["domains"]
            for dataset in domain["datasets"]
            if dataset["published"]
        ),
        "internal_only_paths": blueprint["internal_only_paths"],
        "object_count": len(objects),
        "consumer_contract_count": sum(1 for item in objects if item["purpose"] == "consumer_contract"),
        "recommendation": "Keep quarantine and working paths out of the publish container.",
    }

    payload = json.dumps(output, indent=2, sort_keys=True)
    if len(sys.argv) > 3:
        Path(sys.argv[3]).write_text(payload + "\n", encoding="utf-8")
    print(payload)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
