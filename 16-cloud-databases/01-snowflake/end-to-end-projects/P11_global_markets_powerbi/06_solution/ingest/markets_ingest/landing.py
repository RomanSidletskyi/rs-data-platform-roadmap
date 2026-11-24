"""Landing writers. Each one creates an object only if the key does not exist yet, so reruns land nothing twice.

Cloud SDKs are imported lazily: the local writer and the tests need only the standard library.
"""

from __future__ import annotations

from pathlib import Path


class LocalWriter:
    def __init__(self, root: str | Path):
        self.root = Path(root)

    def describe(self, key: str) -> str:
        return str(self.root / key)

    def exists(self, key: str) -> bool:
        return (self.root / key).exists()

    def put(self, key: str, body: bytes) -> bool:
        target = self.root / key
        if target.exists():
            return False
        target.parent.mkdir(parents=True, exist_ok=True)
        tmp = target.with_suffix(target.suffix + ".part")
        tmp.write_bytes(body)
        tmp.rename(target)
        return True


class AzureBlobWriter:
    """Uses DefaultAzureCredential: the function's managed identity in Azure, your az login locally."""

    def __init__(self, account_url: str, container: str):
        from azure.identity import DefaultAzureCredential
        from azure.storage.blob import ContainerClient

        self.container = ContainerClient(account_url, container, credential=DefaultAzureCredential())

    def describe(self, key: str) -> str:
        return f"{self.container.url}/{key}"

    def exists(self, key: str) -> bool:
        return self.container.get_blob_client(key).exists()

    def put(self, key: str, body: bytes) -> bool:
        from azure.core.exceptions import ResourceExistsError

        try:
            # overwrite=False is a create-if-absent: a concurrent run gets ResourceExistsError, not a second version.
            self.container.upload_blob(key, body, overwrite=False)
        except ResourceExistsError:
            return False
        return True


class S3Writer:
    """Uses the default boto3 credential chain: the Lambda execution role in AWS, your profile locally."""

    def __init__(self, bucket: str, prefix: str = "landing/"):
        import boto3

        self.s3 = boto3.client("s3")
        self.bucket = bucket
        self.prefix = prefix

    def describe(self, key: str) -> str:
        return f"s3://{self.bucket}/{self.prefix}{key}"

    def exists(self, key: str) -> bool:
        from botocore.exceptions import ClientError

        try:
            self.s3.head_object(Bucket=self.bucket, Key=self.prefix + key)
        except ClientError as error:
            if error.response["Error"]["Code"] in ("404", "NoSuchKey", "NotFound"):
                return False
            raise
        return True

    def put(self, key: str, body: bytes) -> bool:
        from botocore.exceptions import ClientError

        try:
            # Conditional write: S3 rejects the PUT with 412 if the key already exists.
            self.s3.put_object(Bucket=self.bucket, Key=self.prefix + key, Body=body, IfNoneMatch="*")
        except ClientError as error:
            if error.response["Error"]["Code"] in ("PreconditionFailed", "412"):
                return False
            raise
        return True
