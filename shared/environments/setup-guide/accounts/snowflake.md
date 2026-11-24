# Snowflake Trial Account

## What You Get

- A time-limited trial (typically 30 days) with free usage credits, no card required.
- A full account: Snowsight UI, warehouses, Snowpipe, tasks, dynamic tables, Snowpark, Streamlit in Snowflake, Cortex where available in the region.
- One cloud and region chosen at sign-up; it cannot be changed for that account.

## Before You Start

Decide two things, because both are fixed at sign-up:

| Choice | Recommendation | Why |
| --- | --- | --- |
| Edition | **Enterprise** | Covers everything in this repository (multi-cluster warehouses, longer Time Travel, masking and row access policies). Standard is enough for P04 alone |
| Cloud and region | **Microsoft Azure**, a region near you, for example West Europe | The end-to-end projects use Azure as the primary cloud; storage must be in the same region to avoid egress cost |

If you plan to do the AWS variants instead, choose AWS and the matching region. You can open a second trial later with a different email if needed for comparison.

## Create the Account

1. Open the Snowflake sign-up page ("Start for free" on snowflake.com).
2. Fill in name, email, company (your name or "Personal learning" is fine), role, and country.
3. Choose the **edition**, **cloud provider**, and **region** decided above.
4. Confirm. Snowflake sends an activation email; open it and click the activation link.
5. Choose a **username** and **password**. Store them in your password manager.
6. Snowsight opens. Bookmark the account URL (`https://<orgname>-<account_name>.snowflakecomputing.com`).

## Day One: Secure the Account

### 1. Multi-factor authentication

Snowsight prompts for MFA enrollment for password users. If not prompted: user menu (bottom left), **Profile**, **Multi-factor authentication**, enroll an authenticator or passkey.

### 2. Stop using ACCOUNTADMIN by default

```sql
USE ROLE ACCOUNTADMIN;
ALTER USER <your_user> SET DEFAULT_ROLE = SYSADMIN;
```

Switch to `ACCOUNTADMIN` only for account-level work (integrations, resource monitors, grants on account).

### 3. Account-wide cost guardrails

```sql
USE ROLE ACCOUNTADMIN;

-- Default warehouse: smallest size, short suspend.
ALTER WAREHOUSE COMPUTE_WH SET WAREHOUSE_SIZE = XSMALL AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;

-- Safety net for all warehouses in the account (project monitors come on top).
CREATE RESOURCE MONITOR IF NOT EXISTS ACCOUNT_SAFETY_RM
  WITH CREDIT_QUOTA = 25
  FREQUENCY = WEEKLY
  START_TIMESTAMP = IMMEDIATELY
  TRIGGERS
    ON 75 PERCENT DO NOTIFY
    ON 100 PERCENT DO SUSPEND
    ON 110 PERCENT DO SUSPEND_IMMEDIATE;
ALTER ACCOUNT SET RESOURCE_MONITOR = ACCOUNT_SAFETY_RM;

-- No query runs longer than one hour unless a warehouse overrides it.
ALTER ACCOUNT SET STATEMENT_TIMEOUT_IN_SECONDS = 3600;
```

Adjust `CREDIT_QUOTA` to your trial balance divided by the weeks you plan to use it. Resource monitors do not cover serverless features (Snowpipe, serverless tasks); see [cost guardrails](../../../../16-cloud-databases/01-snowflake/end-to-end-projects/_shared/cost_guardrails.md).

### 4. Notification email

Resource monitor notifications and alert emails go to verified emails. User menu, **Profile**: confirm your email shows as verified; resend verification if not.

### 5. Note the account details

User menu (bottom left), your account, **View account details**. Copy into your private account register:

- Account identifier: `<orgname>-<account_name>` (used by CLIs and connectors)
- Account locator and region (useful for support and docs)
- Account URL

## Configure for This Repository

1. **Key-pair access for the Snowflake CLI, dbt, and Python:** follow [Snowflake CLI](../02_cli_tools_and_auth.md#snowflake-cli).
2. **One connection per project** in `~/.snowflake/config.toml` (`[connections.p04]`, `[connections.p14]`).
3. **Projects create their own roles, warehouses, and monitors** with their `core/00_account_setup.sql`; do not build project objects in `COMPUTE_WH` or with `ACCOUNTADMIN`.
4. **Optional: Snowflake extension for VS Code** (`snowflake.snowflake-vsc`) using the same connection, to run SQL files from the editor.

## Verify

```bash
snow connection test -c p04
snow sql -c p04 -q "SELECT CURRENT_ACCOUNT(), CURRENT_REGION(), CURRENT_ROLE(), CURRENT_WAREHOUSE()"
```

```sql
SHOW RESOURCE MONITORS;          -- ACCOUNT_SAFETY_RM exists
SHOW PARAMETERS LIKE 'STATEMENT_TIMEOUT_IN_SECONDS' IN ACCOUNT;
SHOW WAREHOUSES;                 -- COMPUTE_WH is XSMALL, auto_suspend 60
```

## Daily Habits

- Check remaining trial credits: Snowsight, **Admin**, **Cost management** (or **Billing**). Write the number into your project log.
- End every lab with the project's pause script.
- Before leaving for more than a day: `SHOW TASKS IN ACCOUNT;`, `SHOW DYNAMIC TABLES IN ACCOUNT;`, `SHOW PIPES IN ACCOUNT;` and confirm nothing is running that should not be.

## When the Trial Ends

The account is suspended unless a payment method is added. Before the end date:

1. Export measured results and screenshots into the repository (`assets/`, `PROGRESS.md`).
2. Record a short demo video.
3. Run each project's `teardown.sql` to leave a clean state if you might convert the account later.

## Common Problems

| Problem | Fix |
| --- | --- |
| Activation email not received | Check spam; the link expires, so request a new one from the sign-up page |
| `Incorrect username or password` from the CLI | The CLI uses key-pair; check `RSA_PUBLIC_KEY_FP` in `DESC USER` and the `private_key_file` path |
| Feature not available in region | Some features (for example certain Cortex models) are region-specific; check the feature's documentation page |
| Resource monitor did not stop spend | It only stops warehouses; pause pipes, serverless tasks, and alerts yourself |
