#!/usr/bin/env bash
# One local pipeline run: extract, upload, load, dbt build, source freshness. The scheduled workflow does the same.
# Usage: ./run_pipeline.sh
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -a
# shellcheck source=/dev/null
source "$DIR/p09.env"
set +a

python "$DIR/extract/extract_markets.py" --out "$P09_DATA_DIR" --days "${P09_LOOKBACK_DAYS:-3}"
"$DIR/upload.sh"
"$DIR/run_sql.sh" core/20_load.sql

cd "$DIR/dbt/p09_markets"
dbt deps
dbt build --target prod
dbt source freshness --target prod
