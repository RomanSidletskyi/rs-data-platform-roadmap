"""Offline checks for wiki_to_kafka: python -m pytest test_wiki_to_kafka.py"""

import itertools
import json

from wiki_to_kafka import producer_config, record_key, record_value, synthetic_events


def test_key_and_value_round_trip():
    event = next(synthetic_events(rate_per_sec=1e6, seed=3))
    assert record_key(event) == f"{event['wiki']}:{event['title']}".encode()
    assert json.loads(record_value(event)) == event


def test_same_page_same_key():
    events = list(itertools.islice(synthetic_events(rate_per_sec=1e6, seed=5), 2000))
    by_key = {}
    for e in events:
        by_key.setdefault(record_key(e), set()).add((e["wiki"], e["title"]))
    assert all(len(pages) == 1 for pages in by_key.values())


def test_sasl_only_when_configured(monkeypatch):
    monkeypatch.delenv("KAFKA_SASL_USERNAME", raising=False)
    assert "security.protocol" not in producer_config("localhost:9092")
    monkeypatch.setenv("KAFKA_SASL_USERNAME", "key")
    monkeypatch.setenv("KAFKA_SASL_PASSWORD", "secret")
    conf = producer_config("broker:9092")
    assert conf["security.protocol"] == "SASL_SSL" and conf["enable.idempotence"] is True
