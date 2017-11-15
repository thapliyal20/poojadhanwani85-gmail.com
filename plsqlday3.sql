--triggers
drop table product_check;
CREATE TABLE product_check
(Message varchar2(50), 
 Current_Date date
);

drop table product;
CREATE TABLE product 
(product_id number(5), 
product_name varchar2(32), 
supplier_name varchar2(32), 
unit_price number(7,2) ); 

CREATE or REPLACE TRIGGER Before_Update_Stat_product 
BEFORE 
UPDATE ON product 
Begin 
INSERT INTO product_check 
Values('Before update, statement level',sysdate); 
END; 

 CREATE or REPLACE TRIGGER Before_Upddate_Row_product 
 BEFORE 
 UPDATE ON product 
 FOR EACH ROW 
 BEGIN 
 INSERT INTO product_check 
 Values('Before update row level',sysdate); 
 END; 

CREATE or REPLACE TRIGGER After_Update_Stat_product 
 AFTER 
 UPDATE ON product 
 BEGIN 
 INSERT INTO product_check 
 Values('After update, statement level', sysdate); 
 End; 


CREATE or REPLACE TRIGGER After_Update_Row_product 
 AFTER  
 update On product 
 FOR EACH ROW 
 BEGIN 
 INSERT INTO product_check 
 Values('After update, Row level',sysdate); 
 END; 


CREATE OR REPLACE PACKAGE Staff_Data AS
  TYPE staffcurtype is REF CURSOR RETURN
  Staff_Masters%ROWTYPE;
   PROCEDURE Open_Staff_Cur(staff_cur IN OUT staffcurtype);
  END Staff_Data;

UPDATE PRODUCT SET unit_price = 900 
 WHERE product_id in (10,20); 

--Pkg body

CREATE OR REPLACE PACKAGE BODY Staff_Data AS
    PROCEDURE Open_Staff_Cur(staff_cur IN OUT  staffcurtype) IS
       BEGIN
            OPEN staff_cur for SELECT * FROM Staff_Masters;
        END;
  END;
--Exccution
VARIABLE cv  REF CURSOR ;
SET autoprint on;
EXECUTE Staff_Data.Open_Staff_Cur(:cv);




 CREATE OR REPLACE PACKAGE Staff_Data AS
     TYPE staffcurtyp is ref cursor return  
     staff_masters%rowtype;
   PROCEDURE Open_Staff_Cur(staff_cur IN OUT staffcurtyp);
  END Staff_Data;  

 CREATE OR REPLACE PACKAGE BODY Staff_Data AS 
PROCEDURE Open_Staff_Cur (staff_cur IN OUT staffcurtyp) IS
BEGIN
	OPEN staff_cur  for SELECT * FROM staff_masters;
	end Open_Staff_Cur;
END Staff_Data;

 VARIABLE cv REFCURSOR
 
 set autoprint on

execute Staff_Data.Open_Staff_Cur(:cv);


CREATE OR REPLACE PACKAGE BODY Pack1 AS
    PROCEDURE Proc1 IS
    BEGIN
	dbms_output.put_line('hi a message frm procedure');
    END Proc1;
	function Fun1 return varchar2 IS
    BEGIN
	return ('hello from fun1');
    END Fun1;
END Pack1;


CREATE OR REPLACE PACKAGE Pack1 AS
	PROCEDURE Proc1;
	FUNCTION Fun1 return varchar2;
END pack1;	


EXEC Pack1.Proc1;

SELECT Pack1.Fun1 from dual;

--Function
--2)
variable flag varchar2(60);
EXECUTE :flag:=hellohi('Arvind');
PRINT flag;
--3)
DECLARE
flag varchar2(20);
BEGIN
    flag:= hellohi('Manoj');
    dbms_output.put_line(flag);
END;
--1)
SELECT hellohi(10) FROM dual;

CREATE OR REPLACE FUNCTION hellohi(dno IN NUMBER) 
RETURN  VARCHAR2 AS
v_name DEPARTMENT_MASTERS.DEPT_NAME%TYPE;
BEGIN
    SELECT dept_name INTO v_name 
      FROM department_masters
      WHERE dept_code=dno;
    RETURN v_name;
END;





CREATE OR REPLACE PROCEDURE get_data_by_id(did IN NUMBER) IS
CURSOR c1 IS SELECT s.staff_code,s.staff_name,d.dept_name
FROM staff_masters s,department_masters d
WHERE s.dept_code=d.dept_code AND s.dept_code=did;
BEGIN
    FOR temp IN c1 
    LOOP
          dbms_output.put_line('Staff_code ' || temp.staff_code || 'Staff Name '|| temp.staff_name 
          || ' Dname ' || temp.dept_name);
    END LOOP;
