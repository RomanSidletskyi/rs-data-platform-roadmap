#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="05-confluent-kafka-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "05-confluent-kafka")"

log "Creating 05-confluent-kafka structure..."

ensure_dir "$MODULE"

ensure_dir "$MODULE/learning-materials"
ensure_dir "$MODULE/learning-materials/01_kafka_foundations"
ensure_dir "$MODULE/learning-materials/02_producer_consumer_engineering"
ensure_dir "$MODULE/learning-materials/03_event_design_and_schema_governance"
ensure_dir "$MODULE/learning-materials/04_kafka_platform_operations"
ensure_dir "$MODULE/learning-materials/05_kafka_ecosystem_and_integrations"
ensure_dir "$MODULE/learning-materials/06_streaming_architecture_for_data_platforms"
ensure_dir "$MODULE/learning-materials/07_kafka_cookbook"

ensure_dir "$MODULE/simple-tasks"
ensure_dir "$MODULE/simple-tasks/01_kafka_foundations"
ensure_dir "$MODULE/simple-tasks/02_producer_consumer_engineering"
ensure_dir "$MODULE/simple-tasks/03_event_design_and_schema_governance"
ensure_dir "$MODULE/simple-tasks/04_kafka_platform_operations"
ensure_dir "$MODULE/simple-tasks/05_kafka_ecosystem_and_integrations"
ensure_dir "$MODULE/simple-tasks/06_streaming_architecture_for_data_platforms"
ensure_dir "$MODULE/simple-tasks/07_kafka_cookbook"

ensure_dir "$MODULE/pet-projects"

ensure_dir "$MODULE/pet-projects/01_iot_streaming_lab"
ensure_dir "$MODULE/pet-projects/01_iot_streaming_lab/config"
ensure_dir "$MODULE/pet-projects/01_iot_streaming_lab/data"
ensure_dir "$MODULE/pet-projects/01_iot_streaming_lab/docker"
ensure_dir "$MODULE/pet-projects/01_iot_streaming_lab/src"
ensure_dir "$MODULE/pet-projects/01_iot_streaming_lab/tests"

ensure_dir "$MODULE/pet-projects/02_clickstream_session_pipeline"
ensure_dir "$MODULE/pet-projects/02_clickstream_session_pipeline/config"
ensure_dir "$MODULE/pet-projects/02_clickstream_session_pipeline/data"
ensure_dir "$MODULE/pet-projects/02_clickstream_session_pipeline/docker"
ensure_dir "$MODULE/pet-projects/02_clickstream_session_pipeline/src"
ensure_dir "$MODULE/pet-projects/02_clickstream_session_pipeline/tests"

ensure_dir "$MODULE/pet-projects/03_orders_payments_shipments_event_backbone"
ensure_dir "$MODULE/pet-projects/03_orders_payments_shipments_event_backbone/config"
ensure_dir "$MODULE/pet-projects/03_orders_payments_shipments_event_backbone/data"
ensure_dir "$MODULE/pet-projects/03_orders_payments_shipments_event_backbone/docker"
ensure_dir "$MODULE/pet-projects/03_orders_payments_shipments_event_backbone/src"
ensure_dir "$MODULE/pet-projects/03_orders_payments_shipments_event_backbone/tests"

ensure_dir "$MODULE/pet-projects/04_kafka_to_postgres_reliable_sink_lab"
ensure_dir "$MODULE/pet-projects/04_kafka_to_postgres_reliable_sink_lab/config"
ensure_dir "$MODULE/pet-projects/04_kafka_to_postgres_reliable_sink_lab/data"
ensure_dir "$MODULE/pet-projects/04_kafka_to_postgres_reliable_sink_lab/docker"
ensure_dir "$MODULE/pet-projects/04_kafka_to_postgres_reliable_sink_lab/src"
ensure_dir "$MODULE/pet-projects/04_kafka_to_postgres_reliable_sink_lab/tests"

ensure_dir "$MODULE/pet-projects/reference_example_iot_streaming_lab"
ensure_dir "$MODULE/pet-projects/reference_example_iot_streaming_lab/config"
ensure_dir "$MODULE/pet-projects/reference_example_iot_streaming_lab/data"
ensure_dir "$MODULE/pet-projects/reference_example_iot_streaming_lab/docker"
ensure_dir "$MODULE/pet-projects/reference_example_iot_streaming_lab/src"
ensure_dir "$MODULE/pet-projects/reference_example_iot_streaming_lab/tests"

ensure_dir "$MODULE/pet-projects/reference_example_clickstream_session_pipeline"
ensure_dir "$MODULE/pet-projects/reference_example_clickstream_session_pipeline/config"
ensure_dir "$MODULE/pet-projects/reference_example_clickstream_session_pipeline/data"
ensure_dir "$MODULE/pet-projects/reference_example_clickstream_session_pipeline/docker"
ensure_dir "$MODULE/pet-projects/reference_example_clickstream_session_pipeline/src"
ensure_dir "$MODULE/pet-projects/reference_example_clickstream_session_pipeline/tests"

ensure_dir "$MODULE/pet-projects/reference_example_orders_payments_shipments_event_backbone"
ensure_dir "$MODULE/pet-projects/reference_example_orders_payments_shipments_event_backbone/config"
ensure_dir "$MODULE/pet-projects/reference_example_orders_payments_shipments_event_backbone/data"
ensure_dir "$MODULE/pet-projects/reference_example_orders_payments_shipments_event_backbone/docker"
ensure_dir "$MODULE/pet-projects/reference_example_orders_payments_shipments_event_backbone/src"
ensure_dir "$MODULE/pet-projects/reference_example_orders_payments_shipments_event_backbone/tests"

ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_postgres_reliable_sink_lab"
ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_postgres_reliable_sink_lab/config"
ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_postgres_reliable_sink_lab/data"
ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_postgres_reliable_sink_lab/docker"
ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_postgres_reliable_sink_lab/src"
ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_postgres_reliable_sink_lab/tests"

