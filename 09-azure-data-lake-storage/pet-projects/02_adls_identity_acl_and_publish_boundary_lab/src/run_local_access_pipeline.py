import json
import sys
from pathlib import Path


def main() -> int:
    with open(sys.argv[1], "r", encoding="utf-8") as handle:
        blueprint = json.load(handle)
    with open(sys.argv[2], "r", encoding="utf-8") as handle:
        requests = json.load(handle)

    output = {
        "storage_account": blueprint["storage_account"],
        "managed_identity_count": sum(1 for role in blueprint["resource_rbac_roles"] if role["principal"].startswith("mi-")),
        "service_principal_count": sum(1 for rule in blueprint["path_acl_rules"] if rule["principal"].startswith("spn-")),
        "supported_consumer_paths": blueprint["supported_consumer_paths"],
        "denied_request_count": sum(1 for item in requests if not item["requested_path"].startswith("publish/")),
        "recommendation": "Grant analysts read-only access to publish and keep engineering write scopes path-specific.",
    }

    payload = json.dumps(output, indent=2, sort_keys=True)
    if len(sys.argv) > 3:
        Path(sys.argv[3]).write_text(payload + "\n", encoding="utf-8")
    print(payload)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
