-- P05 comparison: the same daily revenue as two chained dynamic tables. Run as P05_OWNER after 30_task_graph.sql.
-- They refresh on P05_WH, so they cost warehouse time. Suspend them when the comparison is done (90_pause.sql).

USE ROLE P05_OWNER;
USE WAREHOUSE P05_WH;
USE DATABASE P05_CDC;

-- Order grain first, then day grain: each step stays simple enough for incremental refresh.
CREATE OR REPLACE DYNAMIC TABLE MART.DT_ORDER
  TARGET_LAG = DOWNSTREAM
  WAREHOUSE = P05_WH
  REFRESH_MODE = INCREMENTAL
  COMMENT = 'Order grain, same logic as CORE.V_ORDER_CURRENT'
AS
SELECT
  o.O_ORDERKEY    AS ORDER_KEY,
  o.O_ORDERDATE   AS ORDER_DATE,
  o.O_ORDERSTATUS AS ORDER_STATUS,
  COUNT(l.L_LINENUMBER)                                    AS LINE_COUNT,
  COALESCE(SUM(l.L_EXTENDEDPRICE), 0)                      AS GROSS_AMOUNT,
  COALESCE(SUM(l.L_EXTENDEDPRICE * (1 - l.L_DISCOUNT)), 0) AS NET_REVENUE
FROM SRC.ORDERS o
LEFT JOIN SRC.LINEITEM l ON l.L_ORDERKEY = o.O_ORDERKEY
GROUP BY 1, 2, 3;

CREATE OR REPLACE DYNAMIC TABLE MART.DT_DAILY_REVENUE
  TARGET_LAG = '15 minutes'
  WAREHOUSE = P05_WH
  REFRESH_MODE = INCREMENTAL
  COMMENT = 'Day grain; compare with MART.DAILY_REVENUE maintained by tasks'
AS
SELECT
  ORDER_DATE,
  COUNT(*)                    AS ORDERS,
  COUNT_IF(ORDER_STATUS = 'O') AS OPEN_ORDERS,
  SUM(LINE_COUNT)             AS LINES,
  SUM(GROSS_AMOUNT)           AS GROSS_AMOUNT,
  SUM(NET_REVENUE)            AS NET_REVENUE
FROM MART.DT_ORDER
GROUP BY ORDER_DATE;

-- If REFRESH_MODE shows FULL or creation fails, read the reason: some constructs prevent incremental refresh.
SHOW DYNAMIC TABLES IN SCHEMA MART;
SELECT "name", "target_lag", "refresh_mode", "refresh_mode_reason", "scheduling_state"
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
