import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        blueprint = json.load(handle)

    analyst_non_publish_paths = sorted(
        rule["path"]
        for rule in blueprint["path_acl_rules"]
        if rule["principal"] == "grp-retail-analytics" and not rule["path"].startswith("publish/")
    )
    publish_write_assignments = sorted(
        f"{rule['principal']}:{rule['path']}"
        for rule in blueprint["path_acl_rules"]
        if rule["path"].startswith("publish/") and "w" in rule["permission"]
    )

    output = {
        "analyst_non_publish_paths": analyst_non_publish_paths,
        "publish_write_assignments": publish_write_assignments,
        "risk_detected": bool(analyst_non_publish_paths or publish_write_assignments),
        "recommendation": "Keep analysts on publish-only reads and avoid broad write grants on publish paths.",
    }
    print(json.dumps(output, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
