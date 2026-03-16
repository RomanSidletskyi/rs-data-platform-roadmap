# Azure SQL Stored Procedures

Azure SQL Database supports T-SQL stored procedures.

## Simple Procedure

```sql
CREATE PROCEDURE GetCustomerOrders
    @customer_id INT
AS
BEGIN
    SELECT *
    FROM orders
    WHERE customer_id = @customer_id;
END;
```

## Execute

```sql
EXEC GetCustomerOrders @customer_id = 100;
```

## Update Procedure

```sql
CREATE PROCEDURE UpdateOrderStatus
    @order_id INT,
    @status VARCHAR(50)
AS
BEGIN
    UPDATE orders
    SET status = @status
    WHERE order_id = @order_id;
END;
```

## Why Important

Stored procedures are useful for:

- business logic
- data validation
- transaction control
- stable data access contracts
