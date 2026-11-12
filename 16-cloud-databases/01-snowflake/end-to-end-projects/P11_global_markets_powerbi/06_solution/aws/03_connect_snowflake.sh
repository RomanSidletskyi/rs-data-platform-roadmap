#!/usr/bin/env bash
# Finalize the IAM trust with Snowflake's identity and send S3 events under landing/markets/ to the pipes' SQS queue.
# Usage: ./03_connect_snowflake.sh <STORAGE_AWS_IAM_USER_ARN> <STORAGE_AWS_EXTERNAL_ID> <notification_channel>
set -euo pipefail

: "${P11_BUCKET:?set P11_BUCKET}"
IAM_USER_ARN="${1:?usage: $0 <iam-user-arn> <external-id> <sqs-arn>}"
EXTERNAL_ID="${2:?usage: $0 <iam-user-arn> <external-id> <sqs-arn>}"
SQS_ARN="${3:?usage: $0 <iam-user-arn> <external-id> <sqs-arn>}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

sed -e "s|<snowflake-iam-user-arn>|$IAM_USER_ARN|" -e "s|<external-id>|$EXTERNAL_ID|" \
  "$DIR/iam_trust_snowflake.json" > "$TMP/trust.json"
aws iam update-assume-role-policy --role-name p11-snowflake-landing-read --policy-document "file://$TMP/trust.json"

EXISTING="$(aws s3api get-bucket-notification-configuration --bucket "$P11_BUCKET")"
if [[ -n "$EXISTING" && "$EXISTING" != "{}" ]]; then
  echo "Bucket already has a notification configuration; merge by hand, because this call would replace it:" >&2
  echo "$EXISTING" >&2
  exit 1
fi
cat > "$TMP/notification.json" <<EOF
{"QueueConfigurations": [{"QueueArn": "$SQS_ARN", "Events": ["s3:ObjectCreated:*"],
  "Filter": {"Key": {"FilterRules": [{"Name": "prefix", "Value": "landing/markets/"}]}}}]}
EOF
aws s3api put-bucket-notification-configuration --bucket "$P11_BUCKET" --notification-configuration "file://$TMP/notification.json"

echo "Connected. Then in Snowflake: ALTER PIPE ... REFRESH for files that landed before the pipes existed."
