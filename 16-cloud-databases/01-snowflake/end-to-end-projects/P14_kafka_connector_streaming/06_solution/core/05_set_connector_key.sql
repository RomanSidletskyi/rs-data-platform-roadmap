-- P14 set or rotate the connector service user's public key. Run as ACCOUNTADMIN via run_sql.sh.
-- Rotation without downtime: set RSA_PUBLIC_KEY_2, switch the connector to the new private key, then unset the old one.

USE ROLE ACCOUNTADMIN;
ALTER USER P14_KAFKA_SVC SET RSA_PUBLIC_KEY = '<connector-public-key>';
DESC USER P14_KAFKA_SVC;
