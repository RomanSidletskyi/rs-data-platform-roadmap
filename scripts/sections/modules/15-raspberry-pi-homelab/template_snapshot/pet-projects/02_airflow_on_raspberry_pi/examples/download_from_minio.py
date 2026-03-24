# pyright: reportMissingImports=false

import argparse
import os
from pathlib import Path

from minio import Minio


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Download a file from MinIO using environment-based credentials."
    )
    parser.add_argument("--bucket", required=True, help="Source MinIO bucket name")
    parser.add_argument("--object", required=True, help="Source object key inside the bucket")
    parser.add_argument("--file", required=True, help="Path to the local output file")
    parser.add_argument(
        "--endpoint",
        default=os.environ.get("MINIO_ENDPOINT"),
        help="MinIO endpoint, for example pi5.local:9000. Defaults to MINIO_ENDPOINT.",
    )
    parser.add_argument(
        "--access-key",
        default=os.environ.get("MINIO_ACCESS_KEY"),
        help="MinIO access key. Defaults to MINIO_ACCESS_KEY.",
    )
    parser.add_argument(
        "--secret-key",
        default=os.environ.get("MINIO_SECRET_KEY"),
        help="MinIO secret key. Defaults to MINIO_SECRET_KEY.",
    )
    parser.add_argument(
        "--secure",
        action="store_true",
        help="Use HTTPS instead of HTTP.",
    )
    return parser.parse_args()


def require_value(value: str | None, name: str) -> str:
    if value:
        return value
    raise SystemExit(f"Missing required value for {name}.")


def main() -> None:
    args = parse_args()

    endpoint = require_value(args.endpoint, "--endpoint or MINIO_ENDPOINT")
    access_key = require_value(args.access_key, "--access-key or MINIO_ACCESS_KEY")
    secret_key = require_value(args.secret_key, "--secret-key or MINIO_SECRET_KEY")

    output_path = Path(args.file)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    client = Minio(
        endpoint,
        access_key=access_key,
        secret_key=secret_key,
        secure=args.secure,
    )

    client.fget_object(args.bucket, args.object, str(output_path))
    print(f"Downloaded {args.bucket}/{args.object} to {output_path}")


if __name__ == "__main__":
    main()