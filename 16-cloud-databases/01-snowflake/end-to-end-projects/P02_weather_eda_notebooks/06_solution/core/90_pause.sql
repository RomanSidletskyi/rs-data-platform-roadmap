-- P02 pause: suspend the warehouse. Data, views, and the notebook stay. Run as P02_OWNER.
-- A notebook session that is still open resumes the warehouse on its next query: end it in Snowsight first.

USE ROLE P02_OWNER;

ALTER WAREHOUSE P02_WH SUSPEND;

SHOW WAREHOUSES LIKE 'P02_WH';
