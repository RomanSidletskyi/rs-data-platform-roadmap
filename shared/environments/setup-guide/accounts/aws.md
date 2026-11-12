# AWS Account

## What You Get

- New accounts can choose a **free plan** with starter credits for a limited period; paid plans unlock all services. Terms changed in 2025; read the plan description on the sign-up page.
- Some services have always-free monthly allowances.
- A card and phone are required for verification.

## Before You Start

- An email address that you will use only for this AWS account (it becomes the **root user**).
- A card and a mobile phone.
- The region matching your Snowflake account (for AWS variants, the Snowflake account must also be on AWS).

## Create the Account

1. Open aws.amazon.com and choose "Create an AWS account" or the free tier page.
2. Enter the root email and an account name (for example `rs-learning`). Verify the email code.
3. Set a strong root password; store it in your password manager.
4. Contact information: choose **Personal**.
5. Choose the plan offered (free plan while learning, if available).
6. Enter card details and complete phone verification.
7. Support plan: **Basic** (free).
8. Sign in to the console as root **once**, only for the day-one steps below.

## Day One: Secure and Limit

### 1. MFA on the root user

Console, account menu (top right), **Security credentials**, **Assign MFA device**: authenticator app or passkey. Never create access keys for root.

### 2. A daily-use admin identity with IAM Identity Center

1. Console search: **IAM Identity Center**, **Enable** (in your chosen region).
2. **Users**, **Add user**: your name and a different email or alias; accept the invite and set a password and MFA.
3. **Permission sets**, **Create**: predefined `AdministratorAccess` (or `PowerUserAccess` for tighter daily use).
4. **AWS accounts**, select your account, **Assign users or groups**: your user with that permission set.
5. Note the **AWS access portal URL** shown in the Identity Center dashboard.
6. Sign out of root; from now on use the access portal.

### 3. Budgets

Console: **Billing and Cost Management**, **Budgets**, **Create budget**:

- **Use a template**, **Zero spend budget**: emails you when any spend appears.
- A second **Monthly cost budget** with a small amount and alerts at 50, 80, 100 percent.

Also in **Billing preferences**: enable free tier usage alerts and invoice delivery by email.

### 4. CLI login with SSO

```bash
aws configure sso
# SSO start URL: the access portal URL
# SSO region: the region where you enabled Identity Center
# choose the account and permission set, name the profile e.g. learning
aws sso login --profile learning
export AWS_PROFILE=learning
aws sts get-caller-identity
```

## Configure for This Repository

- **One region:** `aws configure set region <region> --profile learning`.
- **Tag everything** with `project=p04` (project scripts do this), so **Resource Groups and Tag Editor** can find leftovers.
- **Snowflake access** uses an IAM role with an external ID created by the project scripts, never user access keys.
- **S3 buckets:** keep Block Public Access on (default for new buckets).

## Verify

```bash
aws sts get-caller-identity          # shows your SSO role, not root
aws budgets describe-budgets --account-id "$(aws sts get-caller-identity --query Account --output text)" \
  --query "Budgets[].BudgetName"
```

## Daily Habits

- **Billing and Cost Management**, **Bills** or **Cost Explorer**: check after each lab week.
- **Resource Groups and Tag Editor**, search all regions for tag `project`: find forgotten resources.

## Cleanup

```bash
aws s3 rb "s3://<bucket>" --force
aws iam delete-role-policy --role-name <role> --policy-name <policy>
aws iam delete-role --role-name <role>
```

Each project's `06_solution/README.md` lists its exact cleanup.

## When the Free Plan Ends

Free plan accounts are closed or restricted at the end of the plan period or when credits run out, unless upgraded. Export results first; read the email AWS sends ahead of the end date.

## Common Problems

| Problem | Fix |
| --- | --- |
| Account stuck in verification | Complete phone verification; wait for the activation email |
| `The SSO session has expired` | `aws sso login --profile learning` |
| Service not available on the free plan | Upgrade only if needed, or use the Azure variant |
| `AccessDenied` from Snowflake to S3 | Trust policy external ID or principal does not match `DESC INTEGRATION`; rerun the project's connect script |
