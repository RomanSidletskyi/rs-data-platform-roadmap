from datetime import datetime, timezone


def validate_job(job: dict, valid_job_types: list[str]) -> None:
    required_fields = {"job_id", "job_type", "payload"}
    missing_fields = sorted(required_fields - set(job))
    if missing_fields:
        raise ValueError(f"Missing required fields: {', '.join(missing_fields)}")

    if job["job_type"] not in valid_job_types:
        raise ValueError(f"Unsupported job_type: {job['job_type']}")


def process_job(job: dict) -> dict:
    job_type = job["job_type"]
    payload = job["payload"]

    if job_type == "aggregate_sales":
        return {
            "job_type": job_type,
            "status": "completed",
            "processed_at": datetime.now(timezone.utc).isoformat(),
            "summary": {
                "source": payload.get("source", "unknown"),
                "window": payload.get("window", "unknown"),
                "message": "aggregate_sales processed successfully",
            },
        }

    if job_type == "normalize_events":
        return {
            "job_type": job_type,
            "status": "completed",
            "processed_at": datetime.now(timezone.utc).isoformat(),
            "summary": {
                "message": "normalize_events processed successfully",
            },
        }

    raise ValueError(f"Unsupported job_type: {job_type}")
