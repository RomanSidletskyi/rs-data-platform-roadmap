"""Unit normalization for WFP price units. Plain Python: reference data built from code and reviewed like code."""

from __future__ import annotations

import re
from dataclasses import dataclass

_PATTERN = re.compile(r"^\s*(?:(\d+(?:\.\d+)?)\s*)?(KG|G|MT|L|ML)\s*$", re.IGNORECASE)
_TO_BASE = {"KG": ("KG", 1.0), "G": ("KG", 0.001), "MT": ("KG", 1000.0), "L": ("L", 1.0), "ML": ("L", 0.001)}


@dataclass(frozen=True)
class UnitInfo:
    unit: str
    base_unit: str | None
    quantity_in_base: float | None
    is_comparable: bool


def parse_unit(unit: str) -> UnitInfo:
    """'90 KG' -> 90 KG, '500 ML' -> 0.5 L, 'KG' -> 1 KG. Counts and services ('Unit', '30 pcs', 'kWh') are not comparable by weight."""
    match = _PATTERN.match(unit or "")
    if not match:
        return UnitInfo(unit, None, None, False)
    amount = float(match.group(1)) if match.group(1) else 1.0
    base, factor = _TO_BASE[match.group(2).upper()]
    if amount <= 0:
        return UnitInfo(unit, None, None, False)
    return UnitInfo(unit, base, round(amount * factor, 6), True)


def unit_rows(units: list[str]) -> list[tuple]:
    return [(i.unit, i.base_unit, i.quantity_in_base, i.is_comparable) for i in map(parse_unit, sorted(set(units)))]
