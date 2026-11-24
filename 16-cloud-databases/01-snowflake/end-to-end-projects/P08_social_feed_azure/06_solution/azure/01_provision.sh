#!/usr/bin/env bash
# Provision P08 landing storage, one queue, one Event Grid subscription, and a lifecycle policy on Azure.
# Usage: set values in ../p08.env, then: set -a; source ../p08.env; set +a; ./01_provision.sh
set -euo pipefail

: "${P08_RG:?set P08_RG}"
: "${P08_LOCATION:?set P08_LOCATION to the region of your Snowflake account}"
: "${P08_STORAGE_ACCOUNT:?set P08_STORAGE_ACCOUNT: 3-24 lowercase letters and digits, globally unique}"
P08_CONTAINER="${P08_CONTAINER:-landing}"
P08_QUEUE="${P08_QUEUE:-snowpipe-p08}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

az provider register --namespace Microsoft.EventGrid --wait
az group create --name "$P08_RG" --location "$P08_LOCATION" --tags project=p08 --output none

az storage account create \
  --name "$P08_STORAGE_ACCOUNT" --resource-group "$P08_RG" --location "$P08_LOCATION" \
  --sku Standard_LRS --kind StorageV2 --enable-hierarchical-namespace true \
  --min-tls-version TLS1_2 --allow-blob-public-access false --tags project=p08 --output none

STORAGE_ID="$(az storage account show --name "$P08_STORAGE_ACCOUNT" --resource-group "$P08_RG" --query id --output tsv)"

az storage container-rm create --storage-account "$P08_STORAGE_ACCOUNT" --resource-group "$P08_RG" \
  --name "$P08_CONTAINER" --public-access off --output none

az storage queue create --name "$P08_QUEUE" --account-name "$P08_STORAGE_ACCOUNT" --auth-mode key --output none

ME="$(az ad signed-in-user show --query id --output tsv)"
az role assignment create --assignee-object-id "$ME" --assignee-principal-type User \
  --role "Storage Blob Data Contributor" --scope "$STORAGE_ID" --output none

# One subscription and one queue for all collections: each pipe picks its files by path.
az eventgrid event-subscription create \
  --name p08-bsky-blob-created \
  --source-resource-id "$STORAGE_ID" \
  --endpoint-type storagequeue \
  --endpoint "$STORAGE_ID/queueservices/default/queues/$P08_QUEUE" \
  --included-event-types Microsoft.Storage.BlobCreated \
  --subject-begins-with "/blobServices/default/containers/$P08_CONTAINER/blobs/bsky/" \
  --output none

# At volume the lake grows fast: cool after 7 days, delete after 30.
az storage account management-policy create \
  --account-name "$P08_STORAGE_ACCOUNT" --resource-group "$P08_RG" \
  --policy "@$DIR/lifecycle_policy.json" --output none

TENANT_ID="$(az account show --query tenantId --output tsv)"
cat <<EOF
Provisioned. Put into ../p08.env:
  AZURE_TENANT_ID=$TENANT_ID
  P08_AZURE_ACCOUNT_URL=https://$P08_STORAGE_ACCOUNT.blob.core.windows.net
Your Blob Data Contributor role can take a few minutes to become effective.
EOF
