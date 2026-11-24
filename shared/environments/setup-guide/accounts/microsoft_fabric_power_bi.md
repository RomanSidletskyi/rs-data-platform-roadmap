# Microsoft Fabric and Power BI

## What You Get

| Option | Account | Cost | Use |
| --- | --- | --- | --- |
| **Power BI Desktop** | None needed to build reports | Free, Windows only | Data modeling, DAX, report design in `10-powerbi-fabric` |
| **Fabric trial** | Work or school Microsoft Entra account | Free trial capacity for a limited period | Lakehouse, Warehouse, Eventstream, Eventhouse, Real-Time Dashboards, Power BI service |
| **Power BI service, free license** | Work or school account | Free | Publish to your own "My workspace" only |

Personal email domains (Gmail, Outlook.com) are generally not accepted for Fabric and the Power BI service. If you have no work or school account, focus on Power BI Desktop and see the options at the end.

## Power BI Desktop on a Mac

Power BI Desktop runs only on Windows. Options:

| Option | Cost | Notes |
| --- | --- | --- |
| Windows virtual machine on the Mac (for example UTM or Parallels with Windows on ARM) | Free to paid, plus a Windows license | Most convenient for regular use; give it 8 GB of memory |
| Windows VM in Azure | Paid from Azure credits | Use a small VM size, **stop (deallocate)** after every session, delete when done |
| A Windows PC | - | Simplest if available |

Install Power BI Desktop from the Microsoft Store inside Windows so it updates automatically.

### First Configuration

1. **File**, **Options and settings**, **Options**, **Preview features**: leave defaults while learning.
2. **Get data**: connect to local CSV first, then to Snowflake (**Get data**, **Snowflake**; server `<orgname>-<account_name>.snowflakecomputing.com`, warehouse `P04_BI_WH`).
3. Use a dedicated read-only Snowflake role for BI (for example `P04_READER`), never your owner role.

## Fabric Trial

1. Sign in to the Fabric portal (app.fabric.microsoft.com) with your work or school account.
2. Account manager (your picture, top right), **Start trial** (or start it when you first create a Fabric item). Choose the region close to your other services.
3. **Workspaces**, **New workspace**, name `learning-fabric`; in **Advanced**, license mode **Trial**.
4. In the workspace, create a **Lakehouse** (`lh_learning`) and upload a CSV to **Files**, then **Load to table**.
5. Open the SQL analytics endpoint and run a query; build a quick Power BI report from the semantic model.
6. For real-time labs: create an **Eventstream** with a sample source, route it to an **Eventhouse**, then a **Real-Time Dashboard**.

### Verify

- The workspace shows a trial capacity icon.
- Account manager shows trial days remaining.

### Trial End

The trial capacity ends after the trial period; items in trial workspaces become inaccessible unless moved to a paid capacity. Export reports (`.pbix` from Desktop) and screenshots before the end.

## Without a Work or School Account

- Build everything that matters for learning (model, DAX, report) in **Power BI Desktop**; save `.pbix` files locally, not in the public repository if they contain data.
- For dashboards others can see, use **Looker Studio** on the BigQuery sandbox or a **Streamlit** app ([other free services](other_free_services.md)).
- Ask your employer or school whether a Fabric trial can be enabled for your account; that is the only supported path to the service.

## Common Problems

| Problem | Fix |
| --- | --- |
| "Your organization doesn't allow" or sign-up rejected | Personal email or the tenant admin disabled trials; use another option above |
| Snowflake connection fails in Desktop | Check server name format, warehouse name, and that the role can use the warehouse |
| Azure Windows VM still billing | Stopped from inside Windows is not deallocated; stop it from the portal or `az vm deallocate` |
