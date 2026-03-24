db.orders.findOne(
  { order_id: 101 },
  {
    _id: 0,
    order_id: 1,
    order_date: 1,
    status: 1,
    amount: 1,
    customer_snapshot: 1,
    items: 1,
    payment: 1
  }
);

db.orders.find(
  { user_id: 10 },
  {
    _id: 0,
    order_id: 1,
    order_date: 1,
    amount: 1,
    status: 1
  }
).sort({ order_date: -1 });

db.orders.aggregate([
  { $unwind: "$items" },
  {
    $group: {
      _id: {
        product_id: "$items.product_id",
        product_name: "$items.product_name"
      },
      total_sales: {
        $sum: {
          $multiply: ["$items.quantity", "$items.item_price"]
        }
      }
    }
  },
  { $sort: { total_sales: -1 } }
]);
