-- P08 AWS variant: storage integration. Run as ACCOUNTADMIN via run_sql.sh.
-- Provision the bucket and role with the P04 scripts, overriding names:
--   P04_BUCKET=<p08 bucket> P04_REGION=<region> P04_ROLE_NAME=p08-snowflake-landing-read \
--     ../../P04_wikimedia_snowpipe_realtime_dwh/06_solution/aws/01_provision.sh
-- After 11_stage_and_pipes.sql, connect with the same overrides:
--   P04_BUCKET=<p08 bucket> P04_ROLE_NAME=p08-snowflake-landing-read \
--     ../../P04_wikimedia_snowpipe_realtime_dwh/06_solution/aws/02_connect_snowflake.sh <iam user arn> <external id> <notification_channel>

USE ROLE ACCOUNTADMIN;

CREATE STORAGE INTEGRATION IF NOT EXISTS P08_AWS_STORAGE_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<aws-account-id>:role/p08-snowflake-landing-read'
  STORAGE_ALLOWED_LOCATIONS = ('s3://<bucket>/landing/bsky/');

DESC INTEGRATION P08_AWS_STORAGE_INT;
GRANT USAGE ON INTEGRATION P08_AWS_STORAGE_INT TO ROLE P08_OWNER;
