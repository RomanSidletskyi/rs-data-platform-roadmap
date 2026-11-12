FROM confluentinc/cp-kafka-connect:7.7.1

# Pin the connector: pass the version from kafka_lab/.env (see README for how to find the latest).
ARG SNOWFLAKE_CONNECTOR_VERSION

USER root
RUN test -n "${SNOWFLAKE_CONNECTOR_VERSION}" \
 && mkdir -p /usr/share/java/snowflake-kafka-connector \
 && curl -fsSL -o "/usr/share/java/snowflake-kafka-connector/snowflake-kafka-connector-${SNOWFLAKE_CONNECTOR_VERSION}.jar" \
    "https://repo1.maven.org/maven2/com/snowflake/snowflake-kafka-connector/${SNOWFLAKE_CONNECTOR_VERSION}/snowflake-kafka-connector-${SNOWFLAKE_CONNECTOR_VERSION}.jar"
USER appuser
