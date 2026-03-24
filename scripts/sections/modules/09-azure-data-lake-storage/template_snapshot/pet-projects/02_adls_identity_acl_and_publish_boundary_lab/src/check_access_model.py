import json
import sys


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        blueprint = json.load(handle)

    supported_paths = set(blueprint["supported_consumer_paths"])
    forbidden_paths = set(blueprint["forbidden_consumer_paths"])
    analyst_rules = [rule for rule in blueprint["path_acl_rules"] if rule["principal"] == "grp-retail-analytics"]
    valid = analyst_rules and all(rule["path"] in supported_paths for rule in analyst_rules)
    print(f"status={'ACCESS_MODEL_OK' if valid else 'ACCESS_MODEL_INVALID'}")
    print(f"rbac_role_count={len(blueprint['resource_rbac_roles'])}")
    print(f"path_acl_rule_count={len(blueprint['path_acl_rules'])}")
    print(f"supported_consumer_path_count={len(supported_paths)}")
    print(f"forbidden_consumer_path_count={len(forbidden_paths)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