END;


EXECUTE get_data_by_id(30);

CREATE OR REPLACE PROCEDURE get_all_data IS
v_name EMPLOYEE.EMPNAME%TYPE;
v_sal employee.salary%TYPE;

CURSOR c1 IS SELECT empname,salary FROM Employee;
BEGIN
   FOR temp IN c1
  LOOP
      dbms_output.put_line('Name ' || temp.empname  || '   Salary: ' ||temp.salary);
      
  END LOOP;
END;




DECLARE
v_id EMPLOYEE.EMPID%TYPE:=451;
v_name EMPLOYEE.EMPNAME%TYPE;
v_sal employee.salary%TYPE;
BEGIN
        getDetails(V_ID,v_name,v_sal);
         dbms_output.put_line('The Employee details withj the ID ' || v_id ||' are' );
         dbms_output.put_line('Name : '|| v_name ||' Salary :' || v_sal); 
END;

--Procedures 
CREATE OR REPLACE PROCEDURE getDetails(id IN employee.empid%type,
name OUT EMPLOYEE.EMPNAME%TYPE,salary OUT EMPLOYEE.SALARY%TYPE)
AS
BEGIN
  SELECT empname,salary INTO name,salary
  FROM Employee
  WHERE empid=id;
END;





DECLARE
num3 number;
BEGIN
    calculate(10,15,num3);
    DBMS_OUTPUT.PUT_LINE('The sum of two numbers is ' || num3);
END;

variable sum number;
EXECUTE calculate(25,30,:sum);
PRINT sum;

CREATE OR REPLACE PROCEDURE calculate(num1 IN NUMBER,num2 IN number,res OUT NUMBER)AS
BEGIN
  res:=num1+num2;
END;


BEGIN
     hello('Arvind');
END;

--calling procedure
EXECUTE hello('Smith');

CREATE OR REPLACE PROCEDURE hello(name IN VARCHAR2 ) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello...... '|| name);
END;





--USer defined exception

DECLARE
dup_deptno EXCEPTION;
v_count BINARY_INTEGER;



BEGIN
    SELECT count(*) INTO v_count
    FROM dept 
    WHERE deptno=95;
    
     IF v_count>1 THEN
          RAISE dup_deptno;
    END IF;
    dbms_output.put_line('Count is :'  || v_count);
    
EXCEPTION
    WHEN dup_deptno THEN
           dbms_output.put_line('Dept already exists!!!' );
    
END;



--Numbered exception
DECLARE
    v_bookno number:=10000006;
    child_rec_found EXCEPTION;
    PRAGMA EXCEPTION_INIT ( child_rec_found, -2292);

BEGIN
    DELETE FROM book_masters
    where BOOK_CODE=v_bookno;
    dbms_output.put_line('record deleted successfully');
EXCEPTION
    WHEN child_rec_found THEN
    dbms_output.put_line('The record cant be deleted as it has a child record');
END;





--predefined exception
DECLARE
v_dname dept.DNAME%TYPE;
BEGIN
  SELECT dname INTO v_dname 
  FROM dept;
  --WHERE deptno=10;
  dbms_output.put_line(v_dname);
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
            SYS.DBMS_OUTPUT.PUT_LINE('No data found');
    WHEN TOO_MANY_ROWS THEN
           SYS.DBMS_OUTPUT.PUT_LINE('Many departments exist with that id');
END;




create table department
(
deptid char(4),
deptname varchar(15),
depthead varchar(15)
);

insert into department values ('D01','HR','Anjan');
insert into department values ('D02','Sales','Kavitha');
insert into department values ('D03','Finance','Suresh');
insert into department values ('D04','Admin',null);
insert into department values ('D05','System','Ravi');

drop table department;
create table employ
(
empid char(4),
fname varchar(15),
lname varchar(15),
salary number(6),
deptid char(4)
);

insert into employ values ('E01','Rahul','Raj',20000,'D02');
insert into employ values ('E02','Anil','Babu',24000,'D01');
insert into employ values ('E03','Samir','Thahir',20000,'D03');
insert into employ values ('E04','Jaya','Krishnan',23000,'D01');

insert into employ values ('E05','Suresh','Peters',20000,'D01');
insert into employ values ('E06','Karthik','Kumar',20000,'D02');
insert into employ values ('E07','Bhavana','Aravind',20000,'D02');
insert into employ values ('E08','Steven','Devassy',20000,'D03');
insert into employ values ('E09','Abdul','Rahim',28000,null);
insert into employ values ('E10','Manoj','Kumar',30000,null);

