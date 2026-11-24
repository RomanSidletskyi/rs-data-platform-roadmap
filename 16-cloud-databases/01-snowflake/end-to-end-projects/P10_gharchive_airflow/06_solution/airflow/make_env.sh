#!/usr/bin/env bash
# Generate .env (Compose variables) and airflow.env (container environment with Airflow connections) from ../p10.env.
# Both files are ignored by Git. Re-run after changing p10.env; existing Fernet and JWT secrets are kept.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/../p10.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p10.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a

: "${SNOWFLAKE_ACCOUNT:?set SNOWFLAKE_ACCOUNT in p10.env}"
: "${P10_KEYS_DIR:?set P10_KEYS_DIR in p10.env}"
[[ -f "$P10_KEYS_DIR/p10_airflow.p8" ]] || { echo "Missing $P10_KEYS_DIR/p10_airflow.p8 (see QUICKSTART step 3)." >&2; exit 1; }
P10_LANDING="${P10_LANDING:-internal}"

existing() { [[ -f "$DIR/.env" ]] && grep -E "^$1=" "$DIR/.env" | cut -d= -f2- || true; }
FERNET_KEY="$(existing FERNET_KEY)"
JWT_SECRET="$(existing JWT_SECRET)"
[[ -n "$FERNET_KEY" ]] || FERNET_KEY="$(openssl rand -base64 32 | tr '+/' '-_')"
[[ -n "$JWT_SECRET" ]] || JWT_SECRET="$(openssl rand -hex 32)"

umask 077
cat > "$DIR/.env" <<EOF
AIRFLOW_UID=$(id -u)
FERNET_KEY=$FERNET_KEY
JWT_SECRET=$JWT_SECRET
P10_KEYS_DIR=$P10_KEYS_DIR
EOF

# Connections as JSON in AIRFLOW_CONN_* variables: nothing is stored in the Airflow database.
python3 - "$DIR/airflow.env" <<'PY'
import json, os, sys

env = os.environ
lines = {
    "P10_LANDING": env.get("P10_LANDING", "internal"),
    "P10_START_DATE": env.get("P10_START_DATE", "2025-01-01"),
    "P10_HOT_DAYS": env.get("P10_HOT_DAYS", "30"),
    "P10_RAW_DAYS": env.get("P10_RAW_DAYS", "2"),
    "P10_AZURE_CONTAINER": "landing",
    "P10_S3_BUCKET": env.get("P10_BUCKET", ""),
    "P10_S3_ROOT": "landing/",
}
conns = {
    "P10_SNOWFLAKE": {
        "conn_type": "snowflake",
        "login": "P10_AIRFLOW_SVC",
        "extra": {
            "account": env["SNOWFLAKE_ACCOUNT"],
            "warehouse": "P10_WH",
            "database": "P10_GH",
            "role": "P10_PIPELINE",
            "private_key_file": "/opt/airflow/keys/p10_airflow.p8",
            "session_parameters": {"QUERY_TAG": "p10_airflow", "TIMEZONE": "UTC"},
        },
    },
}
landing = lines["P10_LANDING"]
if landing == "azure":
    for name in ("P10_STORAGE_ACCOUNT", "AZURE_TENANT_ID", "P10_AIRFLOW_SP_APP_ID", "P10_AIRFLOW_SP_SECRET"):
        if not env.get(name):
            sys.exit(f"P10_LANDING=azure needs {name} in p10.env")
    conns["P10_AZURE"] = {
        "conn_type": "wasb",
        "host": f"https://{env['P10_STORAGE_ACCOUNT']}.blob.core.windows.net",
        "login": env["P10_AIRFLOW_SP_APP_ID"],
        "password": env["P10_AIRFLOW_SP_SECRET"],
        "extra": {"tenant_id": env["AZURE_TENANT_ID"]},
    }
elif landing == "aws":
    for name in ("P10_BUCKET", "P10_REGION", "P10_AIRFLOW_AWS_ACCESS_KEY_ID", "P10_AIRFLOW_AWS_SECRET_ACCESS_KEY"):
        if not env.get(name):
            sys.exit(f"P10_LANDING=aws needs {name} in p10.env")
    conns["P10_AWS"] = {
        "conn_type": "aws",
        "login": env["P10_AIRFLOW_AWS_ACCESS_KEY_ID"],
        "password": env["P10_AIRFLOW_AWS_SECRET_ACCESS_KEY"],
        "extra": {"region_name": env["P10_REGION"]},
    }
elif landing != "internal":
    sys.exit("P10_LANDING must be internal, azure, or aws")

with open(sys.argv[1], "w") as out:
    for key, value in lines.items():
        out.write(f"{key}={value}\n")
    for name, conn in conns.items():
        # Single quotes: Compose reads the JSON literally.
        out.write(f"AIRFLOW_CONN_{name}='{json.dumps(conn, separators=(',', ':'))}'\n")
PY

mkdir -p "$DIR/logs"
echo "Wrote $DIR/.env and $DIR/airflow.env (landing: $P10_LANDING). Next: docker compose up -d --build"
