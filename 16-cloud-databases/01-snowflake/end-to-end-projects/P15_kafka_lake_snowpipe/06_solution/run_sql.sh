#!/usr/bin/env bash
# Fill <placeholders> from p15.env and run SQL files with the Snowflake CLI.
# Usage: ./run_sql.sh core/00_account_setup.sql [more files ...]
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p15.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p15.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p15.env}"
[[ $# -gt 0 ]] || { echo "usage: $0 <file.sql> [more.sql ...]" >&2; exit 1; }

RENDERED="$DIR/.rendered"
mkdir -p "$RENDERED"

for rel in "$@"; do
  src="$DIR/$rel"
  [[ -f "$src" ]] || { echo "not found: $rel" >&2; exit 1; }
  out="$RENDERED/${rel//\//_}"
  sed \
    -e "s|<tenant-id>|${AZURE_TENANT_ID:-<tenant-id>}|g" \
    -e "s|<storage-account>|${P15_STORAGE_ACCOUNT:-<storage-account>}|g" \
    -e "s|<your-verified-email>|${P15_ALERT_EMAIL:-<your-verified-email>}|g" \
    -e "s|<aws-account-id>|${AWS_ACCOUNT_ID:-<aws-account-id>}|g" \
    -e "s|<bucket>|${P15_BUCKET:-<bucket>}|g" \
    "$src" > "$out"

  if grep -v '^[[:space:]]*--' "$out" | grep -Eo '<[a-z][a-z-]*>' | sort -u | grep . ; then
    echo "Unfilled placeholders in $rel (see above). Set them in p15.env." >&2
    exit 1
  fi

  echo "==> $rel"
  snow sql -c "$SNOW_CONNECTION" -f "$out"
done
