import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        blueprint = json.load(handle)

    print("status=REPLAY_BOUNDARY_OK")
    print(f"replay_prefix_count={len(blueprint['replay_critical_prefixes'])}")
    print(f"temporary_prefix_count={len(blueprint['temporary_prefixes'])}")
    print(f"published_prefix_count={len(blueprint['published_prefixes'])}")
    print(f"temporary_retention_days={blueprint['retention_days']['temporary']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
