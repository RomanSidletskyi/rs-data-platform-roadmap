#!/usr/bin/env bash
# Run SQL files with the Snowflake CLI using the connection from p06.env.
# Usage: ./run_sql.sh core/00_account_setup.sql [more files ...]
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p06.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p06.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p06.env}"
[[ $# -gt 0 ]] || { echo "usage: $0 <file.sql> [more.sql ...]" >&2; exit 1; }

for rel in "$@"; do
  [[ -f "$DIR/$rel" ]] || { echo "not found: $rel" >&2; exit 1; }
  echo "==> $rel"
  snow sql -c "$SNOW_CONNECTION" -f "$DIR/$rel"
done
