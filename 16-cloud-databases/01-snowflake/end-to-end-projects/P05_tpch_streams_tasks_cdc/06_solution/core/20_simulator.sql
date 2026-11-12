-- P05 change simulator: one call = one business day in the order system. Run as P05_OWNER.
-- Usage: CALL OPS.SIMULATE_DAY();  or  CALL OPS.SIMULATE_DAY(400, 10);

USE ROLE P05_OWNER;
USE WAREHOUSE P05_WH;
USE DATABASE P05_CDC;

CREATE OR REPLACE PROCEDURE OPS.SIMULATE_DAY(UPDATES NUMBER DEFAULT 200, CANCELS NUMBER DEFAULT 5)
RETURNS STRING
LANGUAGE SQL
COMMENT = 'Next day of real TPC-H orders, plus fulfilments, discount corrections, customer edits, and cancellations'
AS
$$
DECLARE
  next_day   DATE;
  cancelled  NUMBER DEFAULT 0;
  new_orders NUMBER DEFAULT 0;
  new_lines  NUMBER DEFAULT 0;
  fulfilled  NUMBER DEFAULT 0;
  corrected  NUMBER DEFAULT 0;
  customers  NUMBER DEFAULT 0;
  summary    STRING;
BEGIN
  SELECT DATEADD(day, 1, MAX(O_ORDERDATE)) INTO :next_day FROM SRC.ORDERS;
  IF (next_day > '1998-08-02') THEN
    RETURN 'TPC-H has no orders after 1998-08-02; reset with teardown and setup to replay again';
  END IF;

  -- One transaction: an order and its lines become visible to the streams together.
  BEGIN TRANSACTION;

  -- Cancellations: lines first, then orders. The same deterministic choice is evaluated twice.
  DELETE FROM SRC.LINEITEM WHERE L_ORDERKEY IN (
    SELECT O_ORDERKEY FROM SRC.ORDERS
    WHERE O_ORDERSTATUS = 'O' AND O_ORDERDATE >= DATEADD(day, -30, :next_day)
    QUALIFY ROW_NUMBER() OVER (ORDER BY HASH(O_ORDERKEY, :next_day)) <= :cancels
  );
  DELETE FROM SRC.ORDERS WHERE O_ORDERKEY IN (
    SELECT O_ORDERKEY FROM SRC.ORDERS
    WHERE O_ORDERSTATUS = 'O' AND O_ORDERDATE >= DATEADD(day, -30, :next_day)
    QUALIFY ROW_NUMBER() OVER (ORDER BY HASH(O_ORDERKEY, :next_day)) <= :cancels
  );
  cancelled := SQLROWCOUNT;

  INSERT INTO SRC.ORDERS
  SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS WHERE O_ORDERDATE = :next_day;
  new_orders := SQLROWCOUNT;

  INSERT INTO SRC.LINEITEM
  SELECT l.*
  FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM l
  JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS o ON o.O_ORDERKEY = l.L_ORDERKEY
  WHERE o.O_ORDERDATE = :next_day;
  new_lines := SQLROWCOUNT;

  -- Older open orders get fulfilled.
  UPDATE SRC.ORDERS SET O_ORDERSTATUS = 'F'
  WHERE O_ORDERKEY IN (
    SELECT O_ORDERKEY FROM SRC.ORDERS
    WHERE O_ORDERSTATUS = 'O' AND O_ORDERDATE < DATEADD(day, -30, :next_day)
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= :updates
  );
  fulfilled := SQLROWCOUNT;

  -- Late corrections: discounts change on recent lines, so revenue of past days changes too.
  UPDATE SRC.LINEITEM SET L_DISCOUNT = LEAST(L_DISCOUNT + 0.01, 0.10)
  WHERE (L_ORDERKEY, L_LINENUMBER) IN (
    SELECT l.L_ORDERKEY, l.L_LINENUMBER
    FROM SRC.LINEITEM l
    JOIN SRC.ORDERS o ON o.O_ORDERKEY = l.L_ORDERKEY
    WHERE o.O_ORDERDATE >= DATEADD(day, -60, :next_day)
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= :updates / 4
  );
  corrected := SQLROWCOUNT;

  UPDATE SRC.CUSTOMER
  SET C_ACCTBAL    = C_ACCTBAL + UNIFORM(-500, 500, RANDOM()),
      C_MKTSEGMENT = IFF(UNIFORM(0, 9, RANDOM()) = 0, 'AUTOMOBILE', C_MKTSEGMENT)
  WHERE C_CUSTKEY IN (
    SELECT C_CUSTKEY FROM SRC.CUSTOMER
    QUALIFY ROW_NUMBER() OVER (ORDER BY RANDOM()) <= :updates / 2
  );
  customers := SQLROWCOUNT;

  COMMIT;

  summary := 'day ' || next_day::STRING || ': +' || new_orders || ' orders, +' || new_lines || ' lines, '
          || fulfilled || ' fulfilled, ' || corrected || ' lines corrected, ' || customers || ' customers updated, '
          || cancelled || ' orders cancelled';
  INSERT INTO OPS.RUN_LOG SELECT CURRENT_TIMESTAMP(), NULL, 'SIMULATE_DAY', :new_orders, :summary;
  RETURN summary;
EXCEPTION
  WHEN OTHER THEN
    ROLLBACK;
    RAISE;
END;
$$;
