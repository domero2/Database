--it show length and field type
DESC tabel_name;

--REFRESHING MV SCRIPT
BEGIN
DBMS_SNAPSHOT.REFRESH('Name here');
END;
--How checking database name in Oracle
select sys_context('userenv','instance_name') from dual;

--How check Service name (Usefull in cinnection setuping)

select SERVICE_NAME from gv$session where sid in (select sid from V$MYSTAT);




--HOW to update in select statement

UPDATE
    Table_A
SET
    Table_A.col1 = Table_B.col1,
    Table_A.col2 = Table_B.col2
FROM
    Some_Table AS Table_A
    INNER JOIN Other_Table AS Table_B
        ON Table_A.id = Table_B.id
WHERE
    Table_A.col3 = 'cool'
	
--Second way
UPDATE
    table_to_update,
    table_info
SET
    table_to_update.col1 = table_info.col1,
    table_to_update.col2 = table_info.col2

WHERE
    table_to_update.ID = table_info.ID
	
---Dodawanie partycji skryptem
  PARTITION BY RANGE ("ODS_CREATE_DT") INTERVAL (NUMTOYMINTERVAL(1,'MONTH')) 
 (PARTITION "OLD_TRADES"  VALUES LESS THAN (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))

--Dodawanie partycji
ALTER TABLE MXI3_T_TRADES_LDD ADD PARTITION 
 D20190509 VALUES LESS THAN (to_date('20190509','YYYYMMDD'));

------select constaint from table
SELECT cols.table_name, cols.column_name, cols.position, cons.status, cons.owner
FROM all_constraints cons, all_cons_columns cols
WHERE cols.table_name = 'CT1_T_TRADES_TRM'
AND cons.constraint_type = 'P'
AND cons.constraint_name = cols.constraint_name
AND cons.owner = cols.owner
ORDER BY cols.table_name, cols.position;

 ----------------------------- Query which show all the table name in database in special schema
 SELECT owner, table_name
  FROM dba_tables;
---------------------------------Monthly report in pl sql

select to_char(ODS_CREATE_DT, 'MM') AS MonthOfReport, sum(MSG_ID) AS SumValue
from AM1_T_TRADES_EXT
group by to_char(ODS_CREATE_DT, 'MM')
ORDER BY SumValue;
--------------------------------MERGE
MERGE INTO bonuses D
   USING (SELECT employee_id, salary, department_id FROM employees
   WHERE department_id = 80) S
   ON (D.employee_id = S.employee_id)
   WHEN MATCHED THEN UPDATE SET D.bonus = D.bonus + S.salary*.01
     DELETE WHERE (S.salary > 8000)
   WHEN NOT MATCHED THEN INSERT (D.employee_id, D.bonus)
     VALUES (S.employee_id, S.salary*.01)
     WHERE (S.salary <= 8000);