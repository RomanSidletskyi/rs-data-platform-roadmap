#!/usr/bin/env bash
# Finalize the IAM trust with Snowflake's identity and route S3 events to the pipe's SQS queue.
# Usage: ./02_connect_snowflake.sh <STORAGE_AWS_IAM_USER_ARN> <STORAGE_AWS_EXTERNAL_ID> <notification_channel>
set -euo pipefail

: "${P04_BUCKET:?set P04_BUCKET}"
ROLE_NAME="${P04_ROLE_NAME:-p04-snowflake-landing-read}"
IAM_USER_ARN="${1:?usage: $0 <iam-user-arn> <external-id> <sqs-arn>}"
EXTERNAL_ID="${2:?usage: $0 <iam-user-arn> <external-id> <sqs-arn>}"
SQS_ARN="${3:?usage: $0 <iam-user-arn> <external-id> <sqs-arn>}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

sed -e "s|<snowflake-iam-user-arn>|$IAM_USER_ARN|" -e "s|<external-id>|$EXTERNAL_ID|" \
  "$DIR/iam_trust_policy.json" > "$TMP/trust.json"
aws iam update-assume-role-policy --role-name "$ROLE_NAME" --policy-document "file://$TMP/trust.json"

EXISTING="$(aws s3api get-bucket-notification-configuration --bucket "$P04_BUCKET")"
if [[ -n "$EXISTING" && "$EXISTING" != "{}" ]]; then
  echo "Bucket already has a notification configuration; merge by hand, because this call would replace it:" >&2
  echo "$EXISTING" >&2
  exit 1
fi

sed -e "s|<sqs-arn>|$SQS_ARN|" "$DIR/s3_notification.json" > "$TMP/notification.json"
aws s3api put-bucket-notification-configuration --bucket "$P04_BUCKET" \
  --notification-configuration "file://$TMP/notification.json"

echo "Connected. IAM changes can take a minute; then run LIST @RAW.LANDING_STAGE in Snowflake."
