#!/usr/bin/env bash
# Finalize the IAM trust with Snowflake's identity from DESC INTEGRATION P10_AWS_STORAGE_INT.
# Usage: ./02_connect_snowflake.sh <STORAGE_AWS_IAM_USER_ARN> <STORAGE_AWS_EXTERNAL_ID>
set -euo pipefail

IAM_USER_ARN="${1:?usage: $0 <iam-user-arn> <external-id>}"
EXTERNAL_ID="${2:?usage: $0 <iam-user-arn> <external-id>}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

sed -e "s|<snowflake-iam-user-arn>|$IAM_USER_ARN|" -e "s|<external-id>|$EXTERNAL_ID|" \
  "$DIR/iam_trust_policy.json" > "$TMP/trust.json"
aws iam update-assume-role-policy --role-name p10-snowflake-storage --policy-document "file://$TMP/trust.json"

echo "Connected. IAM changes can take a minute; then run: ../run_sql.sh aws/11_stages.sql"
