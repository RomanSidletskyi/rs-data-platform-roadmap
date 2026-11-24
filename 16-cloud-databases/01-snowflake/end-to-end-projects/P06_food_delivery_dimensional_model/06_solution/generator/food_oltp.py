"""Synthetic food delivery OLTP: one full extract on day 0, then one delta extract per day.

Each extract holds every row created or changed that day, in its end-of-day state, as one CSV per table:
  <out>/day=YYYY-MM-DD/{customers,restaurants,menu_items,couriers,orders,order_items}.csv

Realistic problems on purpose:
  - dimension changes that need history (customer city and loyalty tier, restaurant cuisine and price tier)
  - customers whose record arrives one day after their first order (late-arriving dimension)
  - orders still in progress at extract time, completed in the next day's extract (accumulating snapshot)
  - a few exact duplicate order rows per extract
"""

from __future__ import annotations

import argparse
import csv
import random
import sys
from dataclasses import dataclass, field
from datetime import date, datetime, time, timedelta
from pathlib import Path
from typing import Iterator

CITIES = ["Kyiv", "Lviv", "Odesa", "Kharkiv"]
CUISINES = ["Ukrainian", "Italian", "Japanese", "Georgian", "Burgers", "Vegan", "Pizza"]
TIERS = ["bronze", "silver", "gold"]
VEHICLES = ["bike", "scooter", "car"]
CATEGORIES = ["main", "side", "drink", "dessert"]
FIRST = ["Olena", "Andrii", "Iryna", "Taras", "Marta", "Dmytro", "Sofiia", "Bohdan", "Kateryna", "Yurii"]
LAST = ["Koval", "Shevchenko", "Bondar", "Melnyk", "Tkachenko", "Kravets", "Moroz", "Lysenko"]

COLUMNS = {
    "customers": ["customer_id", "full_name", "email", "city", "loyalty_tier", "signup_date", "is_deleted", "updated_at"],
    "restaurants": ["restaurant_id", "name", "city", "cuisine", "price_tier", "rating", "is_active", "updated_at"],
    "menu_items": ["item_id", "restaurant_id", "name", "category", "price", "is_available", "updated_at"],
    "couriers": ["courier_id", "name", "city", "vehicle", "updated_at"],
    "orders": [
        "order_id", "customer_id", "restaurant_id", "courier_id", "status", "placed_at", "accepted_at",
        "picked_up_at", "delivered_at", "cancelled_at", "delivery_fee", "tip", "updated_at",
    ],
    "order_items": ["order_id", "line_no", "item_id", "quantity", "unit_price", "updated_at"],
}


def ts(value: datetime | None) -> str:
    return value.strftime("%Y-%m-%d %H:%M:%S") if value else ""


@dataclass
class World:
    rng: random.Random
    scale: float
    customers: dict[int, dict] = field(default_factory=dict)
    restaurants: dict[int, dict] = field(default_factory=dict)
    items: dict[int, dict] = field(default_factory=dict)
    couriers: dict[int, dict] = field(default_factory=dict)
    open_orders: dict[int, dict] = field(default_factory=dict)
    held_back: dict[int, dict] = field(default_factory=dict)
    next_order_id: int = 100_000

    def n(self, base: int) -> int:
        return max(1, int(base * self.scale))

    def at(self, day: date, start_hour: int = 0, end_hour: int = 24) -> datetime:
        seconds = self.rng.randrange(start_hour * 3600, end_hour * 3600)
        return datetime.combine(day, time()) + timedelta(seconds=seconds)

    def new_customer(self, day: date, when: datetime) -> dict:
        cid = len(self.customers) + len(self.held_back) + 1
        return {
            "customer_id": cid,
            "full_name": f"{self.rng.choice(FIRST)} {self.rng.choice(LAST)}",
            "email": f"customer{cid}@example.com",
            "city": self.rng.choice(CITIES),
            "loyalty_tier": "bronze",
            "signup_date": day.isoformat(),
            "is_deleted": "false",
            "updated_at": ts(when),
        }

    def new_restaurant(self, when: datetime) -> dict:
        rid = len(self.restaurants) + 1
        restaurant = {
            "restaurant_id": rid,
            "name": f"{self.rng.choice(LAST)} Kitchen {rid}",
            "city": self.rng.choice(CITIES),
            "cuisine": self.rng.choice(CUISINES),
            "price_tier": self.rng.randint(1, 3),
            "rating": round(self.rng.uniform(3.5, 5.0), 1),
            "is_active": "true",
            "updated_at": ts(when),
        }
        self.restaurants[rid] = restaurant
        for _ in range(self.rng.randint(6, 14)):
            iid = len(self.items) + 1
            self.items[iid] = {
                "item_id": iid,
                "restaurant_id": rid,
                "name": f"Dish {iid}",
                "category": self.rng.choice(CATEGORIES),
                "price": f"{self.rng.uniform(2.5, 25.0):.2f}",
                "is_available": "true",
                "updated_at": ts(when),
            }
        return restaurant


