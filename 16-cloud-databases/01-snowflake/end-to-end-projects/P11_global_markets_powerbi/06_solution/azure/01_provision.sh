#!/usr/bin/env bash
# Provision P11 on Azure: a data storage account with a landing container, one queue with one Event Grid
# subscription for Snowpipe, and a Flex Consumption function app whose managed identity writes to landing.
# Usage: set -a; source ../p11.env; set +a; ./01_provision.sh
set -euo pipefail

: "${P11_RG:?set P11_RG}"
: "${P11_LOCATION:?set P11_LOCATION to the region of your Snowflake account (Flex Consumption must exist there)}"
: "${P11_STORAGE_ACCOUNT:?set P11_STORAGE_ACCOUNT: 3-24 lowercase letters and digits, globally unique}"
: "${P11_FUNCTION_APP:?set P11_FUNCTION_APP: globally unique, letters, digits, hyphens}"
P11_QUEUE="${P11_QUEUE:-snowpipe-p11}"
P11_COUNTRIES="${P11_COUNTRIES:-KEN,NGA,ETH,BGD,IND,TUR}"
HOST_STORAGE="${P11_STORAGE_ACCOUNT}fn"
[[ ${#HOST_STORAGE} -le 24 ]] || { echo "P11_STORAGE_ACCOUNT must be at most 22 characters (the host account adds 'fn')." >&2; exit 1; }

az provider register --namespace Microsoft.EventGrid --wait
az group create --name "$P11_RG" --location "$P11_LOCATION" --tags project=p11 --output none

az storage account create --name "$P11_STORAGE_ACCOUNT" --resource-group "$P11_RG" --location "$P11_LOCATION" \
  --sku Standard_LRS --kind StorageV2 --min-tls-version TLS1_2 --allow-blob-public-access false \
  --tags project=p11 --output none
DATA_ID="$(az storage account show --name "$P11_STORAGE_ACCOUNT" --resource-group "$P11_RG" --query id --output tsv)"
az storage container-rm create --storage-account "$P11_STORAGE_ACCOUNT" --resource-group "$P11_RG" \
  --name landing --public-access off --output none
az storage queue create --name "$P11_QUEUE" --account-name "$P11_STORAGE_ACCOUNT" --auth-mode key --output none

az eventgrid event-subscription create \
  --name p11-markets-blob-created \
  --source-resource-id "$DATA_ID" \
  --endpoint-type storagequeue \
  --endpoint "$DATA_ID/queueservices/default/queues/$P11_QUEUE" \
  --included-event-types Microsoft.Storage.BlobCreated \
  --subject-begins-with "/blobServices/default/containers/landing/blobs/markets/" \
  --output none

# The function runtime keeps its own state in a separate account, away from the data.
az storage account create --name "$HOST_STORAGE" --resource-group "$P11_RG" --location "$P11_LOCATION" \
  --sku Standard_LRS --allow-blob-public-access false --tags project=p11 --output none

az functionapp create --resource-group "$P11_RG" --name "$P11_FUNCTION_APP" --storage-account "$HOST_STORAGE" \
  --flexconsumption-location "$P11_LOCATION" --runtime python --runtime-version 3.11 --tags project=p11 --output none

# The managed identity may write blobs in landing, nothing else. No keys or connection strings in settings.
PRINCIPAL_ID="$(az functionapp identity assign --name "$P11_FUNCTION_APP" --resource-group "$P11_RG" --query principalId --output tsv)"
az role assignment create --assignee-object-id "$PRINCIPAL_ID" --assignee-principal-type ServicePrincipal \
  --role "Storage Blob Data Contributor" --scope "$DATA_ID/blobServices/default/containers/landing" --output none

az functionapp config appsettings set --name "$P11_FUNCTION_APP" --resource-group "$P11_RG" --output none --settings \
  "P11_LANDING_ACCOUNT_URL=https://$P11_STORAGE_ACCOUNT.blob.core.windows.net" \
  "P11_LANDING_CONTAINER=landing" \
  "P11_COUNTRIES=$P11_COUNTRIES"

# You run the ingestion locally once too (python -m markets_ingest.run --target azure).
ME="$(az ad signed-in-user show --query id --output tsv)"
az role assignment create --assignee-object-id "$ME" --assignee-principal-type User \
  --role "Storage Blob Data Contributor" --scope "$DATA_ID" --output none

cat <<EOF
Provisioned. Put into ../p11.env:
  AZURE_TENANT_ID=$(az account show --query tenantId --output tsv)
Next: ./02_deploy_function.sh, then ../run_sql.sh azure/10_integrations.sql
Role assignments can take a few minutes to become effective.
EOF
