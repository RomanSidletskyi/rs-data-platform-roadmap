"""P04 micro-batch producer: event source -> gzipped NDJSON file + manifest per batch -> storage sink."""

from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import os
import random
import sys
import time
import uuid
from datetime import datetime, timezone
from pathlib import Path
from typing import Iterator, Protocol

import requests

WIKI_STREAM_URL = "https://stream.wikimedia.org/v2/stream/recentchange"
DEFAULT_USER_AGENT = "rs-data-platform-roadmap-p04/1.0 (learning project; set WIKI_USER_AGENT with your contact)"
DATA_PREFIX = "wiki"
MANIFEST_PREFIX = "wiki_manifest"
SYNTHETIC_WIKIS = ["enwiki", "dewiki", "frwiki", "ukwiki", "eswiki", "plwiki", "wikidatawiki", "commonswiki"]


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


def iso(ts: datetime) -> str:
    return ts.isoformat(timespec="milliseconds").replace("+00:00", "Z")


# ---------- sources ----------

def wikimedia_events(user_agent: str) -> Iterator[dict]:
    last_event_id: str | None = None
    backoff = 1
    while True:
        headers = {"User-Agent": user_agent, "Accept": "text/event-stream"}
        if last_event_id:
            # Resume after a disconnect; the server may replay some events, which staging deduplicates.
            headers["Last-Event-ID"] = last_event_id
        try:
            with requests.get(WIKI_STREAM_URL, headers=headers, stream=True, timeout=(10, 60)) as resp:
                resp.raise_for_status()
                backoff = 1
                for line in resp.iter_lines(decode_unicode=True):
                    if not line:
                        continue
                    if line.startswith("id:"):
                        last_event_id = line[3:].strip()
                    elif line.startswith("data:"):
                        try:
                            event = json.loads(line[5:].strip())
                        except json.JSONDecodeError:
                            continue
                        if event.get("meta", {}).get("domain") == "canary":
                            continue
                        yield event
        except requests.RequestException as exc:
            print(f"stream error: {exc}; reconnecting in {backoff}s", file=sys.stderr)
            time.sleep(backoff)
            backoff = min(backoff * 2, 60)


def synthetic_events(rate_per_sec: float, seed: int | None = None) -> Iterator[dict]:
    rng = random.Random(seed)
    rc_id = 0
    while True:
        rc_id += 1
        now = utc_now()
        wiki = rng.choice(SYNTHETIC_WIKIS)
        is_bot = rng.random() < 0.25
        change_type = rng.choices(["edit", "new", "log", "categorize"], weights=[75, 8, 9, 8])[0]
        old_len = rng.randint(0, 60_000)
        event = {
            "meta": {
                "id": str(uuid.uuid4()),
                "dt": iso(now),
                "domain": f"{wiki}.synthetic.local",
                "stream": "mediawiki.recentchange",
            },
            "id": rc_id,
            "type": change_type,
            "namespace": rng.choice([0, 0, 0, 0, 1, 2, 4, 14]),
            # Pareto skew produces a few hot pages, like real traffic.
            "title": f"Page_{int(rng.paretovariate(1.2)) % 5000}",
            "user": f"Bot{rng.randint(1, 40)}" if is_bot else f"User{rng.randint(1, 20_000)}",
            "bot": is_bot,
            "minor": rng.random() < 0.2,
            "wiki": wiki,
            "server_name": f"{wiki}.synthetic.local",
            "timestamp": int(now.timestamp()),
        }
        if change_type in ("edit", "new"):
            event["length"] = {
                "old": None if change_type == "new" else old_len,
                "new": max(0, old_len + rng.randint(-2_000, 2_000)),
            }
        yield event
        time.sleep(rng.expovariate(rate_per_sec))


# ---------- sinks ----------

class Sink(Protocol):
    def put(self, key: str, data: bytes, overwrite: bool = False) -> None: ...


class LocalSink:
    def __init__(self, root: Path) -> None:
        self.root = root

    def put(self, key: str, data: bytes, overwrite: bool = False) -> None:
        path = self.root / key
        path.parent.mkdir(parents=True, exist_ok=True)
        if path.exists() and not overwrite:
            raise FileExistsError(path)
        tmp = path.with_name(path.name + ".tmp")
        tmp.write_bytes(data)
        tmp.replace(path)


class AzureBlobSink:
    def __init__(self, account_url: str, container: str) -> None:
        from azure.identity import DefaultAzureCredential
        from azure.storage.blob import BlobServiceClient

        service = BlobServiceClient(account_url=account_url, credential=DefaultAzureCredential())
        self.container = service.get_container_client(container)

    def put(self, key: str, data: bytes, overwrite: bool = False) -> None:
        self.container.upload_blob(name=key, data=data, overwrite=overwrite)


class S3Sink:
    def __init__(self, bucket: str, prefix: str) -> None:
        import boto3

        self.client = boto3.client("s3")
        self.bucket = bucket
        self.prefix = prefix

    def put(self, key: str, data: bytes, overwrite: bool = False) -> None:
        # Unique keys make accidental overwrites practically impossible; S3 has no cheap pre-check here.
        self.client.put_object(Bucket=self.bucket, Key=f"{self.prefix}{key}", Body=data)


