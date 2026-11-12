"""Offline checks for the lake writer: python -m pytest test_lake_writer.py"""

import gzip
import json

from lake_writer import PartitionBatcher, object_key, to_line, write_batch
from producer import LocalSink

WINDOW = 60_000


def feed(records, max_records=1000):
    batcher = PartitionBatcher("wiki.recentchange", 1, WINDOW, max_records)
    batches = [b for off, ts in records if (b := batcher.add(off, ts, f'{{"o":{off}}}'))]
    if (last := batcher.drain()):
        batches.append(last)
    return [(b.start_offset, b.end_offset, b.window_start_ms) for b in batches]


def test_rotates_on_record_time_window():
    records = [(0, 1_000), (1, 59_000), (2, 61_000), (3, 119_999), (4, 120_000)]
    assert feed(records) == [(0, 1, 0), (2, 3, 60_000), (4, 4, 120_000)]


def test_rotates_on_max_records():
    records = [(i, 1_000 + i) for i in range(5)]
    assert feed(records, max_records=2) == [(0, 1, 0), (2, 3, 0), (4, 4, 0)]


def test_replay_produces_identical_boundaries():
    records = [(i, i * 7_000) for i in range(40)]
    assert feed(records, max_records=4) == feed(records, max_records=4)


def test_idle_close_only_after_window_and_grace():
    batcher = PartitionBatcher("t", 0, WINDOW, 1000)
    batcher.add(10, 5_000, "{}")
    assert batcher.close_if_idle(now_ms=65_000, grace_ms=10_000) is None
    batch = batcher.close_if_idle(now_ms=70_000, grace_ms=10_000)
    assert (batch.start_offset, batch.end_offset) == (10, 10)


def test_to_line_keeps_metadata_and_flags_bad_values():
    good = json.loads(to_line("t", 2, 42, 1_700_000_000_000, b"k", b'{"meta":{"id":"x"}}'))
    assert good["kafka"] == {"topic": "t", "partition": 2, "offset": 42, "timestamp": 1_700_000_000_000, "key": "k"}
    assert good["value"]["meta"]["id"] == "x"
    bad = json.loads(to_line("t", 2, 43, 1_700_000_000_000, None, b"not json"))
    assert bad["value"] is None and bad["value_raw"] == "not json"


def test_object_key_is_deterministic_and_rewrite_is_idempotent(tmp_path):
    batcher = PartitionBatcher("wiki.recentchange", 0, WINDOW, 1000)
    batcher.add(7, 1_794_233_101_000, to_line("wiki.recentchange", 0, 7, 1_794_233_101_000, None, b"{}"))
    batch = batcher.drain()
    key = object_key(batch)
    assert key == (
        "kafka/topic=wiki.recentchange/dt=2026-11-09/hour=14/partition=0/"
        "wiki.recentchange+0+00000000000000000007+00000000000000000007.ndjson.gz"
    )
    sink = LocalSink(tmp_path)
    assert write_batch(sink, batch) == (key, True)
    assert write_batch(sink, batch) == (key, False)
    lines = gzip.decompress((tmp_path / key).read_bytes()).decode().splitlines()
    assert json.loads(lines[0])["kafka"]["offset"] == 7
