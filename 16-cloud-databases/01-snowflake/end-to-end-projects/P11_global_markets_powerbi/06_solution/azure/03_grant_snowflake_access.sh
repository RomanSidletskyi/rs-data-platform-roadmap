#!/usr/bin/env bash
# Grant Snowflake's service principals access after consenting to both integrations.
# Usage: ./03_grant_snowflake_access.sh <storage AZURE_MULTI_TENANT_APP_NAME> <queue AZURE_MULTI_TENANT_APP_NAME>
set -euo pipefail

: "${P11_RG:?set P11_RG}"
: "${P11_STORAGE_ACCOUNT:?set P11_STORAGE_ACCOUNT}"
P11_QUEUE="${P11_QUEUE:-snowpipe-p11}"
STORAGE_APP_NAME="${1:?usage: $0 <storage-integration-app-name> <queue-integration-app-name>}"
QUEUE_APP_NAME="${2:?usage: $0 <storage-integration-app-name> <queue-integration-app-name>}"

sp_object_id() {
  # The service principal display name is the app name up to the first underscore.
  local object_id
  object_id="$(az ad sp list --display-name "${1%%_*}" --query "[0].id" --output tsv)"
  [[ -n "$object_id" ]] || { echo "Service principal for '$1' not found. Open AZURE_CONSENT_URL first." >&2; exit 1; }
  printf '%s' "$object_id"
}

DATA_ID="$(az storage account show --name "$P11_STORAGE_ACCOUNT" --resource-group "$P11_RG" --query id --output tsv)"

az role assignment create --assignee-object-id "$(sp_object_id "$STORAGE_APP_NAME")" \
  --assignee-principal-type ServicePrincipal --role "Storage Blob Data Reader" \
  --scope "$DATA_ID/blobServices/default/containers/landing" --output none

az role assignment create --assignee-object-id "$(sp_object_id "$QUEUE_APP_NAME")" \
  --assignee-principal-type ServicePrincipal --role "Storage Queue Data Contributor" \
  --scope "$DATA_ID/queueServices/default/queues/$P11_QUEUE" --output none

echo "Granted. Wait a few minutes, then run: ../run_sql.sh azure/11_stage_and_pipes.sql"
