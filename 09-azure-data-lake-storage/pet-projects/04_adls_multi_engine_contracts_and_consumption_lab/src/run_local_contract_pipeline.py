import json
import sys
from pathlib import Path


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        contract = json.load(handle)
    with open(sys.argv[2], "r", encoding="utf-8") as handle:
        requests = json.load(handle)

    output = {
        "official_publish_path": contract["official_publish_path"],
        "supported_engine_count": len(contract["supported_engines"]),
        "unsupported_request_count": sum(1 for item in requests if not item["requested_path"].startswith("publish/")),
        "breaking_change_detected": bool(contract["schema_change_candidate"]["drops"]),
        "recommendation": "Do not treat internal curated serving paths as public contracts across engines.",
    }

    payload = json.dumps(output, indent=2, sort_keys=True)
    if len(sys.argv) > 3:
        Path(sys.argv[3]).write_text(payload + "\n", encoding="utf-8")
    print(payload)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
