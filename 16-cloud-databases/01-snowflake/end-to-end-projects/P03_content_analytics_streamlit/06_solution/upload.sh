#!/usr/bin/env bash
# Upload pageview files or the Streamlit app to their internal stages.
# Usage: ./upload.sh data | ./upload.sh app
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p03.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p03.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p03.env}"

put() {
  snow sql -c "$SNOW_CONNECTION" -q "USE ROLE $1; PUT '$2' $3 $4"
}

case "${1:-}" in
  data)
    : "${P03_DATA_DIR:?set P03_DATA_DIR in p03.env}"
    root="$(cd "$P03_DATA_DIR/pageviews" && pwd)"
    for folder in "$root"/kind=*/project=*; do
      rel="${folder#"$root"/}"
      echo "==> $rel"
      # OVERWRITE only matters for re-downloaded days; COPY load metadata decides what is new.
      put P03_OWNER "file://$folder/*.json" "@P03_CONTENT.RAW.PAGEVIEWS_STAGE/$rel/" "AUTO_COMPRESS = TRUE OVERWRITE = TRUE"
    done
    ;;
  app)
    # App files must stay uncompressed: Snowflake runs them directly from the stage.
    for file in streamlit_app.py environment.yml; do
      put P03_APP_OWNER "file://$DIR/app/$file" "@P03_CONTENT.APP.APP_STAGE" "AUTO_COMPRESS = FALSE OVERWRITE = TRUE"
    done
    ;;
  *)
    echo "usage: $0 data|app" >&2
    exit 1
    ;;
esac