# ---------- batch writing ----------

def encode_lines(lines: list[str]) -> bytes:
    return gzip.compress("".join(line + "\n" for line in lines).encode("utf-8"), mtime=0)


def encode_events(events: list[dict]) -> bytes:
    return encode_lines([json.dumps(e, ensure_ascii=False, separators=(",", ":")) for e in events])


def batch_keys(written_at: datetime) -> tuple[str, str, str]:
    basename = f"recentchange_{written_at:%Y%m%dT%H%M%S}Z_{uuid.uuid4().hex[:12]}"
    folder = f"dt={written_at:%Y-%m-%d}/hour={written_at:%H}"
    return (
        f"{DATA_PREFIX}/{folder}/{basename}.ndjson.gz",
        f"{MANIFEST_PREFIX}/{folder}/{basename}.json",
        f"{basename}.ndjson.gz",
    )


def write_payload(
    sink: Sink,
    payload: bytes,
    row_count: int,
    first_event_dt: str | None,
    last_event_dt: str | None,
    opened_at: datetime,
    producer_id: str,
    source: str,
) -> dict:
    data_key, manifest_key, file_basename = batch_keys(utc_now())
    sink.put(data_key, payload)
    manifest = {
        "file_name": data_key,
        "file_basename": file_basename,
        "row_count": row_count,
        "bytes": len(payload),
        "sha256": hashlib.sha256(payload).hexdigest(),
        "first_event_dt": first_event_dt,
        "last_event_dt": last_event_dt,
        "batch_opened_at": iso(opened_at),
        "file_written_at": iso(utc_now()),
        "producer_id": producer_id,
        "source": source,
    }
    # Manifest goes second: a manifest always describes a file that was already written.
    sink.put(manifest_key, json.dumps(manifest, separators=(",", ":")).encode("utf-8"))
    return manifest


def write_batch(sink: Sink, events: list[dict], opened_at: datetime, producer_id: str, source: str) -> dict:
    return write_payload(
        sink,
        encode_events(events),
        len(events),
        events[0].get("meta", {}).get("dt"),
        events[-1].get("meta", {}).get("dt"),
        opened_at,
        producer_id,
        source,
    )


# ---------- CLI ----------

def add_sink_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--sink", choices=["local", "azure", "s3"], default="local")
    parser.add_argument("--local-dir", type=Path, default=Path("landing_local"))
    parser.add_argument("--azure-account-url", default=os.environ.get("P04_AZURE_ACCOUNT_URL"))
    parser.add_argument("--azure-container", default=os.environ.get("P04_CONTAINER", "landing"))
    parser.add_argument("--s3-bucket", default=os.environ.get("P04_BUCKET"))
    parser.add_argument("--s3-prefix", default="landing/")


def build_sink(args: argparse.Namespace) -> Sink:
    if args.sink == "local":
        return LocalSink(args.local_dir)
    if args.sink == "azure":
        if not args.azure_account_url:
            sys.exit("--azure-account-url or P04_AZURE_ACCOUNT_URL is required for --sink azure")
        return AzureBlobSink(args.azure_account_url, args.azure_container)
    if not args.s3_bucket:
        sys.exit("--s3-bucket or P04_BUCKET is required for --sink s3")
    return S3Sink(args.s3_bucket, args.s3_prefix)


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", choices=["wikimedia", "synthetic"], default="wikimedia")
    parser.add_argument("--rate", type=float, default=20.0, help="synthetic events per second")
    parser.add_argument("--seed", type=int, default=None)
    parser.add_argument("--user-agent", default=os.environ.get("WIKI_USER_AGENT", DEFAULT_USER_AGENT))
    parser.add_argument("--batch-seconds", type=float, default=60.0)
    parser.add_argument("--max-events", type=int, default=20_000)
    parser.add_argument("--duration-minutes", type=float, required=True, help="always bounded, to protect your credits")
    add_sink_args(parser)
    return parser.parse_args(argv)


def run(args: argparse.Namespace) -> int:
    sink = build_sink(args)
    source = (
        wikimedia_events(args.user_agent)
        if args.source == "wikimedia"
        else synthetic_events(args.rate, args.seed)
    )
    producer_id = f"p04-{uuid.uuid4().hex[:8]}"
    deadline = time.monotonic() + args.duration_minutes * 60
    batch: list[dict] = []
    opened_at, opened_mono = utc_now(), time.monotonic()
    files = events_total = 0

    def flush() -> None:
        nonlocal files, events_total
        manifest = write_batch(sink, batch, opened_at, producer_id, args.source)
        files += 1
        events_total += manifest["row_count"]
        print(f"wrote {manifest['file_name']} rows={manifest['row_count']} bytes={manifest['bytes']}", flush=True)

    try:
        for event in source:
            batch.append(event)
            now_mono = time.monotonic()
            if len(batch) >= args.max_events or now_mono - opened_mono >= args.batch_seconds:
                flush()
                batch = []
                opened_at, opened_mono = utc_now(), now_mono
            if now_mono >= deadline:
                break
    except KeyboardInterrupt:
        print("interrupted; flushing the open batch", file=sys.stderr)
    if batch:
        flush()
    print(f"done: files={files} events={events_total} producer_id={producer_id}", flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(run(parse_args()))
