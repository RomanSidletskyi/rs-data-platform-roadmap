import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        blueprint = json.load(handle)

    containers = set(blueprint["containers"])
    required = {"raw", "curated", "publish"}
    missing = sorted(required - containers)
    status = "NAMESPACE_CONTRACT_OK" if not missing else "NAMESPACE_CONTRACT_INVALID"
    print(f"status={status}")
    print(f"storage_account={blueprint['storage_account']}")
    print(f"container_count={len(blueprint['containers'])}")
    print(f"published_dataset_count={sum(1 for domain in blueprint['domains'] for dataset in domain['datasets'] if dataset['published'])}")
    print(f"missing_required_containers={','.join(missing) if missing else 'none'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
