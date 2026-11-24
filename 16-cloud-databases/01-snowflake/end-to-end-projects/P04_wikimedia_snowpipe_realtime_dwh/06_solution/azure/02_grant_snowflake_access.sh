#!/usr/bin/env bash
# Grant Snowflake's service principals access after consenting to both integrations.
# Usage: ./02_grant_snowflake_access.sh <storage AZURE_MULTI_TENANT_APP_NAME> <queue AZURE_MULTI_TENANT_APP_NAME>
set -euo pipefail

: "${P04_RG:?set P04_RG}"
: "${P04_STORAGE_ACCOUNT:?set P04_STORAGE_ACCOUNT}"
P04_QUEUE="${P04_QUEUE:-snowpipe-p04}"
STORAGE_APP_NAME="${1:?usage: $0 <storage-integration-app-name> <queue-integration-app-name>}"
QUEUE_APP_NAME="${2:?usage: $0 <storage-integration-app-name> <queue-integration-app-name>}"

sp_object_id() {
  # The service principal display name is the app name up to the first underscore.
  local display_name="${1%%_*}"
  local object_id
  object_id="$(az ad sp list --display-name "$display_name" --query "[0].id" --output tsv)"
  if [[ -z "$object_id" ]]; then
    echo "Service principal '$display_name' not found. Open AZURE_CONSENT_URL from DESC INTEGRATION and accept first." >&2
    exit 1
  fi
  printf '%s' "$object_id"
}

STORAGE_ID="$(az storage account show --name "$P04_STORAGE_ACCOUNT" --resource-group "$P04_RG" --query id --output tsv)"
STORAGE_SP="$(sp_object_id "$STORAGE_APP_NAME")"
QUEUE_SP="$(sp_object_id "$QUEUE_APP_NAME")"

az role assignment create \
  --assignee-object-id "$STORAGE_SP" \
  --assignee-principal-type ServicePrincipal \
  --role "Storage Blob Data Reader" \
  --scope "$STORAGE_ID" \
  --output none

az role assignment create \
  --assignee-object-id "$QUEUE_SP" \
  --assignee-principal-type ServicePrincipal \
  --role "Storage Queue Data Contributor" \
  --scope "$STORAGE_ID/queueServices/default/queues/$P04_QUEUE" \
  --output none

echo "Granted. Wait a few minutes for propagation, then run LIST @RAW.LANDING_STAGE in Snowflake."
