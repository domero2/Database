
CREATE MATERIALIZED VIEW "KOKO"."MV_TABLA"
BUILD IMMEDIATE 
REFRESH FAST 
--START WITH sysdate+0 NEXT SYSDATE + 1/60/60/24
WITH ROWID 
USING DEFAULT LOCAL ROLLBACK SEGMENT
USING ENFORCED CONSTRAINTS 
DISABLE QUERY REWRITE
AS SELECT * FROM "TABLEE"@"DBLINK_NAME" "TABLEE";

GRANT SELECT ON  "KOKO"."MV_TABLA" TO ikolok;