"""P15 lake writer: Kafka topic -> immutable NDJSON.gz files named by offsets -> storage; offsets committed after each write."""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path

# Storage sinks are defined once, in the P04 producer (local folder, Azure Blob, S3).
P04_PRODUCER = (
    Path(__file__).resolve().parents[3] / "P04_wikimedia_snowpipe_realtime_dwh" / "06_solution" / "producer"
)
sys.path.insert(0, str(P04_PRODUCER))

from producer import Sink, add_sink_args, build_sink, encode_lines  # noqa: E402

ALREADY_EXISTS = {"FileExistsError", "ResourceExistsError"}


@dataclass
class Batch:
    topic: str
    partition: int
    start_offset: int
    end_offset: int
    window_start_ms: int
    lines: list[str]


class PartitionBatcher:
    """Groups one partition's records into files whose boundaries depend only on the records."""

    def __init__(self, topic: str, partition: int, window_ms: int, max_records: int) -> None:
        self.topic = topic
        self.partition = partition
        self.window_ms = window_ms
        self.max_records = max_records
        self._lines: list[str] = []
        self._start: int | None = None
        self._end: int | None = None
        self._window: int | None = None

    def add(self, offset: int, timestamp_ms: int, line: str) -> Batch | None:
        window = timestamp_ms // self.window_ms
        closed = None
        if self._lines and (window != self._window or len(self._lines) >= self.max_records):
            closed = self._close()
        if not self._lines:
            self._start, self._window = offset, window
        self._lines.append(line)
        self._end = offset
        return closed

    def close_if_idle(self, now_ms: int, grace_ms: int) -> Batch | None:
        # Only after the record-time window has ended, so a replay produces the same boundary.
        if self._lines and now_ms >= (self._window + 1) * self.window_ms + grace_ms:
            return self._close()
        return None

    def drain(self) -> Batch | None:
        return self._close() if self._lines else None

    def _close(self) -> Batch:
        batch = Batch(self.topic, self.partition, self._start, self._end, self._window * self.window_ms, self._lines)
        self._lines, self._start, self._end, self._window = [], None, None, None
        return batch


def to_line(topic: str, partition: int, offset: int, timestamp_ms: int, key: bytes | None, value: bytes | None) -> str:
    record: dict = {
        "kafka": {
            "topic": topic,
            "partition": partition,
            "offset": offset,
            "timestamp": timestamp_ms,
            "key": key.decode("utf-8", "replace") if key is not None else None,
        }
    }
    try:
        record["value"] = json.loads(value) if value is not None else None
    except (json.JSONDecodeError, UnicodeDecodeError):
        # The lake keeps everything; unparseable values are flagged downstream instead of dropped.
        record["value"] = None
        record["value_raw"] = value.decode("utf-8", "replace")
    return json.dumps(record, ensure_ascii=False, separators=(",", ":"))


def object_key(batch: Batch) -> str:
    dt = datetime.fromtimestamp(batch.window_start_ms / 1000, tz=timezone.utc)
    return (
        f"kafka/topic={batch.topic}/dt={dt:%Y-%m-%d}/hour={dt:%H}/partition={batch.partition}/"
        f"{batch.topic}+{batch.partition}+{batch.start_offset:020d}+{batch.end_offset:020d}.ndjson.gz"
    )


def write_batch(sink: Sink, batch: Batch) -> tuple[str, bool]:
    key = object_key(batch)
    try:
        sink.put(key, encode_lines(batch.lines))
    except Exception as exc:
        if type(exc).__name__ in ALREADY_EXISTS:
            return key, False
        raise
    return key, True


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bootstrap", default=os.environ.get("KAFKA_BOOTSTRAP", "localhost:9092"))
    parser.add_argument("--topic", default=os.environ.get("KAFKA_TOPIC", "wiki.recentchange"))
    parser.add_argument("--group", default=os.environ.get("P15_CONSUMER_GROUP", "p15-lake-writer"))
    parser.add_argument("--window-seconds", type=int, default=60, help="record-time window per file")
    parser.add_argument("--max-records", type=int, default=50_000)
    parser.add_argument("--grace-seconds", type=int, default=10)
    parser.add_argument("--duration-minutes", type=float, required=True, help="always bounded")
    parser.add_argument("--crash-after-upload", type=int, default=0, help="drill: exit before committing the Nth upload")
    add_sink_args(parser)
    return parser.parse_args(argv)


def run(args: argparse.Namespace) -> int:
    from confluent_kafka import TIMESTAMP_NOT_AVAILABLE, Consumer, TopicPartition

    sink = build_sink(args)
    consumer = Consumer({
        "bootstrap.servers": args.bootstrap,
        "group.id": args.group,
        "enable.auto.commit": False,
        "auto.offset.reset": "earliest",
    })
    window_ms, grace_ms = args.window_seconds * 1000, args.grace_seconds * 1000
    batchers: dict[int, PartitionBatcher] = {}
    uploads = 0

    def on_revoke(_consumer, partitions) -> None:
        # Uncommitted records are re-read by the next owner and produce the same file names.
        for tp in partitions:
            batchers.pop(tp.partition, None)

    def flush(batch: Batch) -> None:
        nonlocal uploads
        key, written = write_batch(sink, batch)
        uploads += 1
        if args.crash_after_upload and uploads >= args.crash_after_upload:
            print(f"simulated crash after uploading {key}, before commit", file=sys.stderr, flush=True)
            os._exit(3)
        consumer.commit(offsets=[TopicPartition(batch.topic, batch.partition, batch.end_offset + 1)], asynchronous=False)
        state = "wrote" if written else "exists, skipped"
        print(f"{state} {key} records={len(batch.lines)}", flush=True)

    consumer.subscribe([args.topic], on_revoke=on_revoke)
    deadline = time.monotonic() + args.duration_minutes * 60
    try:
        while time.monotonic() < deadline:
            msg = consumer.poll(1.0)
            if msg is not None:
                if msg.error():
                    print(f"consumer error: {msg.error()}", file=sys.stderr)
                    continue
                ts_type, ts = msg.timestamp()
                if ts_type == TIMESTAMP_NOT_AVAILABLE or ts < 0:
                    ts = int(time.time() * 1000)
                batcher = batchers.setdefault(
                    msg.partition(), PartitionBatcher(msg.topic(), msg.partition(), window_ms, args.max_records)
                )
                closed = batcher.add(msg.offset(), ts, to_line(msg.topic(), msg.partition(), msg.offset(), ts, msg.key(), msg.value()))
                if closed:
                    flush(closed)
            now_ms = int(time.time() * 1000)
            for batcher in list(batchers.values()):
                closed = batcher.close_if_idle(now_ms, grace_ms)
                if closed:
                    flush(closed)
    except KeyboardInterrupt:
        print("interrupted; flushing open batches", file=sys.stderr)
    finally:
        for batcher in list(batchers.values()):
            closed = batcher.drain()
            if closed:
                flush(closed)
        consumer.close()
    print(f"done: uploads={uploads}", flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(run(parse_args()))
