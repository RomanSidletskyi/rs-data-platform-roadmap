#!/usr/bin/env bash
# Simulate N business days, optionally waiting between them so the task graph can catch up.
# Usage: ./simulate.sh [days=1] [pause_seconds=0]
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/p05.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p05.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a
: "${SNOW_CONNECTION:?set SNOW_CONNECTION in p05.env}"

days="${1:-1}"
pause="${2:-0}"
for ((i = 1; i <= days; i++)); do
  snow sql -c "$SNOW_CONNECTION" -q "USE ROLE P05_OWNER; USE WAREHOUSE P05_WH; CALL P05_CDC.OPS.SIMULATE_DAY()"
  if ((i < days)); then sleep "$pause"; fi
done