def initial_world(start: date, seed: int, scale: float) -> World:
    world = World(rng=random.Random(seed), scale=scale)
    for _ in range(world.n(3000)):
        customer = world.new_customer(start - timedelta(days=world.rng.randint(1, 700)), world.at(start, 0, 1))
        world.customers[customer["customer_id"]] = customer
    for _ in range(world.n(150)):
        world.new_restaurant(world.at(start, 0, 1))
    for cid in range(1, world.n(200) + 1):
        world.couriers[cid] = {
            "courier_id": cid,
            "name": f"{world.rng.choice(FIRST)} {world.rng.choice(LAST)}",
            "city": world.rng.choice(CITIES),
            "vehicle": world.rng.choice(VEHICLES),
            "updated_at": ts(world.at(start, 0, 1)),
        }
    return world


def change_dimensions(world: World, day: date, touched: dict[str, dict[int, dict]]) -> None:
    rng = world.rng
    for customer in rng.sample(list(world.customers.values()), world.n(30)):
        if rng.random() < 0.5:
            customer["city"] = rng.choice([c for c in CITIES if c != customer["city"]])
        else:
            customer["loyalty_tier"] = TIERS[min(TIERS.index(customer["loyalty_tier"]) + 1, len(TIERS) - 1)]
        customer["updated_at"] = ts(world.at(day))
        touched["customers"][customer["customer_id"]] = customer
    for restaurant in rng.sample(list(world.restaurants.values()), world.n(3)):
        if rng.random() < 0.7:
            restaurant["price_tier"] = rng.randint(1, 3)
        else:
            restaurant["cuisine"] = rng.choice([c for c in CUISINES if c != restaurant["cuisine"]])
        restaurant["rating"] = round(min(5.0, max(1.0, restaurant["rating"] + rng.uniform(-0.2, 0.2))), 1)
        restaurant["updated_at"] = ts(world.at(day))
        touched["restaurants"][restaurant["restaurant_id"]] = restaurant
    if rng.random() < 0.15:
        restaurant = rng.choice([r for r in world.restaurants.values() if r["is_active"] == "true"])
        restaurant["is_active"] = "false"
        restaurant["updated_at"] = ts(world.at(day))
        touched["restaurants"][restaurant["restaurant_id"]] = restaurant
    for item in rng.sample(list(world.items.values()), world.n(40)):
        item["price"] = f"{float(item['price']) * rng.uniform(0.9, 1.15):.2f}"
        item["updated_at"] = ts(world.at(day))
        touched["menu_items"][item["item_id"]] = item
    for courier in rng.sample(list(world.couriers.values()), world.n(2)):
        courier["vehicle"] = rng.choice([v for v in VEHICLES if v != courier["vehicle"]])
        courier["updated_at"] = ts(world.at(day))
        touched["couriers"][courier["courier_id"]] = courier
    if rng.random() < 0.3:
        restaurant = world.new_restaurant(world.at(day, 6, 10))
        touched["restaurants"][restaurant["restaurant_id"]] = restaurant
        for item in world.items.values():
            if item["restaurant_id"] == restaurant["restaurant_id"]:
                touched["menu_items"][item["item_id"]] = item


@dataclass
class Catalog:
    """Per-day lookups so that placing an order does not scan every restaurant and menu."""

    active: list[dict]
    menus: dict[int, list[dict]]
    couriers_by_city: dict[str, list[dict]]

    @classmethod
    def of(cls, world: "World") -> "Catalog":
        menus: dict[int, list[dict]] = {}
        for item in world.items.values():
            if item["is_available"] == "true":
                menus.setdefault(item["restaurant_id"], []).append(item)
        couriers: dict[str, list[dict]] = {}
        for courier in world.couriers.values():
            couriers.setdefault(courier["city"], []).append(courier)
        active = [r for r in world.restaurants.values() if r["is_active"] == "true" and r["restaurant_id"] in menus]
        return cls(active, menus, couriers)


def place_order(world: World, catalog: Catalog, day: date, customer: dict, lines: list[dict]) -> None:
    rng = world.rng
    restaurant = rng.choice(catalog.active)
    couriers = catalog.couriers_by_city.get(restaurant["city"]) or list(world.couriers.values())
    placed = world.at(day, 10, 24)
    order = {
        "order_id": world.next_order_id,
        "customer_id": customer["customer_id"],
        "restaurant_id": restaurant["restaurant_id"],
        "courier_id": rng.choice(couriers)["courier_id"],
        "placed_at": placed,
        "accepted_at": None,
        "picked_up_at": None,
        "delivered_at": None,
        "cancelled_at": None,
        "delivery_fee": f"{rng.choice([0.0, 1.49, 2.99, 3.99]):.2f}",
        "tip": f"{rng.choice([0.0, 0.0, 1.0, 2.0, 3.0]):.2f}",
    }
    world.next_order_id += 1
    menu = catalog.menus[restaurant["restaurant_id"]]
    for line_no, item in enumerate(rng.sample(menu, min(len(menu), rng.randint(1, 4))), start=1):
        lines.append({
            "order_id": order["order_id"],
            "line_no": line_no,
            "item_id": item["item_id"],
            "quantity": rng.randint(1, 3),
            "unit_price": item["price"],
            "updated_at": ts(placed),
        })

    roll = rng.random()
    if roll < 0.05:
        order["cancelled_at"] = placed + timedelta(minutes=rng.randint(1, 20))
    else:
        order["accepted_at"] = placed + timedelta(minutes=rng.randint(1, 8))
        order["picked_up_at"] = order["accepted_at"] + timedelta(minutes=rng.randint(10, 30))
        order["delivered_at"] = order["picked_up_at"] + timedelta(minutes=rng.randint(10, 45))
    world.open_orders[order["order_id"]] = order


