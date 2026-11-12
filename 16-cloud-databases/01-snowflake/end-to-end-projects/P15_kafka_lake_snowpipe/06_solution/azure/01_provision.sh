#!/usr/bin/env bash
# Provision P15 lake storage, queue, and Event Grid subscription on Azure.
# Usage: P15_RG=rg-p15-lake P15_LOCATION=westeurope P15_STORAGE_ACCOUNT=<unique> ./01_provision.sh
set -euo pipefail

: "${P15_RG:?set P15_RG, for example rg-p15-lake}"
: "${P15_LOCATION:?set P15_LOCATION to the region of your Snowflake account}"
: "${P15_STORAGE_ACCOUNT:?set P15_STORAGE_ACCOUNT: 3-24 lowercase letters and digits, globally unique}"
P15_CONTAINER="${P15_CONTAINER:-landing}"
P15_QUEUE="${P15_QUEUE:-snowpipe-p15}"

az provider register --namespace Microsoft.EventGrid --wait
az group create --name "$P15_RG" --location "$P15_LOCATION" --tags project=p15 --output none

az storage account create \
  --name "$P15_STORAGE_ACCOUNT" \
  --resource-group "$P15_RG" \
  --location "$P15_LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --enable-hierarchical-namespace true \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false \
  --tags project=p15 \
  --output none

STORAGE_ID="$(az storage account show --name "$P15_STORAGE_ACCOUNT" --resource-group "$P15_RG" --query id --output tsv)"

az storage container-rm create --storage-account "$P15_STORAGE_ACCOUNT" --resource-group "$P15_RG" \
  --name "$P15_CONTAINER" --public-access off --output none

# Data-plane call; key auth avoids waiting for a fresh role assignment to propagate.
az storage queue create --name "$P15_QUEUE" --account-name "$P15_STORAGE_ACCOUNT" --auth-mode key --output none

ME="$(az ad signed-in-user show --query id --output tsv)"
az role assignment create --assignee-object-id "$ME" --assignee-principal-type User \
  --role "Storage Blob Data Contributor" --scope "$STORAGE_ID" --output none

az eventgrid event-subscription create \
  --name p15-lake-blob-created \
  --source-resource-id "$STORAGE_ID" \
  --endpoint-type storagequeue \
  --endpoint "$STORAGE_ID/queueservices/default/queues/$P15_QUEUE" \
  --included-event-types Microsoft.Storage.BlobCreated \
  --subject-begins-with "/blobServices/default/containers/$P15_CONTAINER/blobs/kafka/" \
  --output none

TENANT_ID="$(az account show --query tenantId --output tsv)"
cat <<EOF
Provisioned. Put into p15.env:
  AZURE_TENANT_ID=$TENANT_ID
Lake writer:
  --sink azure --azure-account-url https://$P15_STORAGE_ACCOUNT.blob.core.windows.net
Your Blob Data Contributor role can take a few minutes to become effective.
EOF
