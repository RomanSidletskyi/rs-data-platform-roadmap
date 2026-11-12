"""Wikimedia recentchange (or synthetic) events -> Kafka topic, keyed by wiki:title."""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
from pathlib import Path

# Event sources are defined once, in the P04 producer, so P04, P14, and P15 see identical data.
P04_PRODUCER = (
    Path(__file__).resolve().parents[3] / "P04_wikimedia_snowpipe_realtime_dwh" / "06_solution" / "producer"
)
sys.path.insert(0, str(P04_PRODUCER))

from producer import DEFAULT_USER_AGENT, synthetic_events, wikimedia_events  # noqa: E402


def record_key(event: dict) -> bytes:
    # wiki:title keeps per-page ordering and spreads load better than wiki alone.
    return f"{event.get('wiki', 'unknown')}:{event.get('title', '')}".encode("utf-8")


def record_value(event: dict) -> bytes:
    return json.dumps(event, ensure_ascii=False, separators=(",", ":")).encode("utf-8")


def producer_config(bootstrap: str) -> dict:
    conf = {
        "bootstrap.servers": bootstrap,
        "client.id": "wiki-to-kafka",
        "acks": "all",
        "enable.idempotence": True,
        "compression.type": "zstd",
        "linger.ms": 50,
    }
    username = os.environ.get("KAFKA_SASL_USERNAME")
    if username:
        conf.update({
            "security.protocol": "SASL_SSL",
            "sasl.mechanisms": "PLAIN",
            "sasl.username": username,
            "sasl.password": os.environ["KAFKA_SASL_PASSWORD"],
        })
    return conf


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", choices=["wikimedia", "synthetic"], default="wikimedia")
    parser.add_argument("--rate", type=float, default=20.0, help="synthetic events per second")
    parser.add_argument("--seed", type=int, default=None)
    parser.add_argument("--user-agent", default=os.environ.get("WIKI_USER_AGENT", DEFAULT_USER_AGENT))
    parser.add_argument("--bootstrap", default=os.environ.get("KAFKA_BOOTSTRAP", "localhost:9092"))
    parser.add_argument("--topic", default=os.environ.get("KAFKA_TOPIC", "wiki.recentchange"))
    parser.add_argument("--duration-minutes", type=float, required=True, help="always bounded")
    return parser.parse_args(argv)


def run(args: argparse.Namespace) -> int:
    from confluent_kafka import Producer

    producer = Producer(producer_config(args.bootstrap))
    stats = {"delivered": 0, "failed": 0}

    def on_delivery(err, _msg) -> None:
        stats["failed" if err else "delivered"] += 1
        if err:
            print(f"delivery failed: {err}", file=sys.stderr)

    source = (
        wikimedia_events(args.user_agent) if args.source == "wikimedia" else synthetic_events(args.rate, args.seed)
    )
    deadline = time.monotonic() + args.duration_minutes * 60
    last_report = time.monotonic()
    try:
        for event in source:
            while True:
                try:
                    producer.produce(args.topic, key=record_key(event), value=record_value(event), on_delivery=on_delivery)
                    break
                except BufferError:
                    producer.poll(0.5)
            producer.poll(0)
            now = time.monotonic()
            if now - last_report >= 10:
                print(f"delivered={stats['delivered']} failed={stats['failed']}", flush=True)
                last_report = now
            if now >= deadline:
                break
    except KeyboardInterrupt:
        print("interrupted; flushing", file=sys.stderr)
    remaining = producer.flush(30)
    print(f"done: delivered={stats['delivered']} failed={stats['failed']} unflushed={remaining}", flush=True)
    return 0 if stats["failed"] == 0 and remaining == 0 else 1


if __name__ == "__main__":
    sys.exit(run(parse_args()))
