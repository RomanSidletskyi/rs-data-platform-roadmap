-- P15 AWS storage integration. Run as ACCOUNTADMIN via run_sql.sh.
-- Provision bucket and role with the P04 AWS scripts, overriding names:
--   P04_BUCKET=<p15 bucket> P04_REGION=<region> P04_ROLE_NAME=p15-snowflake-lake-read ../../P04_wikimedia_snowpipe_realtime_dwh/06_solution/aws/01_provision.sh

USE ROLE ACCOUNTADMIN;

CREATE STORAGE INTEGRATION IF NOT EXISTS P15_AWS_STORAGE_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<aws-account-id>:role/p15-snowflake-lake-read'
  STORAGE_ALLOWED_LOCATIONS = ('s3://<bucket>/landing/kafka/');

DESC INTEGRATION P15_AWS_STORAGE_INT;
GRANT USAGE ON INTEGRATION P15_AWS_STORAGE_INT TO ROLE P15_OWNER;
