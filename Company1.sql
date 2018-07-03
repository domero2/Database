--Set the server to output the result
SET SERVEROUTPUT ON;

DECLARE 
--DECLARE VARIABLES
    VNumber NUMBER(4);
    vChar CHAR(10);
BEGIN

--TELL THE USER THAT EVERYTHING IS WORKING
DBMS_OUTPUT.PUT_LINE('Compiled declarations succesfully');
END;

SET SERVEROUTPUT ON;

DECLARE 
--DECLARE VARIABLES
    nSalary NUMBER(4);
    cSSN CHAR(10);
    vLName VARCHAR2(15);
    VFName Date;
BEGIN

--TELL THE USER THAT EVERYTHING IS WORKING
DBMS_OUTPUT.PUT_LINE('Compiled declarations succesfully');
END;
SET SERVEROUTPUT ON;

DECLARE 
--DECLARE VARIABLES
    cMinSalary Constant NUMBER(6) := 15000;
    cMaxSalary Constant NUMBER(6) :=99000 ;
    nSalary NUMBER(6) Default 25000;
    cSSN CHAR(8) := '1-22-333';
    vLName VARCHAR2(15) Not null := 'Smith';
    VFName VARCHAR2(15) := 'John';
BEGIN

--TELL THE USER THAT EVERYTHING IS WORKING
DBMS_OUTPUT.PUT_LINE('Name: ' || vFName ||' '||vLName);
DBMS_OUTPUT.PUT_LINE('SSN: ' || cSSN);
DBMS_OUTPUT.PUT_LINE('Salary: $ ' || nSalary);
DBMS_OUTPUT.PUT_LINE('');
DBMS_OUTPUT.PUT_LINE('Minimum: $ ' || cMinSalary);
DBMS_OUTPUT.PUT_LINE('Maximum: $ ' || cMaxSalary);
END;

SET SERVEROUTPUT ON;
DECLARE 
x_salary employee.salary%TYPE;
x_last employee.lname%TYPE;

BEGIN
select salary, lname
into x_salary, x_last 
from EMPLOYEE
Where SSN = '999887777';

DBMS_OUTPUT.put_line(x_last || ' salaray is $ ' || x_salary);

END;
------------------------ROWTYPE
SET SERVEROUTPUT ON;
DECLARE 
rowEmp1 employee%ROWTYPE;
rowEmp2 employee%ROWTYPE;

BEGIN
rowEmp1.lname :='Doe';
rowEmp1.fname :='John';

rowEmp2.lname := 'Doe';
rowEmp2.fname := 'Jane';

DBMS_OUTPUT.put_line('Row 1 is ' || rowEmp1.lname ||', ' || rowEmp1.fname);
END;
SET SERVEROUTPUT ON;
DECLARE 
x_emp employee%ROWTYPE;
BEGIN
select fname, lname, sex, salary
into x_emp.fname, x_emp.lname, x_emp.sex, x_emp.salary
from EMPLOYEE
where SSN = '333445555';

DBMS_OUTPUT.put_line(x_emp.fname ||' '|| x_emp.lname || ' salary is'||x_emp.salary);
END;
------------------------table------------------------------
SET SERVEROUTPUT ON;
DECLARE
--Declare the table
TYPE EmpSSNarray
IS TABLE OF employee.ssn%TYPE
INDEX BY SIMPLE_INTEGER;
--Declare variables using the table
ManagementList EmpSSNarray;
WorkerList EmpSSNarray;
BEGIN
--Retrieve the first Supervisor
Select superssn
INTO ManagementList(1)
FROM employee
WHERE superssn is not null
AND ROWNUM <=1;

--retrieve the second Supervisor
Select superssn
INTO ManagementList(2)
FROM employee
Where superssn is not null
and ROWNUM <=1
and superssn <> ManagementList(1);
--retrieve the first Worker
Select essn
into WorkerList(1)
from works_on
where hours is not null
and rownum <= 1
and essn not in (ManagementList(1), ManagementList(2));
-- retrieve the second Worker 
Select essn
into WorkerList(2)
from works_on
where hours is not null
and rownum <= 1
and essn not in (ManagementList(1), ManagementList(2), WorkerList(1));
--output result
dbms_output.put_line('Managers are: '||ManagementList(1)||', '||ManagementList(2));
dbms_output.put_line('Workers are: '||WorkerList(1)||', '||WorkerList(2));
end;
---------------------------Record-----------------------------
SET SERVEROUTPUT ON;
DECLARE 
TYPE EmpRecord
   IS RECORD(ssn  employee.ssn%TYPE,
            LName  employee.lname%TYPE,
            DName  department.DName%TYPE,
            BonusPayment  NUMBER(6)
            );
    ActiveEmp EmpRecord;
    InactiveEmp EmpRecord; 
