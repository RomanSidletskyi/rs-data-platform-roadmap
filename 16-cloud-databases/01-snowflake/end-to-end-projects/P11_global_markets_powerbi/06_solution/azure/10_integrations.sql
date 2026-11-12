-- P11 Azure integrations. Run as ACCOUNTADMIN after azure/01_provision.sh. Placeholders come from p11.env.

USE ROLE ACCOUNTADMIN;

CREATE STORAGE INTEGRATION IF NOT EXISTS P11_AZURE_STORAGE_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant-id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://<storage-account>.blob.core.windows.net/landing/markets/');

-- One queue for all three pipes: each pipe picks its files by path.
CREATE NOTIFICATION INTEGRATION IF NOT EXISTS P11_AZURE_QUEUE_INT
  ENABLED = TRUE
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://<storage-account>.queue.core.windows.net/snowpipe-p11'
  AZURE_TENANT_ID = '<tenant-id>';

-- From each result: open AZURE_CONSENT_URL and accept, copy AZURE_MULTI_TENANT_APP_NAME,
-- then run azure/03_grant_snowflake_access.sh <storage app name> <queue app name>.
DESC INTEGRATION P11_AZURE_STORAGE_INT;
DESC INTEGRATION P11_AZURE_QUEUE_INT;

GRANT USAGE ON INTEGRATION P11_AZURE_STORAGE_INT TO ROLE P11_OWNER;
GRANT USAGE ON INTEGRATION P11_AZURE_QUEUE_INT TO ROLE P11_OWNER;
