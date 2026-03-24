# Solutions: Table Operations And Change Patterns

## Task 1

`MERGE` is healthier if the table represents latest customer state by `customer_id`, because inserts and updates both matter and reruns should preserve one current row per customer. Append-only is weaker if it leaves several conflicting versions of the same entity without a clear contract.

## Task 2

Bounded overwrite is healthier because it limits risk and cost to the affected slice. Full overwrite rewrites healthy data together with broken data, increases compute cost, and can widen the blast radius of mistakes.

## Task 3

`order_date` is a more natural partition candidate than `store_id` because it usually supports both pruning and bounded repair. High-cardinality keys are weak partition choices because they often create too many partitions and maintenance pain. `store_id` may still matter for layout tuning, but not necessarily as the partition key.

## Task 4

CDC latest-state loading asks which record should become the current truth. SCD thinking asks whether consumers need previous truth states too. The key design question is not only that data changes, but whether the product is a current-state table or a history-preserving table.
