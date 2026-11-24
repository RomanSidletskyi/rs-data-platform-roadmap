-- P10 AWS storage integration. Run as ACCOUNTADMIN after aws/01_provision.sh. Placeholders come from p10.env.

USE ROLE ACCOUNTADMIN;

CREATE STORAGE INTEGRATION IF NOT EXISTS P10_AWS_STORAGE_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<aws-account-id>:role/p10-snowflake-storage'
  STORAGE_ALLOWED_LOCATIONS = ('s3://<bucket>/landing/', 's3://<bucket>/archive/');

-- Copy STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID into aws/02_connect_snowflake.sh.
DESC INTEGRATION P10_AWS_STORAGE_INT;

GRANT USAGE ON INTEGRATION P10_AWS_STORAGE_INT TO ROLE P10_OWNER;
