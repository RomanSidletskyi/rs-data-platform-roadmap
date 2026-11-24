"""Bluesky Jetstream (or synthetic) events -> gzip NDJSON micro-batches per collection in cloud storage.

Files: bsky/collection=<post|like|repost|follow>/dt=YYYY-MM-DD/hour=HH/<opened>_<producer>_<seq>.json.gz
Every run is bounded by --duration-minutes, to protect your credits.
"""

from __future__ import annotations

import argparse
import gzip
import json
import os
import random
import sys
import time
import uuid
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Iterator

# Sinks are shared with P04: local folder, Azure Blob, S3.
P04_PRODUCER = Path(__file__).resolve().parents[3] / "P04_wikimedia_snowpipe_realtime_dwh" / "06_solution" / "producer"
sys.path.insert(0, str(P04_PRODUCER))
from producer import add_sink_args, build_sink  # noqa: E402

JETSTREAM = "wss://jetstream2.us-east.bsky.network/subscribe"
COLLECTIONS = {
    "app.bsky.feed.post": "post",
    "app.bsky.feed.like": "like",
    "app.bsky.feed.repost": "repost",
    "app.bsky.graph.follow": "follow",
}


def jetstream_url(cursor: int | None, endpoint: str = JETSTREAM) -> str:
    query = "&".join(f"wantedCollections={c}" for c in COLLECTIONS)
    return f"{endpoint}?{query}" + (f"&cursor={cursor}" if cursor else "")


def jetstream_events(cursor: int | None, endpoint: str = JETSTREAM) -> Iterator[dict]:
    from websockets.sync.client import connect

    with connect(jetstream_url(cursor, endpoint), max_size=2**21, open_timeout=30) as ws:
        for message in ws:
            yield json.loads(message)


def synthetic_events(rate_per_sec: float, seed: int | None = None) -> Iterator[dict]:
    """Jetstream-shaped commits: posts, likes and reposts of earlier posts, follows, and a few deletes."""
    rng = random.Random(seed)
    posts: list[str] = []
    created: list[tuple[str, str, str]] = []
    dids = [f"did:plc:synthetic{i:05d}" for i in range(2000)]
    while True:
        did = rng.choice(dids)
        time_us = int(time.time() * 1_000_000)
        rkey = uuid.uuid4().hex[:13]
        roll = rng.random()
        if roll < 0.02 and created:
            collection, del_did, del_rkey = created.pop(rng.randrange(len(created)))
            commit = {"rev": rkey, "operation": "delete", "collection": collection, "rkey": del_rkey}
            did = del_did
        else:
            if roll < 0.12 or not posts:
                collection = "app.bsky.feed.post"
                record = {"$type": collection, "text": f"synthetic post {rkey}", "langs": [rng.choice(["en", "ja", "pt", "de", "uk"])]}
                if posts and rng.random() < 0.4:
                    parent = rng.choice(posts)
                    record["reply"] = {"parent": {"uri": parent}, "root": {"uri": parent}}
                posts.append(f"at://{did}/{collection}/{rkey}")
                posts[:] = posts[-5000:]
            elif roll < 0.78:
                collection = "app.bsky.feed.like"
                record = {"$type": collection, "subject": {"uri": rng.choice(posts)}}
            elif roll < 0.89:
                collection = "app.bsky.feed.repost"
                record = {"$type": collection, "subject": {"uri": rng.choice(posts)}}
            else:
                collection = "app.bsky.graph.follow"
                record = {"$type": collection, "subject": rng.choice(dids)}
            record["createdAt"] = datetime.now(timezone.utc).isoformat(timespec="milliseconds").replace("+00:00", "Z")
            commit = {"rev": rkey, "operation": "create", "collection": collection, "rkey": rkey, "record": record, "cid": "bafysynthetic"}
            created.append((collection, did, rkey))
            created[:] = created[-20000:]
        yield {"did": did, "time_us": time_us, "kind": "commit", "commit": commit}
        time.sleep(1.0 / rate_per_sec)


@dataclass
class Buffer:
    lines: list[str] = field(default_factory=list)
    size: int = 0
    opened: float = 0.0
    first_time_us: int | None = None


