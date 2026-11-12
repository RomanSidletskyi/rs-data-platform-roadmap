#!/usr/bin/env bash
# Grant Snowflake's service principals access after consenting to both integrations.
# Usage: ./02_grant_snowflake_access.sh <storage AZURE_MULTI_TENANT_APP_NAME> <queue AZURE_MULTI_TENANT_APP_NAME>
set -euo pipefail

: "${P15_RG:?set P15_RG}"
: "${P15_STORAGE_ACCOUNT:?set P15_STORAGE_ACCOUNT}"
P15_QUEUE="${P15_QUEUE:-snowpipe-p15}"
STORAGE_APP_NAME="${1:?usage: $0 <storage-integration-app-name> <queue-integration-app-name>}"
QUEUE_APP_NAME="${2:?usage: $0 <storage-integration-app-name> <queue-integration-app-name>}"

sp_object_id() {
  local display_name="${1%%_*}"
  local object_id
  object_id="$(az ad sp list --display-name "$display_name" --query "[0].id" --output tsv)"
  [[ -n "$object_id" ]] || { echo "Service principal '$display_name' not found; accept the consent URL first." >&2; exit 1; }
  printf '%s' "$object_id"
}

STORAGE_ID="$(az storage account show --name "$P15_STORAGE_ACCOUNT" --resource-group "$P15_RG" --query id --output tsv)"

az role assignment create --assignee-object-id "$(sp_object_id "$STORAGE_APP_NAME")" \
  --assignee-principal-type ServicePrincipal --role "Storage Blob Data Reader" \
  --scope "$STORAGE_ID" --output none
az role assignment create --assignee-object-id "$(sp_object_id "$QUEUE_APP_NAME")" \
  --assignee-principal-type ServicePrincipal --role "Storage Queue Data Contributor" \
  --scope "$STORAGE_ID/queueServices/default/queues/$P15_QUEUE" --output none

echo "Granted. Wait a few minutes, then LIST @RAW.LAKE_STAGE in Snowflake."
