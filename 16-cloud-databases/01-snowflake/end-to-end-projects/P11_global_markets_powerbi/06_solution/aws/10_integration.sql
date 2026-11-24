-- P11 AWS storage integration. Run as ACCOUNTADMIN after aws/01_provision.sh. Placeholders come from p11.env.

USE ROLE ACCOUNTADMIN;

CREATE STORAGE INTEGRATION IF NOT EXISTS P11_AWS_STORAGE_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<aws-account-id>:role/p11-snowflake-landing-read'
  STORAGE_ALLOWED_LOCATIONS = ('s3://<bucket>/landing/markets/');

-- Copy STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID; aws/03_connect_snowflake.sh needs them after aws/11.
DESC INTEGRATION P11_AWS_STORAGE_INT;

GRANT USAGE ON INTEGRATION P11_AWS_STORAGE_INT TO ROLE P11_OWNER;
