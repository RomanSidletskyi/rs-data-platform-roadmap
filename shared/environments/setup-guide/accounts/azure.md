# Microsoft Azure Free Account

## What You Get

- **Azure free account:** a starter credit for the first month, a set of services free for twelve months, and always-free services. Identity verification needs a phone and a card; the card is not charged unless you upgrade.
- **Azure for Students:** a smaller credit renewed yearly while eligible, with a school email and **no card**.
- A **spending limit** is on by default for free accounts: when the credit is used up, paid resources stop instead of billing your card. Keep it on.

## Before You Start

- A Microsoft account (personal Outlook or any email registered as a Microsoft account), or a school account for Azure for Students.
- A phone for verification and, for the free account, a card.
- The region you chose for Snowflake (for example West Europe). Use it for every resource.

## Create the Account

1. Open the Azure free account page (azure.microsoft.com, "Try Azure for free"), or the Azure for Students page.
2. Sign in with your Microsoft account, or create one.
3. Fill in the profile: country, name, phone. Verify the phone with the SMS or call code.
4. Free account only: enter card details for identity verification.
5. Accept the agreement. Azure creates a tenant (directory) and a subscription named like "Azure subscription 1".
6. Open <https://portal.azure.com> and bookmark it.

## Day One: Secure and Limit

### 1. Multi-factor authentication

- Personal Microsoft account: account.microsoft.com, **Security**, turn on two-step verification with an authenticator app.
- New tenants have **security defaults** enabled, which require MFA for administrators. Leave them on (portal: **Microsoft Entra ID**, **Properties**, **Manage security defaults**).

### 2. Budget with alerts

Portal: **Cost Management + Billing**, **Cost Management**, **Budgets**, **Add**.

| Field | Value |
| --- | --- |
| Scope | Your subscription |
| Name | `monthly-learning` |
| Reset period | Monthly |
| Amount | A small number you are comfortable with, for example 20 in your billing currency |
| Alert conditions | Actual 50 %, 80 %, 100 %; Forecasted 100 % |
| Alert recipients | Your email |

Budgets alert, they do not stop resources. The spending limit and your teardown habit stop resources.

### 3. Check the spending limit

Portal: **Subscriptions**, your subscription, **Overview**. Free trial subscriptions show the spending limit status. Do not remove it while learning.

### 4. CLI login

```bash
az login
az account list -o table
az account set --subscription "<subscription name>"
az account show --query "{name:name, id:id, tenant:tenantId}"
```

## Configure for This Repository

### Register resource providers once

```bash
for ns in Microsoft.Storage Microsoft.EventGrid Microsoft.EventHub Microsoft.KeyVault; do
  az provider register --namespace "$ns" --wait
done
az provider list --query "[?registrationState=='Registered'].namespace" -o tsv | sort
```

Projects that need more providers register them in their provisioning script.

### One resource group per project

```bash
az group create --name rg-p04-wiki --location westeurope --tags project=p04
```

Everything a project creates goes into its group, so cleanup is one command. Tag every group with `project`.

### Data-plane roles for yourself

Owners of a subscription can manage storage accounts, but reading and writing blobs with Entra ID login needs a **data-plane** role such as `Storage Blob Data Contributor`. Project scripts assign it on the storage account; assignments take a few minutes to become effective.

### Default region and output

```bash
az config set defaults.location=westeurope core.output=table
```

## Verify

```bash
az account show -o table
az group list -o table
az consumption budget list -o table      # your budget appears
```

## Daily Habits

- Portal: **Cost Management**, **Cost analysis**, group by resource group; look at it at the end of each lab week.
- `az resource list -o table` shows anything you forgot.
- Stop or delete compute (VMs, Databricks clusters) the same day.

## Cleanup

```bash
az group delete --name rg-p04-wiki --yes --no-wait
az group list -o table        # repeat until the group disappears
```

Deleting a resource group deletes everything inside it. Double-check the name.

## When the Credit or Trial Ends

- Paid services stop when the spending limit is reached or the first month ends, unless you upgrade to pay-as-you-go.
- Free-for-twelve-months services continue within their limits after an upgrade only.
- Before the end: export results, delete resource groups you no longer need.

## Common Problems

| Problem | Fix |
| --- | --- |
| `The subscription is not registered to use namespace` | `az provider register --namespace <namespace> --wait` |
| `AuthorizationPermissionMismatch` on blobs | Missing or not yet propagated data-plane role; wait a few minutes or check the assignment |
| Region or SKU not available for the subscription | Pick another region close to your Snowflake region, or a different SKU; free subscriptions have quotas |
| Storage account name taken | Names are global; add digits |
| Phone or card verification fails | Use a card in your own name and a mobile number; prepaid cards are often rejected |
