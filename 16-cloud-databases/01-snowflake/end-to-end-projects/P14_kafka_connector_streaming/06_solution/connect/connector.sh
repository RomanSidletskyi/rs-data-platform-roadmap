#!/usr/bin/env bash
# Manage the P14 Snowflake sink connector on the local Kafka Connect.
# Usage: ./connector.sh apply|status|pause|resume|restart|delete
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$DIR/../p14.env"
[[ -f "$ENV_FILE" ]] || { echo "Create $ENV_FILE from p14.env.example first." >&2; exit 1; }
set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a

CONNECT_URL="${CONNECT_URL:-http://localhost:8083}"
NAME="${P14_CONNECTOR_NAME:-p14_wiki_snowflake_sink}"
SECRETS_DIR="$DIR/../../../_shared/kafka_lab/secrets"

write_secret() {
  : "${SNOWFLAKE_ACCOUNT_IDENTIFIER:?set SNOWFLAKE_ACCOUNT_IDENTIFIER in p14.env}"
  : "${P14_CONNECTOR_PRIVATE_KEY_FILE:?set P14_CONNECTOR_PRIVATE_KEY_FILE in p14.env}"
  local key
  # The connector expects the PKCS#8 body as one line, without BEGIN/END lines.
  key="$(grep -v -- "-----" "$P14_CONNECTOR_PRIVATE_KEY_FILE" | tr -d '\n')"
  [[ -n "$key" ]] || { echo "Private key file is empty or unreadable." >&2; exit 1; }
  mkdir -p "$SECRETS_DIR"
  chmod 700 "$SECRETS_DIR"
  (
    umask 077
    printf 'url=%s.snowflakecomputing.com:443\nuser=P14_KAFKA_SVC\nprivate_key=%s\n' \
      "$SNOWFLAKE_ACCOUNT_IDENTIFIER" "$key" > "$SECRETS_DIR/p14-snowflake.properties"
  )
  # Docker Desktop on macOS can read 600 files; on Linux hosts the container user may need chmod 644.
}

case "${1:-}" in
  apply)
    write_secret
    curl -fsS -X PUT -H "Content-Type: application/json" \
      --data @"$DIR/p14-snowflake-sink.json" "$CONNECT_URL/connectors/$NAME/config" \
      | jq '{name, tasks: (.tasks | length)}'
    sleep 5
    curl -fsS "$CONNECT_URL/connectors/$NAME/status" | jq '{connector: .connector.state, tasks: [.tasks[].state]}'
    ;;
  status)
    curl -fsS "$CONNECT_URL/connectors/$NAME/status" | jq
    ;;
  pause|resume)
    curl -fsS -X PUT "$CONNECT_URL/connectors/$NAME/$1" && echo "$1 requested"
    ;;
  restart)
    curl -fsS -X POST "$CONNECT_URL/connectors/$NAME/restart?includeTasks=true&onlyFailed=false" && echo "restart requested"
    ;;
  delete)
    curl -fsS -X DELETE "$CONNECT_URL/connectors/$NAME" && echo "deleted"
    ;;
  *)
    echo "usage: $0 apply|status|pause|resume|restart|delete" >&2
    exit 1
    ;;
esac
