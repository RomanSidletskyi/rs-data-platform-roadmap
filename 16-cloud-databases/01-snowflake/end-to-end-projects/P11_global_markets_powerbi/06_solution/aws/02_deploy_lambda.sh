#!/usr/bin/env bash
# Package markets_ingest with the Lambda handler, create or update the function, schedule it daily, run it once.
# Usage: set -a; source ../p11.env; set +a; ./02_deploy_lambda.sh
# Pause: aws scheduler update-schedule --name p11-ingest-daily --state DISABLED ... (same arguments as below)
set -euo pipefail

: "${P11_BUCKET:?set P11_BUCKET}"
: "${P11_REGION:?set P11_REGION}"
: "${P11_AWS_ACCOUNT_ID:?set P11_AWS_ACCOUNT_ID}"
P11_COUNTRIES="${P11_COUNTRIES:-KEN,NGA,ETH,BGD,IND,TUR}"
FUNCTION=p11-ingest
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Standard library plus boto3 from the runtime: the package is just our code.
( cd "$DIR/../ingest" && zip -q -r "$TMP/lambda.zip" lambda_handler.py markets_ingest -x '*/__pycache__/*' )

ROLE_ARN="arn:aws:iam::$P11_AWS_ACCOUNT_ID:role/p11-ingest-lambda"
ENVIRONMENT="Variables={P11_BUCKET=$P11_BUCKET,P11_PREFIX=landing/,P11_COUNTRIES=$P11_COUNTRIES}"

if aws lambda get-function --function-name "$FUNCTION" --region "$P11_REGION" >/dev/null 2>&1; then
  aws lambda update-function-code --function-name "$FUNCTION" --zip-file "fileb://$TMP/lambda.zip" --region "$P11_REGION" >/dev/null
  aws lambda wait function-updated-v2 --function-name "$FUNCTION" --region "$P11_REGION"
  aws lambda update-function-configuration --function-name "$FUNCTION" --environment "$ENVIRONMENT" --region "$P11_REGION" >/dev/null
  aws lambda wait function-updated-v2 --function-name "$FUNCTION" --region "$P11_REGION"
else
  # Downloads of the larger WFP files take minutes: use the maximum timeout, modest memory.
  aws lambda create-function --function-name "$FUNCTION" --runtime python3.12 --handler lambda_handler.handler \
    --role "$ROLE_ARN" --zip-file "fileb://$TMP/lambda.zip" --timeout 900 --memory-size 512 \
    --environment "$ENVIRONMENT" --tags project=p11 --region "$P11_REGION" >/dev/null
  aws lambda wait function-active-v2 --function-name "$FUNCTION" --region "$P11_REGION"
fi

# EventBridge Scheduler needs its own role that may invoke exactly this function.
FUNCTION_ARN="arn:aws:lambda:$P11_REGION:$P11_AWS_ACCOUNT_ID:function:$FUNCTION"
if ! aws iam get-role --role-name p11-scheduler-invoke >/dev/null 2>&1; then
  aws iam create-role --role-name p11-scheduler-invoke \
    --assume-role-policy-document "file://$DIR/iam_trust_scheduler.json" --tags Key=project,Value=p11 >/dev/null
  aws iam put-role-policy --role-name p11-scheduler-invoke --policy-name p11-invoke-ingest \
    --policy-document "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"lambda:InvokeFunction\",\"Resource\":\"$FUNCTION_ARN\"}]}"
  sleep 10
fi
SCHEDULE_ARGS=(--name p11-ingest-daily --schedule-expression "cron(0 6 * * ? *)" --schedule-expression-timezone UTC
  --flexible-time-window Mode=OFF --region "$P11_REGION"
  --target "Arn=$FUNCTION_ARN,RoleArn=arn:aws:iam::$P11_AWS_ACCOUNT_ID:role/p11-scheduler-invoke")
aws scheduler create-schedule "${SCHEDULE_ARGS[@]}" >/dev/null 2>&1 || aws scheduler update-schedule "${SCHEDULE_ARGS[@]}" >/dev/null

# One run now; the response body is the summary of landed and unchanged files.
aws lambda invoke --function-name "$FUNCTION" --invocation-type RequestResponse --cli-read-timeout 900 \
  --region "$P11_REGION" "$TMP/response.json" >/dev/null
cat "$TMP/response.json"; echo
