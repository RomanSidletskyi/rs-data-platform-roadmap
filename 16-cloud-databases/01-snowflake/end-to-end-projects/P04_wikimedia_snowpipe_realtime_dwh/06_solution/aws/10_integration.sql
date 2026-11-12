-- P04 AWS storage integration. Run as ACCOUNTADMIN after aws/01_provision.sh.
-- Replace <aws-account-id> and <bucket>.

USE ROLE ACCOUNTADMIN;

CREATE STORAGE INTEGRATION IF NOT EXISTS P04_AWS_STORAGE_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<aws-account-id>:role/p04-snowflake-landing-read'
  STORAGE_ALLOWED_LOCATIONS = ('s3://<bucket>/landing/');

-- Copy STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID for aws/02_connect_snowflake.sh.
DESC INTEGRATION P04_AWS_STORAGE_INT;

GRANT USAGE ON INTEGRATION P04_AWS_STORAGE_INT TO ROLE P04_OWNER;