@dataclass
class Batcher:
    """One buffer per collection. A buffer is flushed when it is full by count, by bytes, or by age."""

    max_events: int
    max_bytes: int
    max_seconds: float
    producer_id: str
    buffers: dict[str, Buffer] = field(default_factory=dict)
    seq: int = 0

    def add(self, short: str, event: dict, now: float) -> None:
        buffer = self.buffers.setdefault(short, Buffer(opened=now))
        if not buffer.lines:
            buffer.opened = now
            buffer.first_time_us = event.get("time_us")
        line = json.dumps(event, separators=(",", ":"), ensure_ascii=False)
        buffer.lines.append(line)
        buffer.size += len(line) + 1

    def due(self, now: float) -> list[str]:
        return [
            short for short, b in self.buffers.items()
            if b.lines and (len(b.lines) >= self.max_events or b.size >= self.max_bytes or now - b.opened >= self.max_seconds)
        ]

    def take(self, short: str, now_utc: datetime) -> tuple[str, bytes, int]:
        buffer = self.buffers[short]
        self.seq += 1
        key = (
            f"bsky/collection={short}/dt={now_utc:%Y-%m-%d}/hour={now_utc:%H}/"
            f"{now_utc:%Y%m%dT%H%M%S}_{self.producer_id}_{self.seq:06d}.json.gz"
        )
        data = gzip.compress(("\n".join(buffer.lines) + "\n").encode("utf-8"))
        count = len(buffer.lines)
        self.buffers[short] = Buffer()
        return key, data, count

    def safe_cursor(self, last_time_us: int | None) -> int | None:
        """Everything before this point is in a written file: the oldest unflushed event, or the last event seen."""
        pending = [b.first_time_us for b in self.buffers.values() if b.lines and b.first_time_us]
        return min(pending) if pending else last_time_us


def load_cursor(state_file: Path, rewind_seconds: float) -> int | None:
    if not state_file.exists():
        return None
    saved = json.loads(state_file.read_text())["cursor"]
    # Rewinding produces some duplicates on purpose; staging removes them. Skipping would lose events.
    return int(saved - rewind_seconds * 1_000_000)


def save_cursor(state_file: Path, cursor: int | None) -> None:
    if cursor:
        state_file.parent.mkdir(parents=True, exist_ok=True)
        state_file.write_text(json.dumps({"cursor": cursor, "saved_at": datetime.now(timezone.utc).isoformat()}))


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--source", choices=["jetstream", "synthetic"], default="jetstream")
    parser.add_argument("--endpoint", default=JETSTREAM, help="any public instance, for example wss://jetstream1.us-west.bsky.network/subscribe")
    parser.add_argument("--rate", type=float, default=500.0, help="synthetic events per second")
    parser.add_argument("--seed", type=int, default=None)
    parser.add_argument("--batch-seconds", type=float, default=60.0)
    parser.add_argument("--max-events", type=int, default=100_000)
    parser.add_argument("--max-mb", type=float, default=64.0, help="uncompressed size per file")
    parser.add_argument("--duration-minutes", type=float, required=True)
    parser.add_argument("--state-file", type=Path, default=Path("state/cursor.json"))
    parser.add_argument("--rewind-seconds", type=float, default=5.0)
    add_sink_args(parser)
    return parser.parse_args(argv)


def run(args: argparse.Namespace) -> int:
    sink = build_sink(args)
    batcher = Batcher(args.max_events, int(args.max_mb * 1024 * 1024), args.batch_seconds, uuid.uuid4().hex[:8])
    cursor = load_cursor(args.state_file, args.rewind_seconds) if args.source == "jetstream" else None
    events = jetstream_events(cursor, args.endpoint) if args.source == "jetstream" else synthetic_events(args.rate, args.seed)
    deadline = time.monotonic() + args.duration_minutes * 60
    last_time_us = None
    stats = {"files": 0, "events": 0, "ignored": 0}

    def flush(shorts: list[str]) -> None:
        for short in shorts:
            key, data, count = batcher.take(short, datetime.now(timezone.utc))
            sink.put(key, data)
            stats["files"] += 1
            stats["events"] += count
            print(f"{key} {count} events {len(data) / 1024:.0f} KiB", flush=True)
        save_cursor(args.state_file, batcher.safe_cursor(last_time_us))

    try:
        for event in events:
            now = time.monotonic()
            commit = event.get("commit") or {}
            short = COLLECTIONS.get(commit.get("collection", ""))
            if event.get("kind") != "commit" or short is None:
                stats["ignored"] += 1
            else:
                batcher.add(short, event, now)
                last_time_us = event.get("time_us", last_time_us)
            due = batcher.due(now)
            if due:
                flush(due)
            if now >= deadline:
                break
    except KeyboardInterrupt:
        print("interrupted, flushing", file=sys.stderr)
    flush([s for s, b in batcher.buffers.items() if b.lines])
    print(json.dumps(stats))
    return 0


if __name__ == "__main__":
    sys.exit(run(parse_args()))
