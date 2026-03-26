import json
import sys
from pathlib import Path


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        blueprint = json.load(handle)
    with open(sys.argv[2], "r", encoding="utf-8") as handle:
        inventory = json.load(handle)

    stale_temporary = [item["path"] for item in inventory if item["path_class"] == "temporary" and item["age_days"] > blueprint["retention_days"]["temporary"]]
    output = {
        "published_prefix_count": len(blueprint["published_prefixes"]),
        "replay_critical_prefix_count": len(blueprint["replay_critical_prefixes"]),
        "stale_temporary_paths": stale_temporary,
        "temporary_retention_days": blueprint["retention_days"]["temporary"],
        "warning": "Separate replay-critical history from temporary backfill debris before deleting anything.",
    }

    payload = json.dumps(output, indent=2, sort_keys=True)
    if len(sys.argv) > 3:
        Path(sys.argv[3]).write_text(payload + "\n", encoding="utf-8")
    print(payload)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