BEGIN
  p_printEmps('D01');
END;


create or replace procedure p_printEmps(did IN department.deptid%TYPE) is
       cursor c_emp is
       select e.fname,e.empid,d.deptid,d.deptname
       from employ e,department d
       where e.deptid=d.deptid AND d.deptid=did;
       
      v_fname EMPLOY.FNAME%TYPE;
      v_eid EMPLOY.EMPID%TYPE;
      v_did DEPARTMENT.DEPTID%TYPE;
      v_dname DEPARTMENT.DEPTNAME%TYPE;
   begin
       open c_emp;
        loop
         fetch c_emp into v_fname,v_eid,v_did,v_dname;
         exit when c_emp%NOTFOUND;
         DBMS_OUTPUT.put_line(v_fname ||'  '||v_eid||' '||v_did||'  '||v_dname);
     end loop;
     close c_emp;
   end;


CREATE FUNCTION Crt_Dept(dno number,
dname varchar2) RETURN number AS
BEGIN
INSERT into dept(deptno,dname)
VALUES (dno,dname) ;
return 1 ;
EXCEPTION
WHEN others THEN
return 0 ;
END crt_dept ;

DECLARE
flag varchar2(20);
BEGIN
flag:= Crt_Dept(95,'nn');
END;


select Crt_Dept(95,'newdept') from dual;

   CREATE OR REPLACE PROCEDURE
        Get_Details(s_code IN number,s_name OUT varchar2,s_sal OUT number ) IS
   BEGIN
      SELECT staff_name, staff_sal INTO s_name, s_sal 
      FROM staff_masters WHERE staff_code=s_code;
   EXCEPTION
         WHEN no_data_found  THEN
        dbms_output.put_line('no record found');
END get_details ;


DECLARE
name STAFF_MASTERS.STAFF_NAME%TYPE;
salary STAFF_MASTERS.STAFF_SAL%TYPE;

BEGIN
  EXECUTE Get_Details(100003,name,salary);
  dbms_out.put_line(name);
  dbms_out.put_line(salary);
END;

variable salary number
variable name varchar2(20)

EXECUTE Get_Details(100003,:name,:salary);

PRINT name
print salary

--Ref Cursors

DECLARE
--declare ref cursor
  TYPE deptcurtype IS REF CURSOR RETURN
  department_masters%ROWTYPE;
  --declaring variable of ref cursor type
  dept_cv deptcurtype;
 dept_details department_masters%ROWTYPE;
BEGIN
    OPEN dept_cv FOR SELECT * FROM department_masters ;
    LOOP
        EXIT WHEN dept_cv%NOTFOUND;
        FETCH dept_cv INTO dept_details;
        DBMS_OUTPUT.PUT_LINE('dcode' || dept_details.dept_code ||'Dname ' ||dept_details.dept_name);
    END LOOP;
    
    CLOSE dept_cv;
  END;



--cursor with parameters

DECLARE
v_scode Number:=&code;
  CURSOR c1(sid NUMBER) IS SELECT * FROM Student_Masters WHERE student_code=sid;
 BEGIN
   -- OPEN c1(1001);
    FOR temp IN c1(v_scode)
    LOOP
      DBMS_OUTPUT.PUT_LINE('Student code: ' || temp.student_code);
      DBMS_OUTPUT.PUT_LINE('Student Name: ' || temp.student_name);
      DBMS_OUTPUT.PUT_LINE('dept code: ' || temp.dept_code);
      
      DBMS_OUTPUT.PUT_LINE('stud dob: '|| temp.student_dob);
      DBMS_OUTPUT.PUT_LINE('stud dob: '|| temp.student_address);
      
    END LOOP;
END;


DECLARE
v_total_mks number;
CURSOR c1 IS SELECT  * FROM Student_Marks;

BEGIN

FOR mks IN c1
LOOP
      v_total_mks:=mks.subject1+mks.subject2+mks.subject3;
      if(V_TOTAL_MKS>250) THEN
      INSERT INTO Performance VALUES(mks.student_code,v_total_mks);
      ELSE
      dbms_output.put_line(mks.student_code ||'  '|| v_total_mks);
      END IF;
END LOOP;
END;

CREATE TABLE Performance(
sid NUMBER,
total_mks number);

select * from performance;


--ref cursor

