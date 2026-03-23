import json
import os
from io import BytesIO


def get_minio_client():
    try:
        from minio import Minio
    except ImportError as exc:
        raise RuntimeError("minio package is required. Install dependencies from requirements.txt.") from exc

    endpoint = os.getenv("MINIO_ENDPOINT", "http://localhost:9000").replace("http://", "").replace("https://", "")

    return Minio(
        endpoint,
        access_key=os.getenv("MINIO_ROOT_USER", "minio"),
        secret_key=os.getenv("MINIO_ROOT_PASSWORD", "minio123"),
        secure=False,
    )


def ensure_bucket(client, bucket_name: str) -> None:
    if not client.bucket_exists(bucket_name):
        client.make_bucket(bucket_name)


def upload_summary_json(client, bucket_name: str, object_name: str, payload: dict) -> None:
    raw = json.dumps(payload, indent=2).encode("utf-8")
    client.put_object(
        bucket_name,
        object_name,
        BytesIO(raw),
        length=len(raw),
        content_type="application/json",
    )
