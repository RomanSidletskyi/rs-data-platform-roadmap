#!/usr/bin/env bash
# Package ingest/ and deploy it to the Flex Consumption app with a remote build, then trigger one run.
# Usage: set -a; source ../p11.env; set +a; ./02_deploy_function.sh
set -euo pipefail

: "${P11_RG:?set P11_RG}"
: "${P11_FUNCTION_APP:?set P11_FUNCTION_APP}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INGEST="$DIR/../ingest"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# The package root holds function_app.py, host.json, requirements.txt, and the markets_ingest package.
( cd "$INGEST" && zip -q -r "$TMP/function.zip" function_app.py host.json requirements.txt markets_ingest -x '*/__pycache__/*' )
az functionapp deployment source config-zip --name "$P11_FUNCTION_APP" --resource-group "$P11_RG" \
  --src "$TMP/function.zip" --build-remote true --output none
echo "Deployed. Functions:"
az functionapp function list --name "$P11_FUNCTION_APP" --resource-group "$P11_RG" --query "[].name" --output tsv

# A timer function has no URL; the admin endpoint runs it once now. The master key is read, used, and not printed.
MASTER_KEY="$(az functionapp keys list --name "$P11_FUNCTION_APP" --resource-group "$P11_RG" --query masterKey --output tsv)"
curl -sS -X POST -H "x-functions-key: $MASTER_KEY" -H "Content-Type: application/json" -d '{}' \
  "https://$P11_FUNCTION_APP.azurewebsites.net/admin/functions/fetch_global_markets" -o /dev/null -w "trigger HTTP %{http_code}\n"
echo "The first run downloads several WFP files and takes a few minutes; watch it in Application Insights or the portal."
