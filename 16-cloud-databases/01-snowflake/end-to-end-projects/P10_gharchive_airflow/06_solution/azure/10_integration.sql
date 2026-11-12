-- P10 Azure storage integration. Run as ACCOUNTADMIN after azure/01_provision.sh. Placeholders come from p10.env.

USE ROLE ACCOUNTADMIN;

-- One integration, two containers. What Snowflake may do in each is decided by the Azure roles in 02.
CREATE STORAGE INTEGRATION IF NOT EXISTS P10_AZURE_STORAGE_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant-id>'
  STORAGE_ALLOWED_LOCATIONS = (
    'azure://<storage-account>.blob.core.windows.net/landing/',
    'azure://<storage-account>.blob.core.windows.net/archive/'
  );

-- Open AZURE_CONSENT_URL and accept, then run azure/02_grant_snowflake_access.sh <AZURE_MULTI_TENANT_APP_NAME>.
DESC INTEGRATION P10_AZURE_STORAGE_INT;

GRANT USAGE ON INTEGRATION P10_AZURE_STORAGE_INT TO ROLE P10_OWNER;
