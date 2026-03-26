import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        blueprint = json.load(handle)
    with open(sys.argv[2], "r", encoding="utf-8") as handle:
        inventory = json.load(handle)

    replay_review_required = sorted(
        item["path"]
        for item in inventory
        if item["path_class"] == "raw" and item["age_days"] > blueprint["retention_days"]["raw"]
    )
    publish_review_required = sorted(
        item["path"]
        for item in inventory
        if item["path_class"] == "publish" and item["age_days"] > blueprint["retention_days"]["publish"]
    )
    safe_temporary_delete = sorted(
        item["path"]
        for item in inventory
        if item["path_class"] == "temporary" and item["age_days"] > blueprint["retention_days"]["temporary"]
    )

    output = {
        "publish_review_required": publish_review_required,
        "replay_review_required": replay_review_required,
        "safe_temporary_delete": safe_temporary_delete,
        "recommendation": "Require manual review before deleting aged raw or publish paths, even when age exceeds the nominal retention window.",
    }
    print(json.dumps(output, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
