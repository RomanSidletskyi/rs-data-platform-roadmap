-- P04 Azure integrations. Run as ACCOUNTADMIN after azure/01_provision.sh.
-- Replace <tenant-id> and <storage-account> with the values printed by the provisioning script.

USE ROLE ACCOUNTADMIN;

CREATE STORAGE INTEGRATION IF NOT EXISTS P04_AZURE_STORAGE_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant-id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://<storage-account>.blob.core.windows.net/landing/');

CREATE NOTIFICATION INTEGRATION IF NOT EXISTS P04_AZURE_QUEUE_INT
  ENABLED = TRUE
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://<storage-account>.queue.core.windows.net/snowpipe-p04'
  AZURE_TENANT_ID = '<tenant-id>';

-- From each result: open AZURE_CONSENT_URL and accept, copy AZURE_MULTI_TENANT_APP_NAME.
-- Then run: azure/02_grant_snowflake_access.sh <storage app name> <queue app name>
DESC INTEGRATION P04_AZURE_STORAGE_INT;
DESC INTEGRATION P04_AZURE_QUEUE_INT;

GRANT USAGE ON INTEGRATION P04_AZURE_STORAGE_INT TO ROLE P04_OWNER;
GRANT USAGE ON INTEGRATION P04_AZURE_QUEUE_INT   TO ROLE P04_OWNER;
