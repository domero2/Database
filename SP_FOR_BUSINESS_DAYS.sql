/*Stored procedure used to count working day, considering Holiday days which are stored in special TABLE HOLIDAYS_TABLE
We could specify if we need get last working day or next working day WHERE HOLIDAY_DATE = V_BUS_DAY + RNUM );
V_BUS_DAY := V_BUS_DAY - V_CNT;.  */

CREATE OR REPLACE FUNCTION EE.SUB_BUS_DAYS(
P_DATE IN DATE 
,P_ADD_NUM IN INTEGER 
) RETURN DATE AS
-- 
V_CNT NUMBER;
V_BUS_DAY DATE := TRUNC(P_DATE);
-- 
BEGIN
-- 
SELECT MAX(RNUM)
INTO V_CNT
FROM (SELECT ROWNUM RNUM
FROM ALL_OBJECTS)
WHERE ROWNUM <= P_ADD_NUM
AND TO_CHAR(V_BUS_DAY - RNUM, 'DY' ) NOT IN ('SAT', 'SUN')
AND NOT EXISTS
( SELECT 1
FROM HOLIDAYS_TABLE
WHERE HOLIDAY_DATE = V_BUS_DAY + RNUM );
V_BUS_DAY := V_BUS_DAY - V_CNT;
-- 
RETURN V_BUS_DAY;
-- 
END SUB_BUS_DAYS;
