# Solution

Typical local flow:

    docker compose up -d
    docker exec -it kafka kafka-topics --bootstrap-server localhost:9092 --create --topic lab.events --partitions 1 --replication-factor 1
    docker exec -it kafka kafka-topics --bootstrap-server localhost:9092 --list

Concept checks:

- topic: named event stream
- partition: one ordered shard of that stream
- offset: position of a record within one partition

Architecture interpretation:

- polling can be enough for low-frequency simple integrations
- Kafka is stronger when multiple consumers, replay, and decoupling matter