import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        blueprint = json.load(handle)

    plan = {
        "storage_account": blueprint["storage_account"],
        "assignments": blueprint["path_acl_rules"],
        "supported_consumer_paths": blueprint["supported_consumer_paths"],
        "forbidden_consumer_paths": blueprint["forbidden_consumer_paths"],
    }
    print(json.dumps(plan, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
