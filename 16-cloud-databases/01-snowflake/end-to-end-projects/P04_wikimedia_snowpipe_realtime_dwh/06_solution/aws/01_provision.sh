#!/usr/bin/env bash
# Provision P04 landing bucket and the IAM role Snowflake will assume (trust is finalized later).
# Usage: P04_BUCKET=<unique-bucket> P04_REGION=<region of your Snowflake account> ./01_provision.sh
set -euo pipefail

: "${P04_BUCKET:?set P04_BUCKET to a globally unique bucket name}"
: "${P04_REGION:?set P04_REGION to the region of your Snowflake account, for example eu-west-1}"
ROLE_NAME="${P04_ROLE_NAME:-p04-snowflake-landing-read}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

if [[ "$P04_REGION" == "us-east-1" ]]; then
  aws s3api create-bucket --bucket "$P04_BUCKET" --region "$P04_REGION" >/dev/null
else
  aws s3api create-bucket --bucket "$P04_BUCKET" --region "$P04_REGION" \
    --create-bucket-configuration LocationConstraint="$P04_REGION" >/dev/null
fi
aws s3api put-public-access-block --bucket "$P04_BUCKET" \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
aws s3api put-bucket-tagging --bucket "$P04_BUCKET" --tagging 'TagSet=[{Key=project,Value=p04}]'

# Placeholder trust (own account, dummy external id); 02_connect_snowflake.sh replaces it.
sed -e "s|<snowflake-iam-user-arn>|arn:aws:iam::$ACCOUNT_ID:root|" -e "s|<external-id>|0000|" \
  "$DIR/iam_trust_policy.json" > "$TMP/trust.json"
sed -e "s|<bucket>|$P04_BUCKET|g" "$DIR/iam_s3_read_policy.json" > "$TMP/read.json"

aws iam create-role --role-name "$ROLE_NAME" \
  --assume-role-policy-document "file://$TMP/trust.json" \
  --tags Key=project,Value=p04 >/dev/null
aws iam put-role-policy --role-name "$ROLE_NAME" \
  --policy-name p04-landing-read --policy-document "file://$TMP/read.json"

cat <<EOF
Provisioned. Put these values into aws/10_integration.sql and aws/11_stage_and_pipes.sql:
  role ARN    arn:aws:iam::$ACCOUNT_ID:role/$ROLE_NAME
  stage URL   s3://$P04_BUCKET/landing/
Producer:
  export P04_BUCKET=$P04_BUCKET   (use --sink s3; the producer writes under landing/)
EOF
