# Google Cloud and BigQuery Sandbox

## What You Get

| Option | Card | What it is | Use in this repository |
| --- | --- | --- | --- |
| **BigQuery sandbox** | No | BigQuery with limits on storage, monthly query volume, and table expiration; no other paid services | Compare SQL, pricing model, and serverless behavior with Snowflake |
| **Free trial** | Yes | Credits for new customers for a limited period, all services | Pub/Sub plus BigQuery subscription design in `04_alternative_stacks.md` |

Start with the sandbox. Open the trial only if you need Pub/Sub or Dataflow.

## BigQuery Sandbox

1. Sign in with a Google account at the Google Cloud console and open **BigQuery**.
2. When prompted, create a **project** (for example `rs-learning-bq`). No billing account is attached; the console shows a "sandbox" banner.
3. In the Explorer, **Add data**, **Public datasets**: browse free public data (for example `bigquery-public-data`).
4. Run a first query:

   ```sql
   SELECT name, SUM(number) AS total
   FROM `bigquery-public-data.usa_names.usa_1910_2013`
   GROUP BY name
   ORDER BY total DESC
   LIMIT 10;
   ```

5. Before running a query, look at the **bytes processed** estimate in the editor. In BigQuery, cost follows bytes scanned; this is the main contrast with Snowflake warehouses.

Sandbox tables expire automatically after a default period. Keep scripts, not data.

## Free Trial (Optional)

1. In the console, **Activate** the free trial; enter country, card, and accept terms. A billing account is created.
2. **Billing**, **Budgets and alerts**, **Create budget**: scope your project, small amount, alerts at 50, 90, 100 percent.
3. Install and log in with the CLI ([Google Cloud CLI](../02_cli_tools_and_auth.md#google-cloud-cli)):

   ```bash
   gcloud init
   gcloud config set project <project-id>
   gcloud auth application-default login
   ```

4. Enable only the APIs a lab needs, for example:

   ```bash
   gcloud services enable pubsub.googleapis.com bigquery.googleapis.com
   ```

The trial does not charge the card when credits end unless you upgrade to a paid account.

## Verify

```bash
gcloud config list
bq ls
bq query --use_legacy_sql=false 'SELECT 1 AS ok'
```

## Cleanup

```bash
gcloud projects delete <project-id>
```

Deleting a project removes all its resources after a short recovery window.

## Common Problems

| Problem | Fix |
| --- | --- |
| `Billing has not been enabled` in sandbox | The feature is not part of the sandbox; use the trial or skip it |
| Query unexpectedly expensive (trial) | Use `--dry_run` with `bq query` to see bytes before running; select only needed columns |
| Table disappeared | Sandbox expiration; recreate from your script |
