#!/usr/bin/env bash
# Internal-stage mode: PUT every landed file under $P11_DATA_DIR/markets to @RAW.LANDING_STAGE, keeping the path.
# Usage: ./upload.sh, then ./run_sql.sh core/20_load_internal.sql
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p11.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p11.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p11.env}"
: "${P11_DATA_DIR:?set P11_DATA_DIR in p11.env}"

root="$(cd "$P11_DATA_DIR/markets" && pwd)"
# One PUT per folder: the path carries country, version, and indicator, which the RAW views parse.
while IFS= read -r folder; do
  rel="${folder#"$root"/}"
  # No OVERWRITE: names are versioned, so an existing file is the same file.
  snow sql -c "$SNOW_CONNECTION" -q "USE ROLE P11_OWNER; PUT 'file://$folder/*' @P11_MARKETS.RAW.LANDING_STAGE/$rel/"
done < <(find "$root" -type f ! -name '*.part' -exec dirname {} \; | sort -u)
