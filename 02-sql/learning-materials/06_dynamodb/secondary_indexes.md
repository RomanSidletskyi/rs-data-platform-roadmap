
cat <<'EOF' > "$MODULE/learning-materials/06_dynamodb/query_patterns.md" <<'EOF'
# DynamoDB Query Patterns

DynamoDB queries are key-oriented.

## Get item by primary key

```python
table.get_item(
    Key={
        "pk": "CUSTOMER#10",
        "sk": "PROFILE#10"
    }
)
```

## Query all orders for customer

```python
table.query(
    KeyConditionExpression=
        Key("pk").eq("CUSTOMER#10") &
        Key("sk").begins_with("ORDER#")
)
```

## Query latest orders for customer

```python
table.query(
    KeyConditionExpression=
        Key("pk").eq("CUSTOMER#10") &
        Key("sk").begins_with("ORDER#"),
    ScanIndexForward=False,
    Limit=10
)
```

## Query through GSI

```python
table.query(
    IndexName="GSI1",
    KeyConditionExpression=
        Key("gsi1pk").eq("PRODUCT#1001")
)
```

## Main Rule

If a query cannot be expressed through PK/SK or a designed index, the schema is probably wrong for that workload.
