-- P11 pause after a session. Run as P11_OWNER. Stop the cloud schedule separately:
--   Azure: az functionapp stop --name "$P11_FUNCTION_APP" --resource-group "$P11_RG"
--   AWS:   aws scheduler update-schedule ... --state DISABLED (see aws/02_deploy_lambda.sh)
-- Pipes keep loading what lands; with the schedule stopped nothing lands.

USE ROLE P11_OWNER;
USE DATABASE P11_MARKETS;

ALTER TASK OPS.BUILD_MARKETS SUSPEND;
ALTER WAREHOUSE P11_WH SUSPEND;
ALTER WAREHOUSE P11_BI_WH SUSPEND;

-- Who used the BI warehouse in the last day: Power BI tags its queries.
SELECT USER_NAME, COUNT(*) AS QUERIES, ROUND(SUM(TOTAL_ELAPSED_TIME) / 1000, 1) AS ELAPSED_SECONDS, ANY_VALUE(QUERY_TAG) AS SAMPLE_TAG
FROM TABLE(P11_MARKETS.INFORMATION_SCHEMA.QUERY_HISTORY_BY_WAREHOUSE(
  WAREHOUSE_NAME => 'P11_BI_WH', END_TIME_RANGE_START => DATEADD(day, -1, CURRENT_TIMESTAMP()), RESULT_LIMIT => 10000))
GROUP BY USER_NAME
ORDER BY QUERIES DESC;
