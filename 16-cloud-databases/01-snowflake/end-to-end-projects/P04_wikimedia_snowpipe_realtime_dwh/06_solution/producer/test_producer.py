"""Offline checks for the P04 producer: python -m pytest test_producer.py"""

import gzip
import hashlib
import itertools
import json
from datetime import datetime, timezone

import pytest

from producer import LocalSink, synthetic_events, write_batch


def test_batch_and_manifest_agree(tmp_path):
    sink = LocalSink(tmp_path)
    events = list(itertools.islice(synthetic_events(rate_per_sec=1e6, seed=1), 25))

    manifest = write_batch(sink, events, datetime.now(timezone.utc), "test", "synthetic")

    data = (tmp_path / manifest["file_name"]).read_bytes()
    lines = gzip.decompress(data).decode("utf-8").splitlines()
    assert len(lines) == manifest["row_count"] == 25
    assert hashlib.sha256(data).hexdigest() == manifest["sha256"]
    assert {json.loads(line)["meta"]["id"] for line in lines} == {e["meta"]["id"] for e in events}

    assert manifest["file_name"].startswith("wiki/dt=")
    assert manifest["file_name"].endswith(manifest["file_basename"])
    manifest_files = list((tmp_path / "wiki_manifest").rglob("*.json"))
    assert len(manifest_files) == 1
    assert json.loads(manifest_files[0].read_text()) == manifest


def test_local_sink_refuses_overwrite(tmp_path):
    sink = LocalSink(tmp_path)
    sink.put("wiki/a.ndjson.gz", b"x")
    with pytest.raises(FileExistsError):
        sink.put("wiki/a.ndjson.gz", b"y")
    sink.put("wiki/a.ndjson.gz", b"y", overwrite=True)
    assert (tmp_path / "wiki/a.ndjson.gz").read_bytes() == b"y"


def test_synthetic_events_are_unique_and_shaped():
    events = list(itertools.islice(synthetic_events(rate_per_sec=1e6, seed=7), 500))
    assert len({e["meta"]["id"] for e in events}) == 500
    assert all({"meta", "wiki", "type", "bot", "title"} <= e.keys() for e in events)
