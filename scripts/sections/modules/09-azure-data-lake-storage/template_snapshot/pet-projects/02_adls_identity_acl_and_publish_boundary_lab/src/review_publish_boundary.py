import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        requests = json.load(handle)

    allowed = []
    denied = []
    for item in requests:
        if item["requested_path"].startswith("publish/"):
            allowed.append(item)
        else:
            denied.append(item)

    review = {
        "allowed_requests": allowed,
        "denied_requests": denied,
        "recommendation": "Keep analysts on publish paths and reject raw or working-path exploration by default.",
    }
    print(json.dumps(review, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
