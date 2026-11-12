-- P03 pause: suspend the warehouse. Data and the app stay; opening the app resumes the warehouse. Run as P03_OWNER.

USE ROLE P03_OWNER;

ALTER WAREHOUSE P03_WH SUSPEND;

SHOW WAREHOUSES LIKE 'P03_WH';
