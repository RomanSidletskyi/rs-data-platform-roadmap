"""Offline checks for the generator: python -m pytest test_food_oltp.py"""

from collections import Counter
from datetime import date

import pytest

from food_oltp import generate

START = date(2025, 3, 3)


@pytest.fixture(scope="module")
def days():
    return list(generate(START, days=4, seed=6, scale=0.2))


def test_same_seed_gives_same_extracts(days):
    assert list(generate(START, days=4, seed=6, scale=0.2)) == days


def test_day_zero_is_full_and_later_days_are_deltas(days):
    first, later = days[0][1], days[1][1]
    assert len(first["customers"]) > 5 * len(later["customers"])
    assert len(first["menu_items"]) > 5 * len(later["menu_items"])


def test_delta_rows_belong_to_their_day_except_late_customers(days):
    for day, tables in days[1:]:
        for name in ("restaurants", "menu_items", "couriers", "orders"):
            assert all(row["updated_at"].startswith(day.isoformat()) for row in tables[name]), name
        previous = (day.toordinal() - 1)
        for row in tables["customers"]:
            stamp = date.fromisoformat(row["updated_at"][:10]).toordinal()
            assert stamp in (day.toordinal(), previous)


def test_some_customers_arrive_after_their_first_order(days):
    late = 0
    seen: set[int] = set()
    for _, tables in days:
        seen |= {c["customer_id"] for c in tables["customers"]}
        late += sum(1 for o in tables["orders"] if o["customer_id"] not in seen)
    assert late > 0
    # every customer is known by the end
    all_orders = {o["customer_id"] for _, t in days[:-1] for o in t["orders"]}
    assert all_orders <= seen


def test_order_milestones_are_ordered_and_final_states_are_exclusive(days):
    for _, tables in days:
        for o in tables["orders"]:
            stamps = [o[k] for k in ("placed_at", "accepted_at", "picked_up_at", "delivered_at") if o[k]]
            assert stamps == sorted(stamps)
            assert not (o["delivered_at"] and o["cancelled_at"])


def test_unfinished_orders_reappear_with_a_later_status(days):
    statuses: dict[int, list[str]] = {}
    for _, tables in days:
        for o in {o["order_id"]: o for o in tables["orders"]}.values():
            statuses.setdefault(o["order_id"], []).append(o["status"])
    carried = [s for s in statuses.values() if len(s) == 2]
    assert carried
    assert all(s[0] in ("placed", "accepted", "picked_up") and s[1] in ("delivered", "cancelled") for s in carried)


def test_extracts_contain_exact_duplicates(days):
    for _, tables in days:
        counts = Counter(tuple(sorted(o.items())) for o in tables["orders"])
        assert any(n > 1 for n in counts.values())


def test_order_lines_use_positive_prices(days):
    for _, tables in days:
        assert all(float(line["unit_price"]) > 0 and line["quantity"] >= 1 for line in tables["order_items"])
