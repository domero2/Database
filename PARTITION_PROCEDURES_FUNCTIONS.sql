CREATE OR REPLACE FUNCTION TUCEL002.GET_YEAR_MONTH_DAY (P_DATE IN DATE) 
    RETURN VARCHAR2 
  IS
  BEGIN
    IF P_DATE IS NULL THEN
      RETURN NULL;
    END IF;
    RETURN TO_CHAR(P_DATE, 'YYYYMMDD');
  END;


CREATE OR REPLACE FUNCTION TUCEL002.ADD_PARTITION(P_TABLE_NAME IN VARCHAR2, P_DATE_YYYYMMDD IN VARCHAR2) 
    RETURN VARCHAR2
  IS
    V_CNT              INTEGER;
    V_STATEMENT        VARCHAR2(1000);
    V_STATEMENT2       VARCHAR2(1000);
    V_UPPER_BOUND      VARCHAR2(16);
    G_ERR_CODE_NULL_IN_PARAM INTEGER := -20001;
  BEGIN
    $IF $$DEBUG_ON $THEN
      V_STATEMENT2 := 'ADD_PARTITION('''||P_TABLE_NAME||''','''||P_DATE_YYYYMMDD||''')';
      DBMS_OUTPUT.PUT_LINE(V_STATEMENT2);
      LOGGER.LOG_DEBUG($$PLSQL_UNIT, $$PLSQL_LINE, V_STATEMENT2);
    $END
    IF P_TABLE_NAME IS NULL OR P_DATE_YYYYMMDD IS NULL THEN
      V_STATEMENT := 'NULL input params are not allowed : table<'||P_TABLE_NAME||'>, date<'||P_DATE_YYYYMMDD||'>';
      LOGGER.LOG_ERROR($$PLSQL_UNIT, $$PLSQL_LINE,
                                     V_STATEMENT2,
                                     G_ERR_CODE_NULL_IN_PARAM);
      RAISE_APPLICATION_ERROR(G_ERR_CODE_NULL_IN_PARAM, V_STATEMENT2);
    END IF;
    select count(1)
      into v_cnt
      from ALL_TAB_PARTITIONS
     WHERE TABLE_OWNER=USER
       AND TABLE_NAME=P_TABLE_NAME
       AND PARTITION_NAME='D'||P_DATE_YYYYMMDD;
       
    IF V_CNT = 0 THEN
      V_UPPER_BOUND := GET_YEAR_MONTH_DAY(TO_DATE(P_DATE_YYYYMMDD, 'YYYYMMDD')+1);
      V_STATEMENT := 'ALTER TABLE '||P_TABLE_NAME||' ADD PARTITION D'||P_DATE_YYYYMMDD||
                     ' VALUES LESS THAN (to_date('''||V_UPPER_BOUND||''', ''YYYYMMDD''))';
      EXECUTE IMMEDIATE V_STATEMENT;
      RETURN NULL;
    ELSE
      V_STATEMENT2 := 'Partition D'||P_DATE_YYYYMMDD||' in table '||P_TABLE_NAME||' already exists';
      LOGGER.LOG_WARN($$PLSQL_UNIT, $$PLSQL_LINE,
                                    V_STATEMENT2);
      RETURN V_STATEMENT2;
    END IF;
  END;
  
  
CREATE OR REPLACE PROCEDURE TUCEL002.ADD_PARTITION_IF_NOT_EXISTS(P_TABLE_NAME IN VARCHAR2, P_DATE IN DATE) 
  IS
    V_STATEMENT2    varchar2(200) := 'NULL input params are not allowed : table<'||P_TABLE_NAME||'>, date<'||GET_YEAR_MONTH_DAY(P_DATE)||'>';
    P_DATE_STRING   VARCHAR2(100);
    P_DATE_RET_STRING   VARCHAR2(100);
    V_RET          VARCHAR2(100);
    G_ERR_CODE_NULL_IN_PARAM INTEGER := -20001;
  
  BEGIN
    IF P_TABLE_NAME IS NULL OR P_DATE IS NULL THEN
      LOGGER.LOG_ERROR($$PLSQL_UNIT, $$PLSQL_LINE,
                                     V_STATEMENT2,
                                     G_ERR_CODE_NULL_IN_PARAM);
      RAISE_APPLICATION_ERROR(g_ERR_CODE_NULL_IN_PARAM, V_STATEMENT2);
    END IF;
   
    P_DATE_STRING := GET_YEAR_MONTH_DAY(P_DATE);
    SELECT (SELECT PARTITION_NAME FROM ALL_TAB_PARTITIONS 
          WHERE TABLE_OWNER=USER AND 
          TABLE_NAME = P_TABLE_NAME AND 
          PARTITION_NAME LIKE '%' || P_DATE_STRING) INTO P_DATE_RET_STRING FROM DUAL;
         
    IF P_DATE_RET_STRING IS NULL THEN
      V_RET := ADD_PARTITION(P_TABLE_NAME, GET_YEAR_MONTH_DAY(P_DATE));
  
    END IF;
  END;

 /*To checking if there are some higher date(in source table) in partitoin column which is ACTUAL_DATE in our case. I have modified GET_YEAR_MONTH_DAY*/ 
 
	create or replace FUNCTION GET_YEAR_MONTH_DAY(P_DATE IN DATE) 
RETURN VARCHAR2 
IS
v_Date1 date;
v_Date VARCHAR2(20);
BEGIN
 select to_date(to_char(MAX(to_date(actual_date,'YYYY-MM-DD')),'YYYYMMDD'),'YYYYMMDD') 
   INTO v_Date1 FROM (select distinct actual_date from MXI3_T_TRADES_RAW);
      IF P_DATE IS NULL THEN
      RETURN NULL;
     ELSIF v_Date1 > P_DATE THEN
      v_Date := TO_CHAR(v_DATE1, 'YYYYMMDD');
    ELSE
    v_Date := TO_CHAR(P_DATE, 'YYYYMMDD');
    END IF;
 RETURN v_DATE;
  END;

/*	
Note that LOGGER.LOG_WARN, LOGGER.LOG_ERROR 
can cause the problems if we don't install LOGGER package.
LOGGER PACKAGE avaliable in LOGGER.sql script 
*/
