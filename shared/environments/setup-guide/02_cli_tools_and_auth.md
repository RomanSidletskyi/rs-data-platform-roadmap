# 2. CLI Tools and Authentication

Every cloud and platform used in this repository has a command-line tool. Install only the ones your current module needs.

## Principles

- **Log in interactively; avoid long-lived keys.** Browser or SSO logins issue short-lived tokens. Static access keys are the most common way personal cloud accounts get abused.
- **Key-pair, not password, for Snowflake automation.** Scripts and CLIs use a private key file; your password stays for the web UI with MFA.
- **Know where credentials live,** and how to log out (table at the end).
- **One profile or connection per project** when possible (`p04`, `p14`), so a script never runs against the wrong account.

## Azure CLI

```bash
brew install azure-cli
az login                                # opens a browser
az account list -o table
az account set --subscription "<subscription name or id>"
```

- **Verify:** `az account show --query "{name:name, tenant:tenantId, user:user.name}"`
- **Used by:** P04, P08, P12, `09-azure-data-lake-storage`, Bicep deployments (`az bicep install`).
- **Python code** uses the same login through `DefaultAzureCredential`; no keys in code.

## AWS CLI

```bash
brew install awscli
aws configure sso                       # recommended: IAM Identity Center user, profile name e.g. p04
aws sso login --profile p04
export AWS_PROFILE=p04
```

If you have not set up IAM Identity Center yet: sign in to the console as root once, enable IAM Identity Center, create an admin user for yourself, and never create access keys for the root user.

- **Verify:** `aws sts get-caller-identity`
- **Used by:** AWS variants of the end-to-end projects.

## Google Cloud CLI

```bash
brew install --cask google-cloud-sdk
gcloud init                             # pick or create a project
gcloud auth application-default login   # credentials for client libraries
```

- **Verify:** `gcloud config list` and `bq ls` (BigQuery).
- **Used by:** BigQuery comparisons in `04_alternative_stacks.md` sections.

## Snowflake CLI

Install and create a key pair:

```bash
brew install pipx && pipx ensurepath
pipx install snowflake-cli
snow --version

mkdir -p ~/.snowflake/keys && chmod 700 ~/.snowflake ~/.snowflake/keys
cd ~/.snowflake/keys
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out snowflake_rsa_key.p8 -nocrypt
openssl rsa -in snowflake_rsa_key.p8 -pubout -out snowflake_rsa_key.pub
chmod 600 snowflake_rsa_key.p8
grep -v "PUBLIC KEY" snowflake_rsa_key.pub | tr -d '\n'; echo   # copy this single line
```

Register the public key on your user (Snowsight worksheet, as yourself):

```sql
ALTER USER <your_user> SET RSA_PUBLIC_KEY = '<the single line you copied>';
DESC USER <your_user>;   -- RSA_PUBLIC_KEY_FP is now set
```

Create a connection in `~/.snowflake/config.toml`:

```toml
[connections.p04]
account = "<orgname>-<account_name>"
user = "<your_user>"
authenticator = "SNOWFLAKE_JWT"
private_key_file = "~/.snowflake/keys/snowflake_rsa_key.p8"
role = "ACCOUNTADMIN"
warehouse = "COMPUTE_WH"
```

```bash
chmod 600 ~/.snowflake/config.toml
snow connection test -c p04
snow sql -c p04 -q "SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_REGION()"
snow sql -c p04 -f path/to/script.sql
```

- **Account identifier:** Snowsight, account menu (bottom left), "View account details".
- **Why key-pair:** human password logins require MFA, which does not suit scripts. The key file never leaves your machine; rotate by setting `RSA_PUBLIC_KEY_2`, switching, then unsetting the old key.
- **Learning shortcut:** the key above is unencrypted for simplicity. For anything beyond a personal trial, generate it with a passphrase and set `PRIVATE_KEY_PASSPHRASE` in your shell session only.
- **Used by:** every Snowflake project; the project quickstarts run all SQL through `snow sql -f`.

## Databricks CLI

```bash
brew tap databricks/tap
brew install databricks
databricks auth login --host https://<your-workspace-host>
```

- **Verify:** `databricks current-user me`
- **Used by:** `07-databricks`, P12. Works with Databricks Free Edition workspaces.

## Confluent CLI and kcat

```bash
brew install confluentinc/tap/cli
confluent login --save
confluent environment list
```

`kcat` (installed with the workstation utilities) works with any Kafka, local or cloud:

```bash
kcat -b localhost:9092 -L                      # list brokers and topics
echo '{"hello":"kafka"}' | kcat -b localhost:9092 -t demo -P
kcat -b localhost:9092 -t demo -C -o beginning -e
```

- **Used by:** `05-confluent-kafka`, P14, P15.

## dbt

```bash
cd <dbt project folder>
python3.12 -m venv .venv && source .venv/bin/activate
pip install dbt-core dbt-snowflake          # or dbt-postgres, dbt-duckdb for local practice
dbt --version
```

Snowflake profile in `~/.dbt/profiles.yml` using the same key pair:

```yaml
my_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <orgname>-<account_name>
      user: <your_user>
      private_key_path: ~/.snowflake/keys/snowflake_rsa_key.p8
      role: <project_owner_role>
      warehouse: <project_warehouse>
      database: <project_database>
      schema: dbt_dev
      threads: 4
```

- **Verify:** `dbt debug` in the project folder.
- **Used by:** `12-dbt`, P09, P16.

## GitHub CLI

```bash
brew install gh
gh auth login                                 # GitHub.com, SSH, browser
gh repo view
brew install act                              # optional: run GitHub Actions workflows locally in Docker
```

- **Verify:** `gh auth status`
- **Used by:** `04-github-actions`, CI for end-to-end projects.

## Infrastructure as Code (Optional)

```bash
brew tap hashicorp/tap && brew install hashicorp/tap/terraform
az bicep install
```

Terraform has providers for Azure, AWS, Google Cloud, Snowflake, Databricks, and Confluent. Introduce it after you have built a project by hand once; you then know what the code should create.

## Where Credentials Live and How to Log Out

| Tool | Stored in | Log out |
| --- | --- | --- |
| Azure CLI | `~/.azure/` | `az logout` |
| AWS CLI (SSO) | `~/.aws/config`, `~/.aws/sso/cache/` | `aws sso logout` |
| gcloud | `~/.config/gcloud/` | `gcloud auth revoke --all` |
| Snowflake CLI | `~/.snowflake/config.toml`, key files | Remove the connection; `ALTER USER ... UNSET RSA_PUBLIC_KEY` |
| Databricks CLI | `~/.databrickscfg`, token cache | `databricks auth logout` or delete the profile |
| Confluent CLI | `~/.confluent/` | `confluent logout` |
| dbt | `~/.dbt/profiles.yml` | Remove the profile |
| GitHub CLI | macOS keychain | `gh auth logout` |

None of these locations are inside the repository. Keep it that way.
