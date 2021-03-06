/*
Autoamtically partitionig by days using Orcale stuff, with default values
in logging ect.
*/
PARTITION BY RANGE ("ODS_CREATE_DT") INTERVAL
	(NUMTOYMINTERVAL(1,'DAY'))
	(PARTITION "OLD_TRADES"  VALUES LESS THAN (TO_DATE('2011-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS',
		'NLS_CALENDAR=GREGORIAN')))
		
/*
Automatically partitionig by range (days) with specified  BUFFER_POOL ect.
*/		
PARTITION BY RANGE (ACTUAL_DATE) 
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
  PARTITION D20190101 VALUES LESS THAN (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
  LOGGING 
  PCTFREE 10 
  INITRANS 1 
  STORAGE 
  ( 
    INITIAL 65536 
    NEXT 1048576 
    MINEXTENTS 1 
    MAXEXTENTS UNLIMITED 
    BUFFER_POOL DEFAULT 
  ) 
  NOCOMPRESS
);