BEGIN
--Retrieve the Active employee detail (5000 - BonusPayment
select essn, LName, DName, 5000
INTO ActiveEmp
FROM employee, department, works_on
Where employee.dno = department.dnumber
AND employee.ssn = WORKS_ON.ESSN
AND hours = (Select MAX(hours)from works_on)
AND ROWNUM <= 1;
--Output active
dbms_output.put_line('Active employee name: '|| ActiveEmp.LName);
dbms_output.put_line('Active employee department: '|| ActiveEmp.DName);
dbms_output.put_line('Active employee bonus: $ '|| ActiveEmp.BonusPayment);
--Retrieve the Inactive employee detail
select essn, LName, DName, 0
INTO InactiveEmp
FROM employee, department, works_on
Where employee.dno = department.dnumber
AND employee.ssn = WORKS_ON.ESSN
AND hours = (Select Min(hours)from works_on)
AND ROWNUM <= 1;
--Output inactive
dbms_output.put_line('Inactive employee name: '|| InactiveEmp.LName);
dbms_output.put_line('Inactive employee department: '|| InactiveEmp.DName);
dbms_output.put_line('Inactive employee bonus: $ '|| InactiveEmp.BonusPayment);
END;
-----------------User Define
SET SERVEROUTPUT ON;
DECLARE 
TYPE BonusCompensation
   IS RECORD(CashPayment NUMBER(6),
            CompanyCar   BOOLEAN,
            VacationWeeks NUMBER(2)
            );
--Extended type declaration
TYPE EmpRecord
   IS RECORD(ssn  employee.ssn%TYPE,
            LName  employee.lname%TYPE,
            DName  department.DName%TYPE,
            BonusPayment  BonusCompensation
            );
--Another extended type declaration along with the instance declaration
TYPE ManagerRecord
    IS RECORD(ssn employee.ssn%TYPE,
        BonusPayment BonusCompensation
        );
--Instance declaration
BestEmp EmpRecord;
BestManager ManagerRecord;
BEGIN

--Store database value within the record instance
select essn, LName, DName
INTO BestEmp.ssn,
    BestEmp.LName,
    BestEmp.DName
FROM employee, department, works_on
Where employee.dno = department.dnumber
AND employee.ssn = WORKS_ON.ESSN
AND hours = (Select MAX(hours)from works_on)
AND ROWNUM <= 1;
--The next segment of code access the values within the record instance
BestEmp.BonusPayment.CashPayment := 5000;
BestEmp.BonusPayment.CompanyCar := TRUE; 
BestEmp.BonusPayment.VacationWeeks := 1; 
--outputs
dbms_output.put_line('Best employee name: ' || BestEmp.LName);
dbms_output.put_line('Best employee department: ' || BestEmp.DName);
dbms_output.put_line('Best employee bonus: $ ' || BestEmp.BonusPayment.CashPayment);
--Logical test Emp (IF) for company Car
IF BestEmp.BonusPayment.CompanyCar = True THEN
dbms_output.put_line('Company Car also provided');
END IF;
--Test for vacation weeks
IF BestEmp.BonusPayment.VacationWeeks >0 THEN
dbms_output.put_line('Extra vacation weeks granted: ' || BestEmp.BonusPayment.VacationWeeks);
END IF;
-- Now select the Manager information
Select ssn
INTO BestManager.ssn
FROM employee, department
WHERE employee.ssn = department.MgrSSN
AND ROWNUM <=1;
-- Now we assign values
BestManager.BonusPayment.CashPayment := 10000;
BestManager.BonusPayment.CompanyCar := TRUE;
BestManager.BonusPayment.VacationWeeks := 2;
--Output inactive
dbms_output.put_line('');
dbms_output.put_line('Best manager SSN: ' || BestManager.ssn);
dbms_output.put_line('BestManager bonus: $ ' || BestManager.BonusPayment.CashPayment);
--Logical test MGR (IF) 
IF BestManager.BonusPayment.CompanyCar = True THEN
dbms_output.put_line('Company Car also provided');
END IF;
--Test MGR for vacation weeks
IF BestManager.BonusPayment.VacationWeeks >0 THEN
dbms_output.put_line('Extra vacation weeks granted: ' || BestManager.BonusPayment.VacationWeeks);
END IF;
END;
--------------------Something like Scanner, when user give value
SET SERVEROUTPUT ON;
declare 
        nValue Number(10) := &enter_value;
        vMessage Varchar(30):= q'!The value isn't valid!';
        
Begin
        IF nValue > 6000 then
            dbms_output.put_line(vMessage);
            END IF;
END;
/
----------------------Number Variable
SET SERVEROUTPUT ON;
declare 
        EmpSalary employee.Salary%TYPE;
        EmpRaisePct NUMBER (2);
                
Begin
        --we are setting the variables
        EmpSalary := &enter_salary;
        EmpRaisePct := 10;
        --Display the starting salary
        dbms_output.put_line('Current Salary '|| EmpSalary);
        --Calculate new one
        EmpSalary := EmpSalary +(EmpSalary*(EmpRaisePct/100));
        dbms_output.put_line('NewSalary '||EmpSalary );
        
END;
/
----------------------------Loop
SET SERVEROUTPUT ON;
declare 
        v_cnt simple_integer :=1;
                
Begin
      loop
      dbms_output.put_line(v_cnt);
      v_cnt := v_cnt +1;
        exit when v_cnt >20;
        end loop;
  END;
/
----------------------------While
SET SERVEROUTPUT ON;
declare 
        v_cnt simple_integer :=1;
                
Begin
      while v_cnt<= 20 loop
      dbms_output.put_line(v_cnt);
      v_cnt := v_cnt +1;
      end loop;
  END;
/
---------------------------FOR
SET SERVEROUTPUT ON;
declare 
        v_cnt simple_integer :=1;
                
Begin
      for v_cnt in 1..20 loop
      dbms_output.put_line(v_cnt);
      end loop;
  END;
/
-----------Kursor niejawny
SET SERVEROUTPUT ON;
declare 
        v_cnt simple_integer :=1;         
Begin
      for v_cnt in (select * from employee) loop
      dbms_output.put_line(v_cnt.FNAME);
      end loop;
  END;
/
----------Sysdate
SET SERVEROUTPUT ON;
declare 
        EmpReviewDate employee.Bdate%Type;   
        EmpNextReview EmpReviewDate%Type; 
Begin
        EmpReviewDate := Sysdate;
        EmpNextReview := EmpReviewDate +100;
        
        dbms_output.put_line('Current date '||EmpReviewDate);
        dbms_output.put_line('Next Review '||EmpNextReview);
  END;
/
------------------------------------------------Boolean
SET SERVEROUTPUT ON;
declare 
        EmpSalary employee.salary%Type;   
        HighPaid Boolean := FALSE; 
Begin
        EmpSalary := &enter_salary_amunt;
        HighPaid := (EmpSalary > 4000);
        
        IF HighPaid Then
        dbms_output.put_line('Yes that salary is high ');
        else 
        dbms_output.put_line('No this salary is less ');
        END IF;
  END;
-------------------------------------------------------Comparison
SET SERVEROUTPUT ON;
declare 
        vCharacters VARCHAR2(10) :='Doe';   
        vMessageText VARCHAR2(30); 
Begin
        if vCharacters = 'Doe'
        OR vCharacters != 'Doe'
        OR vCharacters IS NOT NULL
        OR vCharacters LIKE 'D%'
        OR vCharacters in ('Doe', 'Smith', 'Jones')
        OR vCharacters BETWEEN 'Daa' AND 'Dzz' THEN
        vMessageText := 'String';
        dbms_output.put_line(vMessageText);
       
        END IF;
  END;
--------------------------------------Functions
SET SERVEROUTPUT ON;
declare 
        TYPE EmpRecord
        IS RECORD (ssn employee.ssn%TYPE,
        LName employee.LName%TYPE,
        DName employee.DName%TYPE,
        BonusPayment number(6));
        
        BestEmp EmpRecord;
Begin
    Select essn, LName, DName, 5000
    INTO BestEmp
    FROM EMPLOYEE, DEPARTMENT, WORKS_ON
    Where employee.dno = DEPARTMENT.DNUMBER
    AND employee.ssn = WORKS_ON.ESSN
    AND hours = (Select MAX(hours) from WORKS_ON)
    AND ROWNUM <= 1;
    
    dbms_output.put_line('Best employee name: ' || UPPER(BestEmp.LName));
    dbms_output.put_line('Best employee bonus: '||ROUND(BestEmp.BonusPayment *1.15 - 3));
  END;


            