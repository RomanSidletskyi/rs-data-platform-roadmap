import json
from typing import Any, Dict


REQUIRED_FIELDS = (
    "event_id",
    "event_type",
    "event_time",
    "order_id",
    "customer_id",
    "amount",
    "currency",
)


def parse_event(line: str) -> Dict[str, Any]:
    return json.loads(line)


def validate_order_event(payload: Dict[str, Any]) -> Dict[str, Any]:
    missing = [field for field in REQUIRED_FIELDS if field not in payload]
    if missing:
        raise ValueError(f"missing required fields: {', '.join(missing)}")

    try:
        amount = float(payload["amount"])
    except (TypeError, ValueError) as exc:
        raise ValueError("amount must be numeric") from exc

    return {
        "event_id": str(payload["event_id"]),
        "event_time": str(payload["event_time"]),
        "event_type": str(payload["event_type"]),
        "order_id": str(payload["order_id"]),
        "customer_id": str(payload["customer_id"]),
        "amount": round(amount, 2),
        "currency": str(payload["currency"]),
    }


def build_upsert_record(payload: Dict[str, Any]) -> Dict[str, Any]:
    event = validate_order_event(payload)
    return {
        "amount": event["amount"],
        "currency": event["currency"],
        "customer_id": event["customer_id"],
        "event_id": event["event_id"],
        "event_time": event["event_time"],
        "order_id": event["order_id"],
    }


def build_dlq_record(payload: Dict[str, Any], error_type: str, error_reason: str, failed_at: str) -> Dict[str, Any]:
    return {
        "error_reason": error_reason,
        "error_type": error_type,
        "event_id": payload.get("event_id", "unknown"),
        "failed_at": failed_at,
        "original_payload": payload,
        "original_topic": "sales.order_events",
    }