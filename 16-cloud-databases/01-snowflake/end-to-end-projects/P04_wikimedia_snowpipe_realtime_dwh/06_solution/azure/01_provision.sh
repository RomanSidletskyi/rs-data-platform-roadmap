#!/usr/bin/env bash
# Provision P04 landing storage, queue, and Event Grid subscription on Azure.
# Usage: P04_RG=rg-p04-wiki P04_LOCATION=westeurope P04_STORAGE_ACCOUNT=<unique> ./01_provision.sh
set -euo pipefail

: "${P04_RG:?set P04_RG, for example rg-p04-wiki}"
: "${P04_LOCATION:?set P04_LOCATION to the region of your Snowflake account, for example westeurope}"
: "${P04_STORAGE_ACCOUNT:?set P04_STORAGE_ACCOUNT: 3-24 lowercase letters and digits, globally unique}"
P04_CONTAINER="${P04_CONTAINER:-landing}"
P04_QUEUE="${P04_QUEUE:-snowpipe-p04}"

az provider register --namespace Microsoft.EventGrid --wait

az group create --name "$P04_RG" --location "$P04_LOCATION" --tags project=p04 --output none

az storage account create \
  --name "$P04_STORAGE_ACCOUNT" \
  --resource-group "$P04_RG" \
  --location "$P04_LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --enable-hierarchical-namespace true \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false \
  --tags project=p04 \
  --output none

STORAGE_ID="$(az storage account show --name "$P04_STORAGE_ACCOUNT" --resource-group "$P04_RG" --query id --output tsv)"

az storage container-rm create \
  --storage-account "$P04_STORAGE_ACCOUNT" \
  --resource-group "$P04_RG" \
  --name "$P04_CONTAINER" \
  --public-access off \
  --output none

# Data-plane call; key auth avoids waiting for a fresh role assignment to propagate.
az storage queue create --name "$P04_QUEUE" --account-name "$P04_STORAGE_ACCOUNT" --auth-mode key --output none

ME="$(az ad signed-in-user show --query id --output tsv)"
az role assignment create \
  --assignee-object-id "$ME" \
  --assignee-principal-type User \
  --role "Storage Blob Data Contributor" \
  --scope "$STORAGE_ID" \
  --output none

az eventgrid event-subscription create \
  --name p04-landing-blob-created \
  --source-resource-id "$STORAGE_ID" \
  --endpoint-type storagequeue \
  --endpoint "$STORAGE_ID/queueservices/default/queues/$P04_QUEUE" \
  --included-event-types Microsoft.Storage.BlobCreated \
  --subject-begins-with "/blobServices/default/containers/$P04_CONTAINER/" \
  --output none

TENANT_ID="$(az account show --query tenantId --output tsv)"

cat <<EOF
Provisioned. Put these values into azure/10_integrations.sql and azure/11_stage_and_pipes.sql:
  <tenant-id>        $TENANT_ID
  stage URL          azure://$P04_STORAGE_ACCOUNT.blob.core.windows.net/$P04_CONTAINER/
  queue URI          https://$P04_STORAGE_ACCOUNT.queue.core.windows.net/$P04_QUEUE
Producer:
  export P04_AZURE_ACCOUNT_URL=https://$P04_STORAGE_ACCOUNT.blob.core.windows.net
Your Blob Data Contributor role can take a few minutes to become effective.
EOF
