from __future__ import annotations

import json
from dataclasses import asdict, dataclass
from datetime import date
from pathlib import Path


REQUIRED_FIELDS = (
    "order_id",
    "customer_id",
    "order_date",
    "product_category",
    "quantity",
    "unit_price",
)


@dataclass(slots=True)
class QualityIssue:
    row_number: int
    field_name: str
    issue_code: str
    message: str


@dataclass(slots=True)
class QualityReport:
    checked_rows: int
    issue_count: int
    issues: list[QualityIssue]


class DataQualityError(ValueError):
    pass


def validate_records(records: list[dict[str, str]]) -> QualityReport:
    issues: list[QualityIssue] = []
    seen_order_ids: set[str] = set()

    for row_number, record in enumerate(records, start=2):
        for field_name in REQUIRED_FIELDS:
            if not record.get(field_name):
                issues.append(
                    QualityIssue(
                        row_number=row_number,
                        field_name=field_name,
                        issue_code="missing_required_value",
                        message=f"Missing required value for {field_name}",
                    )
                )

        order_id = record.get("order_id", "")
        if order_id:
            if order_id in seen_order_ids:
                issues.append(
                    QualityIssue(
                        row_number=row_number,
                        field_name="order_id",
                        issue_code="duplicate_order_id",
                        message=f"Duplicate order_id detected: {order_id}",
                    )
                )
            seen_order_ids.add(order_id)

        order_date = record.get("order_date", "")
        if order_date:
            try:
                date.fromisoformat(order_date)
            except ValueError:
                issues.append(
                    QualityIssue(
                        row_number=row_number,
                        field_name="order_date",
                        issue_code="invalid_date",
                        message=f"Invalid ISO date: {order_date}",
                    )
                )

        quantity_text = record.get("quantity", "")
        if quantity_text:
            try:
                quantity = int(quantity_text)
                if quantity <= 0:
                    raise ValueError("Quantity must be positive")
            except ValueError:
                issues.append(
                    QualityIssue(
                        row_number=row_number,
                        field_name="quantity",
                        issue_code="invalid_quantity",
                        message=f"Quantity must be a positive integer: {quantity_text}",
                    )
                )

        unit_price_text = record.get("unit_price", "")
        if unit_price_text:
            try:
                unit_price = float(unit_price_text)
                if unit_price <= 0:
                    raise ValueError("Unit price must be positive")
            except ValueError:
                issues.append(
                    QualityIssue(
                        row_number=row_number,
                        field_name="unit_price",
                        issue_code="invalid_unit_price",
                        message=f"Unit price must be a positive number: {unit_price_text}",
                    )
                )

    return QualityReport(
        checked_rows=len(records),
        issue_count=len(issues),
        issues=issues,
    )


def fail_if_quality_issues(report: QualityReport) -> None:
    if report.issue_count > 0:
        raise DataQualityError(
            f"Data quality check failed with {report.issue_count} issue(s)"
        )


def write_quality_report(report: QualityReport, output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "checked_rows": report.checked_rows,
        "issue_count": report.issue_count,
        "issues": [asdict(issue) for issue in report.issues],
    }
    output_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")