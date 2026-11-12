-- P09 alerts. Run as P09_OWNER after the first production dbt build created MARTS.FCT_CRYPTO_HOURLY.
-- One technical alert (data stopped arriving) and one business alert (a large hourly move).

USE ROLE P09_OWNER;
USE WAREHOUSE P09_WH;
USE DATABASE P09_MARKETS;

CREATE OR REPLACE ALERT OPS.ALERT_STALE_PRICES
  WAREHOUSE = P09_WH
  SCHEDULE = 'USING CRON 25 * * * * UTC'   -- 15 minutes after the hourly job (cron 10 * * * *)
  COMMENT = 'No hourly candle newer than 3 hours: extractor, load, or dbt stopped'
  IF (EXISTS (
    SELECT 1 FROM P09_MARKETS.MARTS.FCT_CRYPTO_HOURLY
    HAVING MAX(CANDLE_START) < DATEADD(hour, -3, SYSDATE())
  ))
  THEN
    CALL SYSTEM$SEND_EMAIL(
      'P09_EMAIL_INT',
      '<your-verified-email>',
      'P09: crypto prices are stale',
      'MARTS.FCT_CRYPTO_HOURLY has no candle in the last 3 hours. Check the scheduled pipeline run and dbt source freshness.'
    );

-- The action reads the rows that made the condition true, so the email lists the actual moves.
CREATE OR REPLACE ALERT OPS.ALERT_LARGE_MOVE
  WAREHOUSE = P09_WH
  SCHEDULE = 'USING CRON 25 * * * * UTC'
  COMMENT = 'An hourly return above 3 percent in either direction in the last closed hour'
  IF (EXISTS (
    SELECT PRODUCT_ID, CANDLE_START, ROUND(100 * HOURLY_RETURN, 2) AS PCT
    FROM P09_MARKETS.MARTS.FCT_CRYPTO_HOURLY
    -- Only the last closed hour: each move is reported once, and never on a partial candle.
    WHERE CANDLE_START = DATEADD(hour, -1, DATE_TRUNC(hour, SYSDATE())) AND ABS(HOURLY_RETURN) > 0.03
  ))
  THEN
    BEGIN
      LET moves STRING := (
        SELECT LISTAGG(PRODUCT_ID || ' ' || TO_CHAR(CANDLE_START, 'YYYY-MM-DD HH24:MI') || ' UTC: ' || PCT || '%', '\n')
        FROM TABLE(RESULT_SCAN(SNOWFLAKE.ALERT.GET_CONDITION_QUERY_UUID()))
      );
      CALL SYSTEM$SEND_EMAIL('P09_EMAIL_INT', '<your-verified-email>', 'P09: large crypto move', :moves);
    END;

ALTER ALERT OPS.ALERT_STALE_PRICES RESUME;
ALTER ALERT OPS.ALERT_LARGE_MOVE RESUME;
SHOW ALERTS IN SCHEMA OPS;
