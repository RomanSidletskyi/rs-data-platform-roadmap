#!/usr/bin/env bash
# Provision P11 on AWS: a bucket with landing/markets/, the IAM role Snowflake assumes (read only),
# and the Lambda execution role (write landing/markets/ only).
# Usage: set -a; source ../p11.env; set +a; ./01_provision.sh
# Remove later: aws s3 rb "s3://$P11_BUCKET" --force; delete the Lambda, the schedule, and roles p11-*.
set -euo pipefail

: "${P11_BUCKET:?set P11_BUCKET to a globally unique bucket name}"
: "${P11_REGION:?set P11_REGION to the region of your Snowflake account}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

if [[ "$P11_REGION" == "us-east-1" ]]; then
  aws s3api create-bucket --bucket "$P11_BUCKET" --region "$P11_REGION" >/dev/null
else
  aws s3api create-bucket --bucket "$P11_BUCKET" --region "$P11_REGION" \
    --create-bucket-configuration LocationConstraint="$P11_REGION" >/dev/null
fi
aws s3api put-public-access-block --bucket "$P11_BUCKET" \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
aws s3api put-bucket-tagging --bucket "$P11_BUCKET" --tagging 'TagSet=[{Key=project,Value=p11}]'

# Snowflake role: placeholder trust (own account, dummy external id); 03_connect_snowflake.sh replaces it.
sed -e "s|<snowflake-iam-user-arn>|arn:aws:iam::$ACCOUNT_ID:root|" -e "s|<external-id>|0000|" \
  "$DIR/iam_trust_snowflake.json" > "$TMP/trust_snowflake.json"
sed -e "s|<bucket>|$P11_BUCKET|g" "$DIR/iam_snowflake_read.json" > "$TMP/snowflake_read.json"
aws iam create-role --role-name p11-snowflake-landing-read \
  --assume-role-policy-document "file://$TMP/trust_snowflake.json" --tags Key=project,Value=p11 >/dev/null
aws iam put-role-policy --role-name p11-snowflake-landing-read --policy-name p11-landing-read \
  --policy-document "file://$TMP/snowflake_read.json"

# Lambda execution role: write new objects under landing/markets/, write its own logs.
sed -e "s|<bucket>|$P11_BUCKET|g" "$DIR/iam_lambda_write.json" > "$TMP/lambda_write.json"
aws iam create-role --role-name p11-ingest-lambda \
  --assume-role-policy-document "file://$DIR/iam_trust_lambda.json" --tags Key=project,Value=p11 >/dev/null
aws iam put-role-policy --role-name p11-ingest-lambda --policy-name p11-landing-write \
  --policy-document "file://$TMP/lambda_write.json"
aws iam attach-role-policy --role-name p11-ingest-lambda \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

cat <<EOF
Provisioned. Put into ../p11.env:
  P11_AWS_ACCOUNT_ID=$ACCOUNT_ID
Next: ./02_deploy_lambda.sh (IAM roles can take a few seconds to become usable by Lambda).
EOF