log "Adding .gitkeep files where useful..."

ensure_gitkeep "$MODULE/learning-materials"

ensure_gitkeep "$MODULE/simple-tasks/01_kafka_foundations"
ensure_gitkeep "$MODULE/simple-tasks/02_producer_consumer_engineering"
ensure_gitkeep "$MODULE/simple-tasks/03_event_design_and_schema_governance"
ensure_gitkeep "$MODULE/simple-tasks/04_kafka_platform_operations"
ensure_gitkeep "$MODULE/simple-tasks/05_kafka_ecosystem_and_integrations"
ensure_gitkeep "$MODULE/simple-tasks/06_streaming_architecture_for_data_platforms"
ensure_gitkeep "$MODULE/simple-tasks/07_kafka_cookbook"

ensure_gitkeep "$MODULE/pet-projects/01_iot_streaming_lab/config"
ensure_gitkeep "$MODULE/pet-projects/01_iot_streaming_lab/data"
ensure_gitkeep "$MODULE/pet-projects/01_iot_streaming_lab/docker"
ensure_gitkeep "$MODULE/pet-projects/01_iot_streaming_lab/src"
ensure_gitkeep "$MODULE/pet-projects/01_iot_streaming_lab/tests"

ensure_gitkeep "$MODULE/pet-projects/02_clickstream_session_pipeline/config"
ensure_gitkeep "$MODULE/pet-projects/02_clickstream_session_pipeline/data"
ensure_gitkeep "$MODULE/pet-projects/02_clickstream_session_pipeline/docker"
ensure_gitkeep "$MODULE/pet-projects/02_clickstream_session_pipeline/src"
ensure_gitkeep "$MODULE/pet-projects/02_clickstream_session_pipeline/tests"

ensure_gitkeep "$MODULE/pet-projects/03_orders_payments_shipments_event_backbone/config"
ensure_gitkeep "$MODULE/pet-projects/03_orders_payments_shipments_event_backbone/data"
ensure_gitkeep "$MODULE/pet-projects/03_orders_payments_shipments_event_backbone/docker"
ensure_gitkeep "$MODULE/pet-projects/03_orders_payments_shipments_event_backbone/src"
ensure_gitkeep "$MODULE/pet-projects/03_orders_payments_shipments_event_backbone/tests"

ensure_gitkeep "$MODULE/pet-projects/04_kafka_to_postgres_reliable_sink_lab/config"
ensure_gitkeep "$MODULE/pet-projects/04_kafka_to_postgres_reliable_sink_lab/data"
ensure_gitkeep "$MODULE/pet-projects/04_kafka_to_postgres_reliable_sink_lab/docker"
ensure_gitkeep "$MODULE/pet-projects/04_kafka_to_postgres_reliable_sink_lab/src"
ensure_gitkeep "$MODULE/pet-projects/04_kafka_to_postgres_reliable_sink_lab/tests"

ensure_gitkeep "$MODULE/pet-projects/reference_example_iot_streaming_lab/config"
ensure_gitkeep "$MODULE/pet-projects/reference_example_iot_streaming_lab/data"
ensure_gitkeep "$MODULE/pet-projects/reference_example_iot_streaming_lab/docker"
ensure_gitkeep "$MODULE/pet-projects/reference_example_iot_streaming_lab/src"
ensure_gitkeep "$MODULE/pet-projects/reference_example_iot_streaming_lab/tests"

ensure_gitkeep "$MODULE/pet-projects/reference_example_clickstream_session_pipeline/config"
ensure_gitkeep "$MODULE/pet-projects/reference_example_clickstream_session_pipeline/data"
ensure_gitkeep "$MODULE/pet-projects/reference_example_clickstream_session_pipeline/docker"
ensure_gitkeep "$MODULE/pet-projects/reference_example_clickstream_session_pipeline/src"
ensure_gitkeep "$MODULE/pet-projects/reference_example_clickstream_session_pipeline/tests"

ensure_gitkeep "$MODULE/pet-projects/reference_example_orders_payments_shipments_event_backbone/config"
ensure_gitkeep "$MODULE/pet-projects/reference_example_orders_payments_shipments_event_backbone/data"
ensure_gitkeep "$MODULE/pet-projects/reference_example_orders_payments_shipments_event_backbone/docker"
ensure_gitkeep "$MODULE/pet-projects/reference_example_orders_payments_shipments_event_backbone/src"
ensure_gitkeep "$MODULE/pet-projects/reference_example_orders_payments_shipments_event_backbone/tests"

ensure_gitkeep "$MODULE/pet-projects/reference_example_kafka_to_postgres_reliable_sink_lab/config"
ensure_gitkeep "$MODULE/pet-projects/reference_example_kafka_to_postgres_reliable_sink_lab/data"
ensure_gitkeep "$MODULE/pet-projects/reference_example_kafka_to_postgres_reliable_sink_lab/docker"
ensure_gitkeep "$MODULE/pet-projects/reference_example_kafka_to_postgres_reliable_sink_lab/src"
ensure_gitkeep "$MODULE/pet-projects/reference_example_kafka_to_postgres_reliable_sink_lab/tests"

log "05-confluent-kafka structure initialized."