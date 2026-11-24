#!/usr/bin/env bash
# Fill <placeholders> from p14.env and run SQL files with the Snowflake CLI.
# Usage: ./run_sql.sh core/00_account_setup.sql [more files ...]
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p14.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p14.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p14.env}"
[[ $# -gt 0 ]] || { echo "usage: $0 <file.sql> [more.sql ...]" >&2; exit 1; }

CONNECTOR_PUBLIC_KEY="<connector-public-key>"
if [[ -n "${P14_CONNECTOR_PUBLIC_KEY_FILE:-}" && -f "${P14_CONNECTOR_PUBLIC_KEY_FILE}" ]]; then
  CONNECTOR_PUBLIC_KEY="$(grep -v -- "-----" "$P14_CONNECTOR_PUBLIC_KEY_FILE" | tr -d '\n')"
fi

RENDERED="$DIR/.rendered"
mkdir -p "$RENDERED"

for rel in "$@"; do
  src="$DIR/$rel"
  [[ -f "$src" ]] || { echo "not found: $rel" >&2; exit 1; }
  out="$RENDERED/${rel//\//_}"
  sed \
    -e "s|<your-verified-email>|${P14_ALERT_EMAIL:-<your-verified-email>}|g" \
    -e "s|<connector-public-key>|${CONNECTOR_PUBLIC_KEY}|g" \
    "$src" > "$out"

  if grep -v '^[[:space:]]*--' "$out" | grep -Eo '<[a-z][a-z-]*>' | sort -u | grep . ; then
    echo "Unfilled placeholders in $rel (see above). Set them in p14.env." >&2
    exit 1
  fi

  echo "==> $rel"
  snow sql -c "$SNOW_CONNECTION" -f "$out"
done
