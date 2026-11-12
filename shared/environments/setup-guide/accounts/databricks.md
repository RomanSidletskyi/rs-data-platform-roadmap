# Databricks Free Edition (and Cloud Trials)

## What You Get

| Option | Card | What it is | Use in this repository |
| --- | --- | --- | --- |
| **Free Edition** | No | A personal, quota-limited serverless workspace with notebooks, SQL warehouse, Unity Catalog, jobs, and declarative pipelines; for learning and non-commercial use | `06-spark-pyspark`, `07-databricks`, `08-delta-lake`, P12 |
| **Cloud trial** (Azure Databricks or Databricks on AWS) | Cloud account | Full workspace in your cloud subscription, time-limited premium features; cloud infrastructure is billed to your cloud credits | Features that need your own storage, networking, or custom clusters |

Start with Free Edition. Use a cloud trial only for a specific lab, and delete it afterwards.

## Free Edition: Create the Account

1. Open the Databricks Free Edition sign-up page (databricks.com, "Free Edition").
2. Sign up with email, Google, or Microsoft. Verify the email if asked.
3. A workspace is created for you. Bookmark its URL (`https://<something>.cloud.databricks.com`).

## Free Edition: First Configuration

1. **Look around:** left sidebar: Workspace (notebooks), Catalog (Unity Catalog data), SQL Editor, Jobs and Pipelines, Compute.
2. **Create your own schema** for labs (Catalog, your workspace catalog, **Create schema**), for example `labs`.
3. **Upload a small file:** Catalog, **Add data**, **Upload files**, choose a CSV, create a table in `labs`.
4. **First notebook:** Workspace, **Create**, **Notebook**, attach to serverless compute, run:

   ```python
   df = spark.range(10)
   df.write.mode("overwrite").saveAsTable("labs.numbers")
   display(spark.table("labs.numbers"))
   ```

5. **SQL editor:** `SELECT COUNT(*) FROM labs.numbers;` on the provided SQL warehouse.
6. **CLI login** from your Mac ([Databricks CLI](../02_cli_tools_and_auth.md#databricks-cli)):

   ```bash
   databricks auth login --host https://<your-workspace-host>
   databricks current-user me
   databricks catalogs list
   ```

Free Edition limits compute size and daily usage; if a job is throttled, wait or reduce data size. Check the current limits on the Free Edition page.

## Cloud Trial on Azure (Optional)

1. Azure portal, **Create a resource**, **Azure Databricks**, in your project resource group and region; pricing tier **Trial (Premium)** if offered.
2. Azure creates a second, managed resource group for the workspace's infrastructure. Do not edit it.
3. **Launch workspace**; create a small cluster with **auto-termination** of 15 to 30 minutes, single node.
4. After the lab, delete the workspace (and its managed resource group goes with it): `az group delete --name <project rg> --yes` if it lives in the project group.

Cluster virtual machines bill against your Azure credits while running.

## Verify

```bash
databricks current-user me
databricks tables list <catalog> labs
```

## Cleanup

- Free Edition: drop lab schemas you no longer need (`DROP SCHEMA labs CASCADE`).
- Cloud trial: delete the workspace resource; confirm the managed resource group disappears.

## Common Problems

| Problem | Fix |
| --- | --- |
| Feature missing in Free Edition | Free Edition is serverless-only with a reduced feature set; use local Spark or a cloud trial |
| CLI cannot authenticate | Use the exact workspace host URL; run `databricks auth login` again |
| Cloud trial costs continue | A cluster without auto-termination, or the workspace still exists; check the cloud cost view |
