# Other Free Services

Short, complete setups for the smaller free services used across modules and demos.

## GitHub

**Use:** repository hosting, Actions CI (`04-github-actions`), Pages for a portfolio site, Codespaces.

1. Sign up at github.com; verify email.
2. **Settings**, **Password and authentication**: enable two-factor authentication (required for most accounts) and save recovery codes.
3. **Settings**, **SSH and GPG keys**: add your key ([workstation step 3](../01_workstation_macos.md#3-git-and-github-ssh-access)).
4. `gh auth login` ([GitHub CLI](../02_cli_tools_and_auth.md#github-cli)).
5. **Settings**, **Billing and plans**: note the included Actions minutes and Codespaces hours; set a spending limit of 0 for Actions and Codespaces so you are never billed.
6. Repository **Settings**, **Secrets and variables**, **Actions**: the only place CI secrets go.

**GitHub Pages portfolio:** repository **Settings**, **Pages**, source "GitHub Actions"; publish a static site (for example MkDocs Material) from the `docs` content.

## MongoDB Atlas (M0 Free Cluster)

**Use:** hosted MongoDB for `02-sql` NoSQL practice and small demos.

1. Sign up at mongodb.com/atlas; create an organization and a project (`learning`).
2. **Create cluster**: **M0** (free), cloud and region near you.
3. **Database Access**: add a database user with a generated password; role "Read and write to any database" for practice.
4. **Network Access**: add **your current IP only**. Never `0.0.0.0/0`.
5. **Connect**, **Drivers**: copy the connection string into an ignored env file.
6. Verify: `mongosh "<connection string>" --eval "db.runCommand({ping:1})"`.

## Neon (Serverless Postgres)

**Use:** a hosted Postgres for demos that must be reachable from a public app.

1. Sign up at neon.tech; create a project in a region near you.
2. Copy the connection string (pooled) into an ignored env file.
3. Create a **separate read-only role** for any public app.
4. Verify: `psql "<connection string>" -c "select version();"`.

Supabase offers a similar free Postgres with extra features (auth, storage); setup is equivalent.

## dbt Cloud (Developer Plan)

**Use:** browser IDE, job scheduler, and hosted docs for `12-dbt`.

1. Sign up at getdbt.com; choose the free **Developer** plan.
2. **Create project**, connection **Snowflake**: account `<orgname>-<account_name>`, database, warehouse, role.
3. Development credentials: user plus **key pair** (paste the private key; never reuse your personal Snowflake owner role, create a dbt role).
4. Repository: connect your GitHub repository or use the managed one.
5. Verify: **Test connection**, then run `dbt debug` and `dbt run` in the IDE.

dbt Core locally ([dbt](../02_cli_tools_and_auth.md#dbt)) remains the default in this repository; dbt Cloud is for comparing workflows.

## Deepnote

**Use:** hosted collaborative notebooks; P02 compares it with Snowflake Notebooks.

1. Sign up at deepnote.com; the free plan is enough for one person.
2. Create a dedicated Snowflake user or role for Deepnote with read access only (for P02: `P02_READER` and `USAGE` on `P02_WH`).
3. In a project: **Integrations**, **Snowflake**: account `<orgname>-<account_name>`, warehouse, database, role, and key-pair or password credentials. Credentials stay in the integration, not in notebook cells.
4. Upload the `.ipynb` file, or connect the GitHub repository.
5. Verify: a SQL block `SELECT CURRENT_ROLE(), CURRENT_WAREHOUSE()` returns the read-only role.

Deepnote keeps a hardware session running while the notebook is open; Snowflake bills the warehouse only while queries run plus the auto-suspend window.

## Streamlit Community Cloud

**Use:** free public hosting of a Streamlit app from a GitHub repository.

1. Sign in at share.streamlit.io with GitHub.
2. **Create app**: pick repository, branch, and the app file.
3. **Advanced settings**, **Secrets**: paste connection settings in TOML; they are not stored in the repository.
4. Point the app at **static exported data** or a small free database (Neon, Atlas), not at a paid Snowflake warehouse that would resume on every visit.

## Hugging Face Spaces

**Use:** free CPU hosting for a Streamlit or Gradio demo.

1. Sign up at huggingface.co; enable two-factor authentication.
2. **New Space**: SDK **Streamlit** or **Gradio**, hardware **CPU basic** (free), visibility as needed.
3. Push your app files to the Space's Git repository.
4. **Settings**, **Variables and secrets**: add secrets there only.

## Cloudflare Tunnel and Tailscale (Homelab Access)

**Use:** reach Raspberry Pi services (`15-raspberry-pi-homelab`) from outside without opening router ports.

- **Tailscale** (private access for you): sign up, install on the Pi and your Mac, log in on both; reach the Pi by its tailnet name.
- **Cloudflare Tunnel** (share with others): install `cloudflared` on the Pi; a quick tunnel (`cloudflared tunnel --url http://localhost:<port>`) gives a temporary public URL; a named tunnel with your own domain gives a stable one. Keep authentication on every exposed UI.
