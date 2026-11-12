#!/usr/bin/env bash
# Upload year folders from prepare_batches.py to the internal stage.
# Usage: ./upload_batch.sh 2019 2020 [--overwrite]
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p01.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p01.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p01.env}"
: "${P01_DATA_DIR:?set P01_DATA_DIR in p01.env}"

OVERWRITE=FALSE
YEARS=()
for arg in "$@"; do
  if [[ "$arg" == "--overwrite" ]]; then OVERWRITE=TRUE; else YEARS+=("$arg"); fi
done
[[ ${#YEARS[@]} -gt 0 ]] || { echo "usage: $0 <year> [year ...] [--overwrite]" >&2; exit 1; }

for year in "${YEARS[@]}"; do
  src="$P01_DATA_DIR/batches/year=$year"
  [[ -d "$src" ]] || { echo "missing $src; run prepare/prepare_batches.py" >&2; exit 1; }
  src="$(cd "$src" && pwd)"
  echo "==> year=$year ($(find "$src" -name '*.json' | wc -l | tr -d ' ') files)"
  # PUT compresses locally; COPY later skips files whose name and checksum it has already loaded.
  snow sql -c "$SNOW_CONNECTION" -q "USE ROLE P01_OWNER; PUT 'file://$src/*.json' @P01_CRICKET.RAW.MATCH_STAGE/year=$year/ AUTO_COMPRESS = TRUE PARALLEL = 8 OVERWRITE = $OVERWRITE"
done