DECLARE
TYPE deptcurtype  IS REF CURSOR RETURN
department_masters%ROWTYPE;
dept_cv deptcurtype;
dept_details department_masters%ROWTYPE;
BEGIN
OPEN dept_cv FOR select * FROM department_masters;
LOOP
EXIT WHEN dept_cv%NOTFOUND;
FETCH dept_cv INTO dept_details;
dbms_output.put_line(dept_details.dept_name || ',' || dept_details.dept_code);
END LOOP;
CLOSE dept_cv;
END;


--Explicit cursor
DECLARE
--c_code STUDENT_MASTERS.STUDENT_CODE%TYPE;
--c_name STUDENT_MASTERS.STUDENT_NAME%TYPE;
CURSOR c1 IS
SELECT student_code,student_name
FROM student_masters
WHERE student_address='Chennai';

BEGIN

 -- OPEN c1;
  --FETCH c1 INTO c_code,c_name;
  --WHILE c1%FOUND
  FOR studrec IN c1
    LOOP
      
       -- EXIT WHEN c1%NOTFOUND;
        SYS.DBMS_OUTPUT.PUT_LINE(studrec.student_code ||'   '||studrec.student_name);
        --   FETCH c1 INTO c_code,c_name;
END LOOP;
--CLOSE c1;
END;

select * from emp;




 --updating the salary
 
 
DECLARE
v_sal staff_masters1.staff_sal%TYPE;
v_scode staff_masters1.staff_code%TYPE;
CURSOR c_staffsal IS
select staff_code,staff_sal FROM staff_masters1
WHERE staff_sal<28000;
BEGIN
OPEN c_staffsal;
--fetch before the loop
FETCH c_staffsal into v_scode,v_sal;
WHILE c_staffsal%FOUND
LOOP
   UPDATE staff_masters1
   SET staff_sal=v_sal*1.1
   WHERE staff_code=v_scode;
FETCH c_staffsal into v_scode,v_sal;
END LOOP;
CLOSE c_staffsal;
END;
 
 
 
 
 
 
 
 DECLARE
 c_id EMPLOYEE.EMPID%TYPE;
  c_name EMPLOYEE.EMPNAME%TYPE;
  c_salary  EMPLOYEE.SALARY%TYPE;
 --1. declare the cursor
      CURSOR c1 IS 
      SELECT empid,empname,salary 
      FROM Employee;
BEGIN

        UPDATE employee
          SET salary=salary+(.3)*SALARY;
    --2. open the cursor
    OPEN c1;
    --3.Fetch
    LOOP
          FETCH c1 INTO c_id, c_name,c_salary;
          --Termination condition
         /* UPDATE employee
          SET salary=salary+(.3)*SALARY
          WHERE empid=c_id;
            DBMS_OUTPUT.PUT_LINE('Updated salary');*/
      EXIT WHEN c1%NOTFOUND;
         --Process
          DBMS_OUTPUT.PUT_LINE('Name is : ' ||c_name ||'   '||' Salary is :' ||c_salary);
     END LOOP;
     --4 Close the cursor
     CLOSE c1;
 END;
 






set serveroutput on
--Implicit Cursor

BEGIN
  
    UPDATE dept SET dname='test' WHERE DEPTNO=94;
     IF SQL%ROWCOUNT=0 THEN
        INSERT INTO dept VALUES(94,'test','Chennai');
    END IF;
  END;
    


DECLARE
  v_dname DEPT.DNAME%TYPE;
BEGIN
    SELECT dname INTO v_dname  FROM Dept WHERE deptno=94;
   -- UPDATE dept SET dname='testing' WHERE DEPTNO=94;
    /*  IF SQL%NOTFOUND THEN
        INSERT INTO dept VALUES(92,'testing','Bangalore');
    END IF;*/
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No record found with the given deptid');
      END;
    


--Cursors

DECLARE
v_name VARCHAR2(20);
v_sal employee.salary%TYPE;
BEGIN
    SELECT empname,salary
    INTO v_name,v_sal
    FROM employee
    WHERE empid=333;
    DBMS_OUTPUT.PUT_LINE(' EMployee : ' || v_name || ' has a salary '|| v_sal);

EXCEPTION
      WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No employee matches the given emp no');
        WHEN TOO_MANY_ROWS THEN
              DBMS_OUTPUT.PUT_LINE('More than one employee  matches the given emp no');

END;


DECLARE

v_eno number;
v_name varchar2(20);
CURSOR c1 IS
    SELECT empno,ename
    FROM employee;
    
    BEGIN
    OPEN c1;
    LOOP
     FETCH c1 INTO v_eno,v_ename;
     EXIT WHEN c1%NOTFOUND;
     dbms_output.put_line(to_char(eno) ||'   '|| v_name);
     END LOOP;
     CLOSE c1;
    END;
    