#!/usr/bin/env bash
# Zip the retail_pipeline package and upload it to the code stage. Then run core/30_procedure.sql.
# Usage: ./package.sh
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p07.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p07.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p07.env}"

mkdir -p "$DIR/dist"
rm -f "$DIR/dist/retail_pipeline.zip"
( cd "$DIR" && zip -q -r dist/retail_pipeline.zip retail_pipeline -x '*/__pycache__/*' )
echo "built dist/retail_pipeline.zip"

# Code is uploaded uncompressed and overwritten: the procedure imports exactly this file.
snow sql -c "$SNOW_CONNECTION" -q "USE ROLE P07_OWNER; PUT 'file://$DIR/dist/retail_pipeline.zip' @P07_RETAIL.OPS.CODE_STAGE AUTO_COMPRESS = FALSE OVERWRITE = TRUE"