def order_row(order: dict, extract_end: datetime) -> dict:
    """Order as the source system shows it at extract time: future milestones are not known yet."""
    seen = {k: (v if isinstance(v, datetime) and v <= extract_end else None) for k, v in order.items() if k.endswith("_at")}
    if seen["cancelled_at"]:
        status = "cancelled"
    elif seen["delivered_at"]:
        status = "delivered"
    elif seen["picked_up_at"]:
        status = "picked_up"
    elif seen["accepted_at"]:
        status = "accepted"
    else:
        status = "placed"
    updated = max(v for v in seen.values() if v)
    return {
        **{k: v for k, v in order.items() if not k.endswith("_at")},
        "status": status,
        **{k: ts(v) for k, v in seen.items()},
        "updated_at": ts(updated),
    }


def generate(start: date, days: int, seed: int = 6, scale: float = 1.0) -> Iterator[tuple[date, dict[str, list[dict]]]]:
    world = initial_world(start, seed, scale)
    for offset in range(days):
        day = start + timedelta(days=offset)
        extract_end = datetime.combine(day + timedelta(days=1), time())
        touched: dict[str, dict[int, dict]] = {name: {} for name in COLUMNS}
        if offset == 0:
            touched["customers"].update(world.customers)
            touched["restaurants"].update(world.restaurants)
            touched["menu_items"].update(world.items)
            touched["couriers"].update(world.couriers)
        else:
            change_dimensions(world, day, touched)

        # Customers held back yesterday arrive today, with their original timestamps.
        for cid, customer in world.held_back.items():
            world.customers[cid] = customer
            touched["customers"][cid] = customer
        world.held_back = {}

        new_customers = []
        for _ in range(world.n(40)):
            customer = world.new_customer(day, world.at(day, 0, 10))
            new_customers.append(customer)
            # Every tenth sign-up reaches the warehouse one day late, after its first order.
            if customer["customer_id"] % 10 == 0:
                world.held_back[customer["customer_id"]] = customer
            else:
                world.customers[customer["customer_id"]] = customer
                touched["customers"][customer["customer_id"]] = customer

        lines: list[dict] = []
        buyers = list(world.customers.values())
        catalog = Catalog.of(world)
        for _ in range(world.n(2000)):
            customer = world.rng.choice(new_customers) if world.rng.random() < 0.02 else world.rng.choice(buyers)
            place_order(world, catalog, day, customer, lines)
        # Late sign-ups exist because they ordered before their record was synced.
        for customer in world.held_back.values():
            place_order(world, catalog, day, customer, lines)

        orders = []
        for order_id, order in list(world.open_orders.items()):
            row = order_row(order, extract_end)
            if row["updated_at"] >= ts(datetime.combine(day, time())):
                orders.append(row)
            if row["status"] in ("delivered", "cancelled"):
                del world.open_orders[order_id]
        orders += [dict(row) for row in world.rng.sample(orders, min(len(orders), world.n(5)))]

        yield day, {
            # Copies: the world keeps changing after this day's extract is taken.
            "customers": [dict(r) for r in touched["customers"].values()],
            "restaurants": [dict(r) for r in touched["restaurants"].values()],
            "menu_items": [dict(r) for r in touched["menu_items"].values()],
            "couriers": [dict(r) for r in touched["couriers"].values()],
            "orders": orders,
            "order_items": lines,
        }


def write_day(out: Path, day: date, tables: dict[str, list[dict]]) -> None:
    folder = out / f"day={day.isoformat()}"
    folder.mkdir(parents=True, exist_ok=True)
    for name, rows in tables.items():
        with (folder / f"{name}.csv").open("w", newline="", encoding="utf-8") as handle:
            writer = csv.DictWriter(handle, fieldnames=COLUMNS[name], extrasaction="ignore")
            writer.writeheader()
            writer.writerows(rows)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--start", type=date.fromisoformat, default=date(2025, 3, 3))
    parser.add_argument("--days", type=int, default=14)
    parser.add_argument("--seed", type=int, default=6)
    parser.add_argument("--scale", type=float, default=1.0)
    args = parser.parse_args(argv)

    for day, tables in generate(args.start, args.days, args.seed, args.scale):
        write_day(args.out, day, tables)
        print(day, " ".join(f"{name}={len(rows)}" for name, rows in tables.items()))
    return 0


if __name__ == "__main__":
    sys.exit(main())
