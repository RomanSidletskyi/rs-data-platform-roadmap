#!/usr/bin/env bash
# Upload extracted files to the internal stage.
# Usage: ./upload.sh [snow sql connection flags...]   (defaults to -c $SNOW_CONNECTION from p09.env)
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$DIR/p09.env" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "$DIR/p09.env"
  set +a
fi
: "${P09_DATA_DIR:?set P09_DATA_DIR}"
CONNECTION=("$@")
[[ ${#CONNECTION[@]} -gt 0 ]] || CONNECTION=(-c "${SNOW_CONNECTION:?set SNOW_CONNECTION}")

root="$(cd "$P09_DATA_DIR" && pwd)"
for folder in "$root"/coinbase/product=* "$root"/fred/series=*; do
  [[ -d "$folder" ]] || continue
  rel="${folder#"$root"/}"
  # OVERWRITE: a window re-fetched within the same hour has new candles; COPY reloads it because its checksum changed.
  snow sql "${CONNECTION[@]}" -q "USE ROLE P09_OWNER; PUT 'file://$folder/*' @P09_MARKETS.RAW.MARKET_STAGE/$rel/ OVERWRITE = TRUE"
done
