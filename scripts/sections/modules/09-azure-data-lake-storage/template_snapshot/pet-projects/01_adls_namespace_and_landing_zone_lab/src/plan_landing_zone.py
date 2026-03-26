import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        blueprint = json.load(handle)

    published = []
    internal = []
    for domain in blueprint["domains"]:
        for dataset in domain["datasets"]:
            published.append(
                {
                    "dataset": dataset["name"],
                    "publish_path": dataset["publish_path"],
                    "stable_contract": dataset["published"],
                }
            )
            internal.append(
                {
                    "dataset": dataset["name"],
                    "raw_path": dataset["raw_path"],
                    "curated_path": dataset["curated_path"],
                }
            )

    plan = {
        "storage_account": blueprint["storage_account"],
        "top_level_boundaries": blueprint["containers"],
        "published_datasets": published,
        "internal_only_paths": blueprint["internal_only_paths"],
        "internal_dataset_paths": internal,
    }
    print(json.dumps(plan, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
