import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        blueprint = json.load(handle)

    preview = {
        "published_prefixes": blueprint["published_prefixes"],
        "retention_days": blueprint["retention_days"],
        "temporary_prefixes": blueprint["temporary_prefixes"],
        "replay_critical_prefixes": blueprint["replay_critical_prefixes"],
    }
    print(json.dumps(preview, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
