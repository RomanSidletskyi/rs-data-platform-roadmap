#!/usr/bin/env bash
# Zip the markets_pipeline package and upload it to the code stage. Then run core/30_procedure_and_task.sql.
# Usage: ./package.sh
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p11.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p11.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p11.env}"

mkdir -p "$DIR/dist"
rm -f "$DIR/dist/markets_pipeline.zip"
( cd "$DIR" && zip -q -r dist/markets_pipeline.zip markets_pipeline -x '*/__pycache__/*' )
echo "built dist/markets_pipeline.zip"

# Uploaded uncompressed and overwritten: the procedure imports exactly this file.
snow sql -c "$SNOW_CONNECTION" -q "USE ROLE P11_OWNER; PUT 'file://$DIR/dist/markets_pipeline.zip' @P11_MARKETS.OPS.CODE_STAGE AUTO_COMPRESS = FALSE OVERWRITE = TRUE"
