#!/usr/bin/env bash
# Fill <placeholders> from p11.env and run SQL files with the Snowflake CLI.
# Usage: ./run_sql.sh core/00_account_setup.sql [more files ...]
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p11.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p11.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p11.env}"
[[ $# -gt 0 ]] || { echo "usage: $0 <file.sql> [more.sql ...]" >&2; exit 1; }

# Public key body without the PEM header and footer lines, as Snowflake expects it.
key_body() { [[ -n "${1:-}" && -f "$1" ]] && grep -v -- '-----' "$1" | tr -d '\n' || true; }
POWERBI_KEY="$(key_body "${P11_POWERBI_PUBLIC_KEY_FILE:-}")"

RENDERED="$DIR/.rendered"
mkdir -p "$RENDERED"

for rel in "$@"; do
  src="$DIR/$rel"
  [[ -f "$src" ]] || { echo "not found: $rel" >&2; exit 1; }
  out="$RENDERED/${rel//\//_}"
  sed \
    -e "s|<powerbi-public-key>|${POWERBI_KEY:-<powerbi-public-key>}|g" \
    -e "s|<tenant-id>|${AZURE_TENANT_ID:-<tenant-id>}|g" \
    -e "s|<storage-account>|${P11_STORAGE_ACCOUNT:-<storage-account>}|g" \
    -e "s|<bucket>|${P11_BUCKET:-<bucket>}|g" \
    -e "s|<aws-account-id>|${P11_AWS_ACCOUNT_ID:-<aws-account-id>}|g" \
    "$src" > "$out"

  if grep -v '^[[:space:]]*--' "$out" | grep -Eo '<[a-z][a-z-]*>' | sort -u | grep . ; then
    echo "Unfilled placeholders in $rel (see above). Set them in p11.env." >&2
    exit 1
  fi

  echo "==> $rel"
  snow sql -c "$SNOW_CONNECTION" -f "$out"
done
