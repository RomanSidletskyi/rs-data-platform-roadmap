# Assumptions

This reference example uses the following business assumptions:

- revenue comes only from orders with `status IN ('paid', 'completed')`
- cancelled orders do not contribute to revenue
- refunds are ignored in the base example and should be added explicitly if modeled
- retention is measured on event activity, not on order placement
- funnel counts distinct users per step, not raw event counts
- top-product revenue is computed from line-item grain, not from order totals
