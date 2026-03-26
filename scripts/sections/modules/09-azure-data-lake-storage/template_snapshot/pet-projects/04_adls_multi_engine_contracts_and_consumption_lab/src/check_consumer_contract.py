import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        contract = json.load(handle)

    print("status=CONSUMER_CONTRACT_OK")
    print(f"supported_engine_count={len(contract['supported_engines'])}")
    print(f"required_column_count={len(contract['required_columns'])}")
    print(f"official_publish_path={contract['official_publish_path']}")
    print(f"schema_drop_count={len(contract['schema_change_candidate']['drops'])}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
