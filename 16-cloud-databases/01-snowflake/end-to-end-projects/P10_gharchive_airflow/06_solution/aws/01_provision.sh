#!/usr/bin/env bash
# Provision P10 storage on AWS: one bucket with landing/ (Airflow writes, Snowflake reads) and archive/
# (Snowflake writes Parquet), lifecycle rules, the IAM role Snowflake assumes, and an IAM user for Airflow.
# Usage: set -a; source ../p10.env; set +a; ./01_provision.sh
# Remove later: aws s3 rb "s3://$P10_BUCKET" --force; delete role p10-snowflake-storage and user p10-airflow-landing.
set -euo pipefail

: "${P10_BUCKET:?set P10_BUCKET to a globally unique bucket name}"
: "${P10_REGION:?set P10_REGION to the region of your Snowflake account, for example eu-west-1}"
ROLE_NAME="p10-snowflake-storage"
AIRFLOW_USER="p10-airflow-landing"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

if [[ "$P10_REGION" == "us-east-1" ]]; then
  aws s3api create-bucket --bucket "$P10_BUCKET" --region "$P10_REGION" >/dev/null
else
  aws s3api create-bucket --bucket "$P10_BUCKET" --region "$P10_REGION" \
    --create-bucket-configuration LocationConstraint="$P10_REGION" >/dev/null
fi
aws s3api put-public-access-block --bucket "$P10_BUCKET" \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
aws s3api put-bucket-tagging --bucket "$P10_BUCKET" --tagging 'TagSet=[{Key=project,Value=p10}]'
aws s3api put-bucket-lifecycle-configuration --bucket "$P10_BUCKET" --lifecycle-configuration "file://$DIR/lifecycle.json"

# Placeholder trust (own account, dummy external id); 02_connect_snowflake.sh replaces it.
sed -e "s|<snowflake-iam-user-arn>|arn:aws:iam::$ACCOUNT_ID:root|" -e "s|<external-id>|0000|" \
  "$DIR/iam_trust_policy.json" > "$TMP/trust.json"
sed -e "s|<bucket>|$P10_BUCKET|g" "$DIR/iam_snowflake_policy.json" > "$TMP/snowflake.json"
sed -e "s|<bucket>|$P10_BUCKET|g" "$DIR/iam_airflow_policy.json" > "$TMP/airflow.json"

aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document "file://$TMP/trust.json" \
  --tags Key=project,Value=p10 >/dev/null
aws iam put-role-policy --role-name "$ROLE_NAME" --policy-name p10-landing-read-archive-write \
  --policy-document "file://$TMP/snowflake.json"

# Long-lived keys are acceptable for a local lab only; hosted Airflow (MWAA, EKS) uses an execution role.
aws iam create-user --user-name "$AIRFLOW_USER" --tags Key=project,Value=p10 >/dev/null
aws iam put-user-policy --user-name "$AIRFLOW_USER" --policy-name p10-landing-write \
  --policy-document "file://$TMP/airflow.json"
read -r KEY_ID KEY_SECRET < <(aws iam create-access-key --user-name "$AIRFLOW_USER" \
  --query "AccessKey.[AccessKeyId, SecretAccessKey]" --output text)

cat <<EOF
Provisioned. Put into ../p10.env (the secret is shown once; p10.env is ignored by Git):
  P10_AWS_ACCOUNT_ID=$ACCOUNT_ID
  P10_AIRFLOW_AWS_ACCESS_KEY_ID=$KEY_ID
  P10_AIRFLOW_AWS_SECRET_ACCESS_KEY=$KEY_SECRET
  P10_LANDING=aws
Then: ../run_sql.sh aws/10_integration.sql and ./02_connect_snowflake.sh <STORAGE_AWS_IAM_USER_ARN> <STORAGE_AWS_EXTERNAL_ID>
EOF
