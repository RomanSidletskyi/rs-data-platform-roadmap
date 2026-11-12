#!/usr/bin/env bash
# Provision P10 storage on Azure: one account, a landing container (Airflow writes, Snowflake reads)
# and an archive container (Snowflake writes Parquet), lifecycle rules, and a service principal for Airflow.
# Usage: set -a; source ../p10.env; set +a; ./01_provision.sh
set -euo pipefail

: "${P10_RG:?set P10_RG}"
: "${P10_LOCATION:?set P10_LOCATION to the region of your Snowflake account}"
: "${P10_STORAGE_ACCOUNT:?set P10_STORAGE_ACCOUNT: 3-24 lowercase letters and digits, globally unique}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

az group create --name "$P10_RG" --location "$P10_LOCATION" --tags project=p10 --output none

az storage account create \
  --name "$P10_STORAGE_ACCOUNT" --resource-group "$P10_RG" --location "$P10_LOCATION" \
  --sku Standard_LRS --kind StorageV2 --access-tier Hot \
  --min-tls-version TLS1_2 --allow-blob-public-access false --allow-shared-key-access false \
  --tags project=p10 --output none

STORAGE_ID="$(az storage account show --name "$P10_STORAGE_ACCOUNT" --resource-group "$P10_RG" --query id --output tsv)"
for container in landing archive; do
  az storage container-rm create --storage-account "$P10_STORAGE_ACCOUNT" --resource-group "$P10_RG" \
    --name "$container" --public-access off --output none
done

# Landing is a short buffer (GH Archive keeps the originals); the archive moves to cheaper online tiers.
az storage account management-policy create \
  --account-name "$P10_STORAGE_ACCOUNT" --resource-group "$P10_RG" \
  --policy "@$DIR/lifecycle_policy.json" --output none

# You read the archive while learning; Airflow and Snowflake get narrower roles below and in 02.
ME="$(az ad signed-in-user show --query id --output tsv)"
az role assignment create --assignee-object-id "$ME" --assignee-principal-type User \
  --role "Storage Blob Data Contributor" --scope "$STORAGE_ID" --output none

# Airflow writes only into the landing container. A secret is acceptable for a local lab;
# a hosted Airflow would use a managed identity or workload identity instead.
LANDING_SCOPE="$STORAGE_ID/blobServices/default/containers/landing"
read -r SP_APP_ID SP_SECRET < <(az ad sp create-for-rbac --name "p10-airflow-landing-$P10_STORAGE_ACCOUNT" \
  --role "Storage Blob Data Contributor" --scopes "$LANDING_SCOPE" --years 1 \
  --query "[appId, password]" --output tsv | tr '\n' ' ')

TENANT_ID="$(az account show --query tenantId --output tsv)"
cat <<EOF
Provisioned. Put into ../p10.env (the secret is shown once; p10.env is ignored by Git):
  AZURE_TENANT_ID=$TENANT_ID
  P10_AIRFLOW_SP_APP_ID=$SP_APP_ID
  P10_AIRFLOW_SP_SECRET=$SP_SECRET
  P10_LANDING=azure
Role assignments can take a few minutes to become effective.
EOF
