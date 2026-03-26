import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        requests = json.load(handle)

    supported = []
    unsupported = []
    for item in requests:
        if item["requested_path"].startswith("publish/"):
            supported.append(item)
        else:
            unsupported.append(item)

    review = {
        "supported_requests": supported,
        "unsupported_requests": unsupported,
        "recommendation": "Expose one official publish path and keep engine-specific working paths unsupported.",
    }
    print(json.dumps(review, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
