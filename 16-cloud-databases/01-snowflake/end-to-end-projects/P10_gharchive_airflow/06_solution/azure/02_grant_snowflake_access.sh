#!/usr/bin/env bash
# Grant Snowflake's service principal access after consenting to the storage integration:
# read on landing, read-write-delete on archive (unload and REMOVE), nothing else.
# Usage: ./02_grant_snowflake_access.sh <AZURE_MULTI_TENANT_APP_NAME from DESC INTEGRATION>
set -euo pipefail

: "${P10_RG:?set P10_RG}"
: "${P10_STORAGE_ACCOUNT:?set P10_STORAGE_ACCOUNT}"
APP_NAME="${1:?usage: $0 <AZURE_MULTI_TENANT_APP_NAME>}"

# The service principal display name is the app name up to the first underscore.
SP_ID="$(az ad sp list --display-name "${APP_NAME%%_*}" --query "[0].id" --output tsv)"
[[ -n "$SP_ID" ]] || { echo "Service principal for '$APP_NAME' not found. Open AZURE_CONSENT_URL first." >&2; exit 1; }

STORAGE_ID="$(az storage account show --name "$P10_STORAGE_ACCOUNT" --resource-group "$P10_RG" --query id --output tsv)"

az role assignment create --assignee-object-id "$SP_ID" --assignee-principal-type ServicePrincipal \
  --role "Storage Blob Data Reader" --scope "$STORAGE_ID/blobServices/default/containers/landing" --output none
az role assignment create --assignee-object-id "$SP_ID" --assignee-principal-type ServicePrincipal \
  --role "Storage Blob Data Contributor" --scope "$STORAGE_ID/blobServices/default/containers/archive" --output none

echo "Granted. Wait a few minutes, then run: ../run_sql.sh azure/11_stages.sql"
