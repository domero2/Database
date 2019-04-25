create or replace PACKAGE LOGGER as
/*==============================================================*/
/* Database package: LOGGER                                     */
/* Description: Logging tools on Oracle DB                      */
/*==============================================================*/
   procedure LOG_ERROR (P_PROCESS_NAME IN VARCHAR2,P_LINE_NUMBER IN INTEGER default NULL,P_MESSAGE IN VARCHAR2,P_ORA_ERR_CODE IN VARCHAR2 default NULL);
   procedure LOG_INFO (P_PROCESS_NAME IN VARCHAR2,P_LINE_NUMBER IN INTEGER default NULL,P_MESSAGE IN VARCHAR2);
   procedure LOG_WARN (P_PROCESS_NAME IN VARCHAR2,P_LINE_NUMBER IN INTEGER default NULL,P_MESSAGE IN VARCHAR2);
   procedure LOG_DEBUG (P_PROCESS_NAME IN VARCHAR2,P_LINE_NUMBER IN INTEGER default NULL,P_MESSAGE IN VARCHAR2);
end LOGGER;


create or replace PACKAGE BODY LOGGER as
   procedure LOG_MESSAGE (P_DATE IN DATE default SYSDATE,P_LOG_TYPE IN VARCHAR2,P_SID IN VARCHAR2 default sys_context('USERENV', 'SID'),P_ORA_ERR_CODE IN VARCHAR2 default NULL,P_PROCESS_NAME IN VARCHAR2,P_LINE_NUMBER IN INTEGER default NULL,P_MESSAGE IN VARCHAR2);
   procedure LOG_ERROR (P_PROCESS_NAME IN VARCHAR2,P_LINE_NUMBER IN INTEGER default NULL,P_MESSAGE IN VARCHAR2,P_ORA_ERR_CODE IN VARCHAR2 default NULL) as
   BEGIN
       LOG_MESSAGE(p_log_type => 'ERROR', 
                   p_line_number => p_line_number,
                   p_process_name => p_process_name, 
                   p_ora_err_code => P_ORA_ERR_CODE,
                   p_message => p_message);
     END LOG_ERROR;
   procedure LOG_INFO (P_PROCESS_NAME IN VARCHAR2,P_LINE_NUMBER IN INTEGER default NULL,P_MESSAGE IN VARCHAR2) as
   BEGIN
       LOG_MESSAGE(p_log_type => 'INFO', 
                   p_line_number => p_line_number, 
                   p_process_name => p_process_name,
                   p_message => p_message);
     END LOG_INFO;
   procedure LOG_WARN (P_PROCESS_NAME IN VARCHAR2,P_LINE_NUMBER IN INTEGER default NULL,P_MESSAGE IN VARCHAR2) as
   BEGIN
       LOG_MESSAGE(p_log_type => 'WARN', 
                   p_line_number => p_line_number, 
                   p_process_name => p_process_name,
                   p_message => p_message);
     END LOG_WARN;
   procedure LOG_DEBUG (P_PROCESS_NAME IN VARCHAR2,P_LINE_NUMBER IN INTEGER default NULL,P_MESSAGE IN VARCHAR2) as
   BEGIN
       LOG_MESSAGE(p_log_type => 'DEBUG', 
                   p_line_number => p_line_number, 
                   p_process_name => p_process_name,
                   p_message => p_message);
     END LOG_DEBUG;
   procedure LOG_MESSAGE (P_DATE IN DATE default SYSDATE,P_LOG_TYPE IN VARCHAR2,P_SID IN VARCHAR2 default sys_context('USERENV', 'SID'),P_ORA_ERR_CODE IN VARCHAR2 default NULL,P_PROCESS_NAME IN VARCHAR2,P_LINE_NUMBER IN INTEGER default NULL,P_MESSAGE IN VARCHAR2) as
   PRAGMA AUTONOMOUS_TRANSACTION;
     BEGIN
       INSERT INTO DB_LOG(LOG_DATE, 
                          LOG_TYPE, 
                          PROCESS, 
                          LINE,
                          SESSION_ID, 
                          ORA_ERR_CODE, 
                          LOG_MESSAGE) 
                   VALUES(p_date, 
                          P_LOG_TYPE, 
                          P_PROCESS_NAME,
                          p_line_number,
                          P_SID, 
                          P_ORA_ERR_CODE,
                          P_MESSAGE);
       COMMIT;
     END LOG_MESSAGE;
END LOGGER;


--DDL FOR DB_LOG table 