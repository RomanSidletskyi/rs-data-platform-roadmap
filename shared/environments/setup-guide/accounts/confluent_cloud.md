# Confluent Cloud

## What You Get

- New sign-ups usually receive starter credits for a limited period; whether a payment method is required at sign-up varies. Read the offer on the sign-up page.
- Managed Kafka clusters, Schema Registry, managed connectors (including the Snowflake sink connector), and Flink SQL.

Local Kafka ([Stack B](../03_local_services.md#stack-b-kafka)) covers most Kafka learning for free. Use Confluent Cloud for managed connectors and a realistic security model, typically in P14.

## Before You Start

- The cloud and region of your Snowflake account (for example Azure West Europe). The cluster should be in the same place.
- The Confluent CLI installed ([Confluent CLI](../02_cli_tools_and_auth.md#confluent-cli-and-kcat)).

## Create the Account

1. Open confluent.io, "Try free" or "Start free", and sign up with email or a social login.
2. Verify the email.
3. Answer the onboarding questions; skip the guided cluster creation if you want to follow the steps below.
4. Billing: check the credits shown and add a payment method only if required.

## Day One: Secure

1. **MFA:** user menu, **Profile** or **Security**, enable multi-factor authentication.
2. **Notifications:** **Billing and payment**, review credits and usage; there are no hard spending caps, so cleanup is your control.

## Create a Lab Environment

1. **Environments:** use `default` or create `learning`.
2. **Add cluster**, type **Basic**, cloud and region matching Snowflake, single zone. Name it `p14-lab`.
3. **Topics**, **Create topic**: `wiki.recentchange`, partitions 3, default retention.
4. **API keys:** create a key scoped to this cluster. Prefer a **service account** with ACLs limited to the needed topics over a key tied to your user.
5. Store key and secret in an ignored env file, for example `p14.env`:

   ```bash
   CONFLUENT_BOOTSTRAP=<bootstrap server from cluster settings>
   CONFLUENT_API_KEY=<key>
   CONFLUENT_API_SECRET=<secret>
   ```

## Test from Your Mac

With the CLI:

```bash
confluent login --save
confluent environment use <env-id>
confluent kafka cluster use <cluster-id>
confluent api-key use <key> --resource <cluster-id>
echo '{"hello":"cloud"}' | confluent kafka topic produce wiki.recentchange
confluent kafka topic consume wiki.recentchange --from-beginning
```

With `kcat` (credentials passed from the env file, never typed into the repository):

```bash
set -a; source p14.env; set +a
kcat -b "$CONFLUENT_BOOTSTRAP" -X security.protocol=SASL_SSL -X sasl.mechanisms=PLAIN \
     -X sasl.username="$CONFLUENT_API_KEY" -X sasl.password="$CONFLUENT_API_SECRET" -L
```

## Cleanup After Each Lab Block

Clusters bill per hour even when idle.

1. Delete managed connectors.
2. Delete the cluster (**Cluster settings**, **Delete cluster**).
3. Delete API keys and service accounts you created.
4. Check **Billing and payment**, usage: no running resources.

## Common Problems

| Problem | Fix |
| --- | --- |
| `SASL authentication failed` | Key belongs to another cluster, or secret copied with spaces |
| Connector fails to reach Snowflake | Check the connector's Snowflake URL, user, and private key; the Snowflake user needs the key-pair registered |
| Credits drain while idle | A cluster or connector is still running; delete it |
