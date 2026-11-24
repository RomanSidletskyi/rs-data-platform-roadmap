#!/usr/bin/env bash
# Fill <placeholders> from p09.env and run SQL files with the Snowflake CLI.
# Usage: ./run_sql.sh core/00_account_setup.sql [more files ...]
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p09.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p09.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p09.env}"
[[ $# -gt 0 ]] || { echo "usage: $0 <file.sql> [more.sql ...]" >&2; exit 1; }

# Public key body without the PEM header and footer lines, as Snowflake expects it.
key_body() { [[ -n "${1:-}" && -f "$1" ]] && grep -v -- '-----' "$1" | tr -d '\n' || true; }
CI_KEY="$(key_body "${P09_CI_PUBLIC_KEY_FILE:-}")"
PIPELINE_KEY="$(key_body "${P09_PIPELINE_PUBLIC_KEY_FILE:-}")"

RENDERED="$DIR/.rendered"
mkdir -p "$RENDERED"

for rel in "$@"; do
  src="$DIR/$rel"
  [[ -f "$src" ]] || { echo "not found: $rel" >&2; exit 1; }
  out="$RENDERED/${rel//\//_}"
  sed \
    -e "s|<your-verified-email>|${P09_ALERT_EMAIL:-<your-verified-email>}|g" \
    -e "s|<ci-public-key>|${CI_KEY:-<ci-public-key>}|g" \
    -e "s|<pipeline-public-key>|${PIPELINE_KEY:-<pipeline-public-key>}|g" \
    "$src" > "$out"

  if grep -v '^[[:space:]]*--' "$out" | grep -Eo '<[a-z][a-z-]*>' | sort -u | grep . ; then
    echo "Unfilled placeholders in $rel (see above). Set them in p09.env." >&2
    exit 1
  fi

  echo "==> $rel"
  snow sql -c "$SNOW_CONNECTION" -f "$out"
done
