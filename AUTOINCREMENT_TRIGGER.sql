CREATE TABLE example (
  ID           NUMBER(10)    NOT NULL,
  DESCR  VARCHAR2(50)  NOT NULL);

ALTER TABLE example ADD (
  CONSTRAINT exp_pk PRIMARY KEY (ID));

CREATE SEQUENCE exp_seq START WITH 1;

CREATE OR REPLACE TRIGGER dept_bir 
BEFORE INSERT ON example 
FOR EACH ROW

BEGIN
  SELECT exp_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;
-----OR in Oracle 11g
 CREATE OR REPLACE TRIGGER dept_bir 
BEFORE INSERT ON example 
FOR EACH ROW

BEGIN
:new.ID := exp_seq.NEXTVAL;
END;


-----Oracle 12c
create table t1 (
    c1 NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    c2 VARCHAR2(10)
    );
	
---OR

CREATE SEQUENCE examp_seq START WITH 1;

CREATE TABLE example (
  ID           NUMBER(10)    DEFAULT examp_seq.nextval NOT NULL,
  DESCR  VARCHAR2(50)  NOT NULL);

ALTER TABLE example ADD (
  CONSTRAINT examp_pk PRIMARY KEY (ID));