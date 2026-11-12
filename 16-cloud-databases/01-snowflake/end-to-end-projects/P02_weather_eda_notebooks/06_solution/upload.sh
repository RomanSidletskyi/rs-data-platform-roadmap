#!/usr/bin/env bash
# Upload weather files or the notebook to their internal stages.
# Usage: ./upload.sh data | ./upload.sh notebook
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p02.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p02.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p02.env}"

put() {
  snow sql -c "$SNOW_CONNECTION" -q "USE ROLE P02_OWNER; PUT '$1' $2 $3"
}

case "${1:-}" in
  data)
    : "${P02_DATA_DIR:?set P02_DATA_DIR in p02.env}"
    root="$(cd "$P02_DATA_DIR/weather" && pwd)"
    for folder in "$root"/city=*/year=*; do
      rel="${folder#"$root"/}"
      echo "==> $rel"
      put "file://$folder/*.json" "@P02_WEATHER.RAW.WEATHER_STAGE/$rel/" "AUTO_COMPRESS = TRUE OVERWRITE = TRUE"
    done
    ;;
  notebook)
    # Notebooks must stay uncompressed: Snowflake opens the .ipynb directly from the stage.
    put "file://$DIR/notebooks/weather_eda.ipynb" "@P02_WEATHER.ANALYSIS.NOTEBOOK_STAGE" "AUTO_COMPRESS = FALSE OVERWRITE = TRUE"
    ;;
  *)
    echo "usage: $0 data|notebook" >&2
    exit 1
    ;;
esac
