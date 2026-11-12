#!/usr/bin/env bash
# Upload one or more daily extracts to the internal stage.
# Usage: ./upload_day.sh 2025-03-03 [2025-03-04 ...]   or   ./upload_day.sh all
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p06.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p06.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p06.env}"
: "${P06_DATA_DIR:?set P06_DATA_DIR in p06.env}"
[[ $# -gt 0 ]] || { echo "usage: $0 YYYY-MM-DD [...] | all" >&2; exit 1; }

root="$(cd "$P06_DATA_DIR" && pwd)"
if [[ "$1" == "all" ]]; then
  days=()
  for folder in "$root"/day=*; do days+=("${folder##*/day=}"); done
else
  days=("$@")
fi

for day in "${days[@]}"; do
  folder="$root/day=$day"
  [[ -d "$folder" ]] || { echo "missing $folder; run the generator first" >&2; exit 1; }
  echo "==> day=$day"
  # No OVERWRITE: an extract is immutable once delivered; re-uploading the same day is a no-op.
  snow sql -c "$SNOW_CONNECTION" -q "USE ROLE P06_OWNER; PUT 'file://$folder/*.csv' @P06_FOOD.RAW.EXTRACT_STAGE/day=$day/ AUTO_COMPRESS = TRUE"
done
