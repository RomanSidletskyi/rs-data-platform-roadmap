"""Offline checks for the Jetstream producer: python -m pytest test_jetstream_producer.py"""

import gzip
import itertools
import json
from datetime import datetime, timezone

from jetstream_producer import Batcher, jetstream_url, load_cursor, save_cursor, synthetic_events


def batcher(**overrides) -> Batcher:
    settings = {"max_events": 3, "max_bytes": 10_000, "max_seconds": 60.0, "producer_id": "test"}
    settings.update(overrides)
    return Batcher(**settings)


def event(time_us: int) -> dict:
    return {"did": "did:plc:x", "time_us": time_us, "kind": "commit", "commit": {"collection": "app.bsky.feed.like"}}


def test_url_lists_collections_and_cursor():
    url = jetstream_url(123)
    assert url.count("wantedCollections=") == 4 and url.endswith("&cursor=123")


def test_flush_by_count_and_by_age():
    b = batcher()
    for i in range(3):
        b.add("like", event(i), now=0.0)
    b.add("post", event(10), now=0.0)
    assert b.due(1.0) == ["like"]
    assert set(b.due(61.0)) == {"like", "post"}


def test_flush_by_bytes():
    b = batcher(max_events=1000, max_bytes=200)
    for i in range(3):
        b.add("like", event(i), now=0.0)
    assert b.due(0.0) == ["like"]


def test_take_writes_partitioned_gzip_ndjson():
    b = batcher()
    b.add("like", event(1), now=0.0)
    b.add("like", event(2), now=0.0)
    key, data, count = b.take("like", datetime(2026, 11, 10, 18, 5, 9, tzinfo=timezone.utc))
    assert key == "bsky/collection=like/dt=2026-11-10/hour=18/20261110T180509_test_000001.json.gz"
    lines = gzip.decompress(data).decode().splitlines()
    assert count == 2 and json.loads(lines[1])["time_us"] == 2


def test_safe_cursor_is_oldest_unflushed_event():
    b = batcher()
    b.add("like", event(500), now=0.0)
    b.add("post", event(300), now=0.0)
    assert b.safe_cursor(last_time_us=900) == 300
    b.take("post", datetime.now(timezone.utc))
    assert b.safe_cursor(last_time_us=900) == 500
    b.take("like", datetime.now(timezone.utc))
    assert b.safe_cursor(last_time_us=900) == 900


def test_cursor_rewinds_on_restart(tmp_path):
    state = tmp_path / "cursor.json"
    save_cursor(state, 10_000_000)
    assert load_cursor(state, rewind_seconds=5) == 5_000_000
    assert load_cursor(tmp_path / "missing.json", rewind_seconds=5) is None


def test_synthetic_events_look_like_jetstream():
    events = list(itertools.islice(synthetic_events(rate_per_sec=1e6, seed=8), 3000))
    collections = {e["commit"]["collection"] for e in events}
    assert collections == {"app.bsky.feed.post", "app.bsky.feed.like", "app.bsky.feed.repost", "app.bsky.graph.follow"}
    deletes = [e for e in events if e["commit"]["operation"] == "delete"]
    assert deletes and all("record" not in e["commit"] for e in deletes)
    likes = [e for e in events if e["commit"]["collection"] == "app.bsky.feed.like" and e["commit"]["operation"] == "create"]
    assert all(e["commit"]["record"]["subject"]["uri"].startswith("at://") for e in likes)
