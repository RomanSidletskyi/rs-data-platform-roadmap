-- P09 service users for automation: key-pair only, no password, no interactive login. Run as ACCOUNTADMIN.
-- run_sql.sh fills <ci-public-key> and <pipeline-public-key> from the .pub files named in p09.env.

USE ROLE ACCOUNTADMIN;

-- Pull request builds: may create and drop CI_ schemas, cannot load data or touch production schemas it does not own.
CREATE USER IF NOT EXISTS P09_CI_SVC
  TYPE = SERVICE
  DEFAULT_ROLE = P09_TRANSFORMER
  DEFAULT_WAREHOUSE = P09_WH
  COMMENT = 'GitHub Actions: dbt build on pull requests';
ALTER USER P09_CI_SVC SET RSA_PUBLIC_KEY = '<ci-public-key>';
GRANT ROLE P09_TRANSFORMER TO USER P09_CI_SVC;

-- Scheduled pipeline: loads files as P09_OWNER, then runs dbt as P09_TRANSFORMER.
CREATE USER IF NOT EXISTS P09_PIPELINE_SVC
  TYPE = SERVICE
  DEFAULT_ROLE = P09_OWNER
  DEFAULT_WAREHOUSE = P09_WH
  COMMENT = 'GitHub Actions: scheduled extract, load, dbt build';
ALTER USER P09_PIPELINE_SVC SET RSA_PUBLIC_KEY = '<pipeline-public-key>';
GRANT ROLE P09_OWNER TO USER P09_PIPELINE_SVC;
GRANT ROLE P09_TRANSFORMER TO USER P09_PIPELINE_SVC;

DESC USER P09_CI_SVC;
